import '../../../app/app_config.dart';
import '../../../core/random/seeded_random.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../../cat_profiles/data/cat_profile_repository.dart';
import '../../cat_profiles/domain/cat_profile_draft.dart';
import '../../personalisation/domain/algorithm_version.dart' as algo;
import '../../play/data/session_repository.dart';
import '../../play/domain/session_models.dart';

/// Deterministic synthetic data for the developer screen and screenshots.
/// Everything goes through the real repositories, so seeded data behaves
/// exactly like recorded play (including preference updates).
class DemoDataService {
  DemoDataService(this._profiles, this._sessions);

  final CatProfileRepository _profiles;
  final SessionRepository _sessions;

  /// Creates a demo cat with [sessionCount] synthetic sessions. The cat
  /// "prefers" moths on unpredictable paths; [struggling] simulates a cat
  /// that rarely catches (for testing the difficulty floor).
  Future<String> seedDemoCat({
    required int seed,
    int sessionCount = 6,
    bool struggling = false,
  }) async {
    final rng = SeededRandom(seed);
    final cat = await _profiles.create(
      CatProfileDraft(
        name: struggling ? 'Demo Rookie' : 'Demo Tiger',
        ageGroup: AgeGroup.adult,
        energyLevel: EnergyLevel.high,
        screenExperience: ScreenExperience.some,
        favouritePrey: FavouritePrey.mothBug,
      ),
    );

    for (var i = 0; i < sessionCount; i++) {
      await _seedSession(cat.id, rng.fork(), struggling: struggling);
    }
    await _profiles.setCalibrationState(cat.id, CalibrationState.completed);
    return cat.id;
  }

  Future<void> _seedSession(
    String catId,
    SeededRandom rng, {
    required bool struggling,
  }) async {
    final plan = SessionPlan(
      mode: SessionMode.freePlay,
      catId: catId,
      plannedDurationSeconds: 180,
      soundEnabled: true,
      seed: rng.nextInt64(),
      initialDifficulty: 2,
      rewardSchedule: RewardSchedule.none,
      maxRewardReminders: 3,
      isCalibration: false,
    );
    final (sessionId, startedAt) = await _sessions.createSession(
      plan: plan,
      screenWidthLogical: 1366,
      screenHeightLogical: 1024,
      appVersion: appVersion,
      platform: 'demo',
      algorithmVersion: algo.algorithmVersion,
    );

    final trials = <TrialRecord>[];
    final touches = <List<TouchRecord>>[];
    var timeMs = 3000;
    final trialCount = 14 + rng.nextInt(6);
    for (var index = 0; index < trialCount; index++) {
      final config = TrialConfiguration(
        preyType: rng.pick(PreyType.values),
        movementStyle: rng.pick(MovementStyle.values),
        speedLevel: rng.pick(const [SpeedLevel.slow, SpeedLevel.medium]),
        sizeLevel: rng.pick(const [SizeLevel.large, SizeLevel.medium]),
        soundMode: rng.nextBool() ? SoundMode.sound : SoundMode.silent,
        spawnZone: rng.pick(SpawnZone.values),
      );
      final loved =
          config.preyType == PreyType.moth &&
          config.movementStyle == MovementStyle.unpredictable;
      final catchProbability = struggling ? 0.08 : (loved ? 0.9 : 0.45);
      final caught = rng.nextDouble() < catchProbability;
      final reaction = caught ? (loved ? 800 : 2200) + rng.nextInt(900) : null;
      final spawnAt = timeMs;
      final endAt = caught ? spawnAt + 250 + reaction! : spawnAt + 12250;
      timeMs = endAt + 1100;

      final x = 0.2 + rng.nextDouble() * 0.6;
      final y = 0.2 + rng.nextDouble() * 0.6;
      trials.add(
        TrialRecord(
          trialIndex: index,
          configuration: config,
          spawnedAtMs: spawnAt,
          becameTouchableAtMs: spawnAt + 250,
          endedAtMs: endAt,
          spawnXNormalised: x,
          spawnYNormalised: y,
          pathSeed: rng.nextInt64(),
          success: caught,
          firstSuccessfulTouchAtMs: caught ? endAt : null,
          reactionTimeMs: reaction,
          missCount: caught ? 0 : rng.nextInt(3),
          timedOut: !caught,
          cueType: null,
          praiseCueType: null,
          rewardReminderShown: false,
          frustrationSeverity: struggling && rng.nextDouble() < 0.3 ? 1 : 0,
          frustrationFlags: const {},
          difficultyAtTrial: struggling ? 1 : 2 + (index ~/ 6),
        ),
      );
      touches.add([
        TouchRecord(
          trialIndex: index,
          pointerId: index,
          logicalInteractionId: index,
          occurredAtMs: endAt,
          xNormalised: x,
          yNormalised: y,
          classification: caught
              ? TouchClassification.hit
              : TouchClassification.miss,
          deduplicated: false,
          distanceFromTarget: caught ? 0.01 : 0.2,
        ),
      ]);
    }

    for (var i = 0; i < trials.length; i++) {
      await _sessions.insertTrialWithTouches(
        sessionId: sessionId,
        sessionStartUtc: startedAt,
        trial: trials[i],
        touches: touches[i],
        algorithmVersion: algo.algorithmVersion,
      );
    }

    final valid = trials.where((t) => t.isValidForLearning).toList();
    final reactions =
        valid
            .where((t) => t.success && t.reactionTimeMs != null)
            .map((t) => t.reactionTimeMs!)
            .toList()
          ..sort();
    await _sessions.finaliseSession(
      sessionId: sessionId,
      summary: SessionSummary(
        status: SessionStatus.completed,
        actualDurationMs: timeMs,
        catches: trials.where((t) => t.success).length,
        misses: trials.fold(0, (sum, t) => sum + t.missCount),
        timeouts: trials.where((t) => t.timedOut).length,
        medianReactionMs: reactions.isEmpty
            ? null
            : reactions[reactions.length ~/ 2],
        frustrationCount: valid.where((t) => t.frustrationSeverity >= 1).length,
        endDifficulty: struggling ? 1 : 4,
      ),
      trials: trials,
    );
  }
}
