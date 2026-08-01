import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/cat_profiles/domain/cat_profile_draft.dart';
import 'package:pawsense/features/personalisation/data/preference_repository.dart';
import 'package:pawsense/features/personalisation/domain/algorithm_version.dart';
import 'package:pawsense/features/play/data/session_repository.dart';
import 'package:pawsense/features/play/domain/session_models.dart';
import 'package:pawsense/features/training/data/cue_progress_repository.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FakeClock clock;
  late SessionRepository repo;
  late PreferenceRepository preferences;
  late CatProfileRepository profiles;
  late String catId;

  const config = TrialConfiguration(
    preyType: PreyType.moth,
    movementStyle: MovementStyle.stopAndGo,
    speedLevel: SpeedLevel.slow,
    sizeLevel: SizeLevel.large,
    soundMode: SoundMode.silent,
    spawnZone: SpawnZone.centre,
  );

  SessionPlan plan({SessionMode mode = SessionMode.freePlay, String? cat}) =>
      SessionPlan(
        mode: mode,
        catId: cat,
        plannedDurationSeconds: 180,
        soundEnabled: true,
        seed: 42,
        initialDifficulty: 2,
        rewardSchedule: RewardSchedule.none,
        maxRewardReminders: 3,
        isCalibration: false,
      );

  TrialRecord trial({
    int index = 0,
    bool success = true,
    bool timedOut = false,
    int? reactionMs = 800,
    CueType? cue,
    int severity = 0,
  }) => TrialRecord(
    trialIndex: index,
    configuration: config,
    spawnedAtMs: 3000 + index * 5000,
    becameTouchableAtMs: 3250 + index * 5000,
    endedAtMs: 4000 + index * 5000,
    spawnXNormalised: 0.5,
    spawnYNormalised: 0.5,
    pathSeed: 7,
    success: success,
    firstSuccessfulTouchAtMs: success ? 4000 + index * 5000 : null,
    reactionTimeMs: success ? reactionMs : null,
    missCount: success ? 0 : 2,
    timedOut: timedOut,
    cueType: cue,
    praiseCueType: null,
    rewardReminderShown: false,
    frustrationSeverity: severity,
    frustrationFlags: const {},
    difficultyAtTrial: 2,
  );

  TouchRecord touch({int? trialIndex = 0}) => TouchRecord(
    trialIndex: trialIndex,
    pointerId: 1,
    logicalInteractionId: 1,
    occurredAtMs: 4000,
    xNormalised: 0.5,
    yNormalised: 0.5,
    classification: TouchClassification.hit,
    deduplicated: false,
    distanceFromTarget: 0.01,
  );

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('pawsense_session_test');
    clock = FakeClock(DateTime.utc(2026, 8, 1, 9));
    const uuid = Uuid();
    preferences = PreferenceRepository(db, clock, uuid);
    repo = SessionRepository(
      db,
      clock,
      uuid,
      preferences,
      CueProgressRepository(db, clock, uuid),
    );
    profiles = CatProfileRepository(db, clock, uuid, FileService(tempDir));
    catId = (await profiles.create(const CatProfileDraft(name: 'Tiger'))).id;
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  test('createSession persists an inProgress row with metadata', () async {
    final (id, startedAt) = await repo.createSession(
      plan: plan(cat: catId),
      screenWidthLogical: 1024,
      screenHeightLogical: 768,
      appVersion: '0.1.0',
      platform: 'test',
      algorithmVersion: algorithmVersion,
    );
    final session = (await repo.getSession(id))!;
    expect(session.status, SessionStatus.inProgress);
    expect(session.catId, catId);
    expect(session.randomSeed, 42);
    expect(session.startedAtUtc, startedAt);
    expect(session.screenWidthLogical, 1024);
  });

  test('trials and touches persist with session-anchored UTC times', () async {
    final (id, startedAt) = await repo.createSession(
      plan: plan(cat: catId),
      screenWidthLogical: 1024,
      screenHeightLogical: 768,
      appVersion: '0.1.0',
      platform: 'test',
      algorithmVersion: algorithmVersion,
    );
    await repo.insertTrialWithTouches(
      sessionId: id,
      sessionStartUtc: startedAt,
      trial: trial(),
      touches: [touch(), touch(trialIndex: null)],
      algorithmVersion: algorithmVersion,
    );

    final trials = await repo.trialsForSession(id);
    expect(trials, hasLength(1));
    expect(
      trials.single.spawnedAtUtc,
      startedAt.add(const Duration(milliseconds: 3000)),
    );
    expect(trials.single.reactionTimeMs, 800);
    expect(trials.single.trialReward, greaterThan(1.0));

    final touches = await db.select(db.touchEvents).get();
    expect(touches, hasLength(2));
    expect(touches.first.trialId, trials.single.id);
    expect(
      touches.last.trialId,
      isNull,
      reason: 'between-trial touches attach to no trial',
    );
  });

  test(
    'finaliseSession writes aggregates, stats, and difficulty in one go',
    () async {
      final (id, startedAt) = await repo.createSession(
        plan: plan(cat: catId),
        screenWidthLogical: 1024,
        screenHeightLogical: 768,
        appVersion: '0.1.0',
        platform: 'test',
        algorithmVersion: algorithmVersion,
      );
      final trials = [
        trial(index: 0, reactionMs: 700, cue: CueType.touch),
        trial(index: 1, reactionMs: 1100, cue: CueType.touch),
        trial(index: 2, success: false, timedOut: true, cue: CueType.touch),
      ];
      for (final t in trials) {
        await repo.insertTrialWithTouches(
          sessionId: id,
          sessionStartUtc: startedAt,
          trial: t,
          touches: [touch(trialIndex: t.trialIndex)],
          algorithmVersion: algorithmVersion,
        );
      }

      await repo.finaliseSession(
        sessionId: id,
        summary: const SessionSummary(
          status: SessionStatus.completed,
          actualDurationMs: 180000,
          catches: 2,
          misses: 2,
          timeouts: 1,
          medianReactionMs: 900,
          frustrationCount: 0,
          endDifficulty: 3,
        ),
        trials: trials,
      );

      final session = (await repo.getSession(id))!;
      expect(session.status, SessionStatus.completed);
      expect(session.catches, 2);
      expect(session.medianReactionMs, 900);
      expect(session.endedAtUtc, isNotNull);

      // Preference stats got the three valid trials.
      final snapshot = await preferences.loadSnapshot(catId);
      final mothStats = snapshot.statsFor(FactorType.targetType, 'moth');
      expect(mothStats.impressions, closeTo(2.985, 0.02));
      expect(mothStats.successes, closeTo(1.99, 0.02));
      expect(mothStats.timeouts, closeTo(1, 0.02));

      // Cue progress recorded exposures + successes.
      final cueRows = await db.select(db.cueProgress).get();
      expect(cueRows.single.exposures, 3);
      expect(cueRows.single.successfulResponses, 2);

      // Difficulty persisted onto the profile.
      final cat = (await profiles.getById(catId))!;
      expect(cat.currentDifficulty, 3);
    },
  );

  test('mixed sessions never touch preference stats or profiles', () async {
    final difficultyBefore = (await profiles.getById(catId))!.currentDifficulty;
    final (id, startedAt) = await repo.createSession(
      plan: plan(mode: SessionMode.mixed, cat: null),
      screenWidthLogical: 1024,
      screenHeightLogical: 768,
      appVersion: '0.1.0',
      platform: 'test',
      algorithmVersion: algorithmVersion,
    );
    final t = trial();
    await repo.insertTrialWithTouches(
      sessionId: id,
      sessionStartUtc: startedAt,
      trial: t,
      touches: [touch()],
      algorithmVersion: algorithmVersion,
    );
    await repo.finaliseSession(
      sessionId: id,
      summary: const SessionSummary(
        status: SessionStatus.completed,
        actualDurationMs: 60000,
        catches: 1,
        misses: 0,
        timeouts: 0,
        medianReactionMs: 800,
        frustrationCount: 0,
        endDifficulty: 4,
      ),
      trials: [t],
    );
    expect(await db.select(db.preferenceStats).get(), isEmpty);
    final cat = (await profiles.getById(catId))!;
    expect(
      cat.currentDifficulty,
      difficultyBefore,
      reason: 'profile untouched',
    );
  });

  test('crash recovery finalises stale sessions as interrupted', () async {
    final (id, startedAt) = await repo.createSession(
      plan: plan(cat: catId),
      screenWidthLogical: 1024,
      screenHeightLogical: 768,
      appVersion: '0.1.0',
      platform: 'test',
      algorithmVersion: algorithmVersion,
    );
    await repo.insertTrialWithTouches(
      sessionId: id,
      sessionStartUtc: startedAt,
      trial: trial(index: 0),
      touches: [touch()],
      algorithmVersion: algorithmVersion,
    );
    await repo.insertTrialWithTouches(
      sessionId: id,
      sessionStartUtc: startedAt,
      trial: trial(index: 1, success: false, timedOut: true),
      touches: const [],
      algorithmVersion: algorithmVersion,
    );

    // Simulate a crash: app relaunches and recovers.
    final recovered = await repo.recoverInterruptedSessions();
    expect(recovered, 1);

    final session = (await repo.getSession(id))!;
    expect(session.status, SessionStatus.interrupted);
    expect(session.catches, 1);
    expect(session.timeouts, 1);
    expect(session.medianReactionMs, 800);
    expect(session.endedAtUtc, isNotNull);

    // Preserved trials remain; preference model deliberately untouched.
    expect(await repo.trialsForSession(id), hasLength(2));
    expect(await db.select(db.preferenceStats).get(), isEmpty);

    // Recovery is idempotent.
    expect(await repo.recoverInterruptedSessions(), 0);
  });

  test('deleteSession cascades its trials and touches only', () async {
    final (id, startedAt) = await repo.createSession(
      plan: plan(cat: catId),
      screenWidthLogical: 1024,
      screenHeightLogical: 768,
      appVersion: '0.1.0',
      platform: 'test',
      algorithmVersion: algorithmVersion,
    );
    await repo.insertTrialWithTouches(
      sessionId: id,
      sessionStartUtc: startedAt,
      trial: trial(),
      touches: [touch()],
      algorithmVersion: algorithmVersion,
    );
    await repo.deleteSession(id);
    expect(await repo.getSession(id), isNull);
    expect(await db.select(db.targetTrials).get(), isEmpty);
    expect(await db.select(db.touchEvents).get(), isEmpty);
  });

  test('deleteHistoryForCat removes all its sessions', () async {
    for (var i = 0; i < 3; i++) {
      await repo.createSession(
        plan: plan(cat: catId),
        screenWidthLogical: 1024,
        screenHeightLogical: 768,
        appVersion: '0.1.0',
        platform: 'test',
        algorithmVersion: algorithmVersion,
      );
    }
    await repo.deleteHistoryForCat(catId);
    expect(await repo.watchSessionsForCat(catId).first, isEmpty);
  });
}
