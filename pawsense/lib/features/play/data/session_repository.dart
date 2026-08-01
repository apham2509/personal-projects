import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/clock.dart';
import '../../../core/utils/stats.dart';
import '../../../shared/models/enums.dart';
import '../../personalisation/data/preference_repository.dart';
import '../../training/data/cue_progress_repository.dart';
import '../domain/session_models.dart';

/// Persists sessions, trials, and touch events; owns finalisation and crash
/// recovery. All timestamps stored UTC; in-session times arrive as
/// monotonic ms offsets and are anchored to the session start instant.
class SessionRepository {
  SessionRepository(
    this._db,
    this._clock,
    this._uuid,
    this._preferences,
    this._cueProgress,
  );

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;
  final PreferenceRepository _preferences;
  final CueProgressRepository _cueProgress;

  /// Inserts the session as inProgress and returns (id, startedAtUtc).
  Future<(String, DateTime)> createSession({
    required SessionPlan plan,
    required double screenWidthLogical,
    required double screenHeightLogical,
    required String appVersion,
    required String platform,
    required String algorithmVersion,
  }) async {
    final id = _uuid.v4();
    final now = _clock.nowUtc();
    await _db
        .into(_db.sessions)
        .insert(
          SessionsCompanion.insert(
            id: id,
            catId: Value(plan.catId),
            mode: plan.mode,
            startedAtUtc: now,
            plannedDurationSeconds: plan.plannedDurationSeconds,
            status: SessionStatus.inProgress,
            calibrationSession: plan.isCalibration,
            randomSeed: plan.seed,
            algorithmVersion: algorithmVersion,
            appVersion: appVersion,
            platform: platform,
            screenWidthLogical: screenWidthLogical,
            screenHeightLogical: screenHeightLogical,
            catches: 0,
            misses: 0,
            timeouts: 0,
            frustrationCount: 0,
            createdAtUtc: now,
            updatedAtUtc: now,
          ),
        );
    return (id, now);
  }

  /// Writes one finished trial plus its touch events. Called at trial
  /// boundaries (never inside the frame loop). Returns the trial row id.
  Future<String> insertTrialWithTouches({
    required String sessionId,
    required DateTime sessionStartUtc,
    required TrialRecord trial,
    required List<TouchRecord> touches,
    required String algorithmVersion,
  }) async {
    final trialId = _uuid.v4();
    DateTime at(int ms) => sessionStartUtc.add(Duration(milliseconds: ms));

    await _db.transaction(() async {
      await _db
          .into(_db.targetTrials)
          .insert(
            TargetTrialsCompanion.insert(
              id: trialId,
              sessionId: sessionId,
              trialIndex: trial.trialIndex,
              targetType: trial.configuration.preyType,
              movementStyle: trial.configuration.movementStyle,
              speedLevel: trial.configuration.speedLevel,
              sizeLevel: trial.configuration.sizeLevel,
              soundMode: trial.configuration.soundMode,
              spawnZone: trial.configuration.spawnZone,
              spawnedAtUtc: at(trial.spawnedAtMs),
              becameTouchableAtUtc: at(trial.becameTouchableAtMs),
              endedAtUtc: Value(at(trial.endedAtMs)),
              spawnXNormalised: trial.spawnXNormalised,
              spawnYNormalised: trial.spawnYNormalised,
              targetPathSeed: trial.pathSeed,
              success: trial.success,
              firstSuccessfulTouchAtUtc: Value(
                trial.firstSuccessfulTouchAtMs == null
                    ? null
                    : at(trial.firstSuccessfulTouchAtMs!),
              ),
              reactionTimeMs: Value(trial.reactionTimeMs),
              missCount: trial.missCount,
              timeout: trial.timedOut,
              cueType: Value(trial.cueType),
              praiseCueType: Value(trial.praiseCueType),
              rewardReminderShown: trial.rewardReminderShown,
              frustrationSeverity: trial.frustrationSeverity,
              frustrationFlags: trial.frustrationFlags,
              trialReward: PreferenceRepository.rewardFor(trial),
              algorithmVersion: algorithmVersion,
            ),
          );
      await _db.batch((batch) {
        for (final touch in touches) {
          batch.insert(
            _db.touchEvents,
            TouchEventsCompanion.insert(
              id: _uuid.v4(),
              sessionId: sessionId,
              trialId: Value(touch.trialIndex == null ? null : trialId),
              pointerId: touch.pointerId,
              logicalInteractionId: touch.logicalInteractionId,
              occurredAtUtc: at(touch.occurredAtMs),
              xNormalised: touch.xNormalised,
              yNormalised: touch.yNormalised,
              classification: touch.classification,
              deduplicated: touch.deduplicated,
              distanceFromTarget: Value(touch.distanceFromTarget),
              createdAtUtc: _clock.nowUtc(),
            ),
          );
        }
      });
    });
    return trialId;
  }

  /// Finalises the session transactionally: summary onto the session row,
  /// preference/cue-progress updates (individual cats only), and the cat's
  /// new difficulty.
  Future<void> finaliseSession({
    required String sessionId,
    required SessionSummary summary,
    required List<TrialRecord> trials,
  }) async {
    final now = _clock.nowUtc();
    await _db.transaction(() async {
      final sessionQuery = _db.select(_db.sessions)
        ..where((s) => s.id.equals(sessionId));
      final session = await sessionQuery.getSingle();

      final update = _db.update(_db.sessions)
        ..where((s) => s.id.equals(sessionId));
      await update.write(
        SessionsCompanion(
          status: Value(summary.status),
          endedAtUtc: Value(now),
          actualDurationMs: Value(summary.actualDurationMs),
          catches: Value(summary.catches),
          misses: Value(summary.misses),
          timeouts: Value(summary.timeouts),
          medianReactionMs: Value(summary.medianReactionMs),
          frustrationCount: Value(summary.frustrationCount),
          updatedAtUtc: Value(now),
        ),
      );

      final catId = session.catId;
      if (catId != null && session.mode != SessionMode.mixed) {
        await _preferences.applyTrialUpdates(catId, trials);
        await _cueProgress.applyTrialUpdates(catId, trials);
        final profileUpdate = _db.update(_db.catProfiles)
          ..where((p) => p.id.equals(catId));
        await profileUpdate.write(
          CatProfilesCompanion(
            currentDifficulty: Value(summary.endDifficulty),
            updatedAtUtc: Value(now),
          ),
        );
      }
    });
  }

  Future<void> setOwnerFeedback(String sessionId, OwnerFeedback? feedback) {
    final query = _db.update(_db.sessions)
      ..where((s) => s.id.equals(sessionId));
    return query
        .write(
          SessionsCompanion(
            ownerSubjectiveFeedback: Value(feedback),
            updatedAtUtc: Value(_clock.nowUtc()),
          ),
        )
        .then((_) {});
  }

  /// Crash recovery: any session still inProgress at app start is finalised
  /// as interrupted, aggregated from whatever trials were persisted.
  /// Preference models are deliberately NOT updated from recovered
  /// sessions (the in-memory learning state died with the crash; raw
  /// history remains available).
  Future<int> recoverInterruptedSessions() async {
    final stale = await (_db.select(
      _db.sessions,
    )..where((s) => s.status.equals(SessionStatus.inProgress.name))).get();
    for (final session in stale) {
      final trials = await (_db.select(
        _db.targetTrials,
      )..where((t) => t.sessionId.equals(session.id))).get();
      final valid = trials.where((t) => t.success || t.timeout).toList();
      final reactions = valid
          .where((t) => t.success && t.reactionTimeMs != null)
          .map((t) => t.reactionTimeMs!);
      final lastEnd = trials.isEmpty
          ? session.startedAtUtc
          : trials
                .map((t) => t.endedAtUtc ?? t.spawnedAtUtc)
                .reduce((a, b) => a.isAfter(b) ? a : b);
      final update = _db.update(_db.sessions)
        ..where((s) => s.id.equals(session.id));
      await update.write(
        SessionsCompanion(
          status: const Value(SessionStatus.interrupted),
          endedAtUtc: Value(lastEnd),
          actualDurationMs: Value(
            lastEnd.difference(session.startedAtUtc).inMilliseconds,
          ),
          catches: Value(trials.where((t) => t.success).length),
          misses: Value(trials.fold(0, (sum, t) => sum + t.missCount)),
          timeouts: Value(trials.where((t) => t.timeout).length),
          medianReactionMs: Value(medianInt(reactions)),
          frustrationCount: Value(
            valid.where((t) => t.frustrationSeverity >= 1).length,
          ),
          updatedAtUtc: Value(_clock.nowUtc()),
        ),
      );
    }
    return stale.length;
  }

  Stream<List<Session>> watchSessionsForCat(String catId, {int limit = 50}) {
    final query = _db.select(_db.sessions)
      ..where((s) => s.catId.equals(catId))
      ..orderBy([(s) => OrderingTerm.desc(s.startedAtUtc)])
      ..limit(limit);
    return query.watch();
  }

  Future<Session?> getSession(String id) {
    final query = _db.select(_db.sessions)..where((s) => s.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<List<TargetTrial>> trialsForSession(String sessionId) {
    final query = _db.select(_db.targetTrials)
      ..where((t) => t.sessionId.equals(sessionId))
      ..orderBy([(t) => OrderingTerm.asc(t.trialIndex)]);
    return query.get();
  }

  Future<void> deleteSession(String sessionId) async {
    final query = _db.delete(_db.sessions)
      ..where((s) => s.id.equals(sessionId));
    await query.go();
  }

  /// Deletes all sessions (and cascading trials/events) for one cat.
  Future<void> deleteHistoryForCat(String catId) async {
    final query = _db.delete(_db.sessions)..where((s) => s.catId.equals(catId));
    await query.go();
  }
}
