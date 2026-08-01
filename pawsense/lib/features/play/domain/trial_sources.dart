import '../../../core/random/seeded_random.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../../calibration/domain/calibration_scheduler.dart';
import '../../personalisation/domain/configuration_selector.dart';
import '../../personalisation/domain/difficulty_controller.dart';
import '../../personalisation/domain/preference_scoring.dart';
import '../../personalisation/domain/safety_constraints.dart';
import '../domain/session_models.dart';
import '../game/game_session_controller.dart';

/// Shared "easy relief" configuration: the largest/slowest safe prey the
/// snapshot currently favours, centre-spawned and silent.
TrialConfiguration _easyConfiguration({
  required SafetyConstraints constraints,
  required PreferenceSnapshot snapshot,
  required PreferenceScorer scorer,
}) {
  var bestPrey = PreyType.mouse;
  var bestUtility = double.negativeInfinity;
  for (final prey in PreyType.values) {
    final utility = scorer.utility(
      snapshot.statsFor(FactorType.targetType, prey.name),
    );
    if (utility > bestUtility) {
      bestUtility = utility;
      bestPrey = prey;
    }
  }
  return TrialConfiguration(
    preyType: bestPrey,
    movementStyle: MovementStyle.smooth,
    speedLevel: SpeedLevel.slow,
    sizeLevel: SizeLevel.large,
    soundMode: SoundMode.silent,
    spawnZone: SpawnZone.centre,
  );
}

/// Fixed balanced schedule for the first session.
class CalibrationTrialSource implements TrialSource {
  CalibrationTrialSource({
    required this.schedule,
    required this.constraints,
    this.startIndex = 0,
  }) : _cursor = startIndex;

  final CalibrationSchedule schedule;
  final SafetyConstraints constraints;
  final int startIndex;
  int _cursor;

  int get nextIndex => _cursor;

  @override
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  }) {
    final config = schedule.trials[_cursor % schedule.trials.length];
    _cursor++;
    return config;
  }

  @override
  TrialConfiguration easier({required List<TrialConfiguration> history}) =>
      _easyConfiguration(
        constraints: constraints,
        snapshot: PreferenceSnapshot.empty,
        scorer: const PreferenceScorer(),
      );

  @override
  void onTrialOutcome(covariant Object outcome) {}

  @override
  int? get remainingTrials => schedule.trials.length - _cursor;

  @override
  int? get difficultyOverride => null;
}

/// Adaptive free play: selector + difficulty controller + live in-memory
/// preference updates within the session (the database is updated once, at
/// finalisation).
class AdaptiveTrialSource implements TrialSource {
  AdaptiveTrialSource({
    required PreferenceSnapshot snapshot,
    required this.constraints,
    required this.rng,
    required this.soundEnabled,
    required DifficultyController difficultyController,
    this.selector = const ConfigurationSelector(),
    this.scorer = const PreferenceScorer(),
  }) : _difficulty = difficultyController,
       _working = _WorkingSnapshot(snapshot);

  final SafetyConstraints constraints;
  final SeededRandom rng;
  final bool soundEnabled;
  final ConfigurationSelector selector;
  final PreferenceScorer scorer;
  final DifficultyController _difficulty;
  final _WorkingSnapshot _working;

  @override
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  }) {
    return selector.select(
      snapshot: _working.snapshot,
      constraints: constraints,
      difficulty: _difficulty.difficulty,
      rng: rng,
      history: history,
      soundEnabledThisSession: soundEnabled,
    );
  }

  @override
  TrialConfiguration easier({required List<TrialConfiguration> history}) =>
      _easyConfiguration(
        constraints: constraints,
        snapshot: _working.snapshot,
        scorer: scorer,
      );

  @override
  void onTrialOutcome(covariant TrialRecord outcome) {
    _difficulty.onTrialCompleted(
      TrialOutcome(
        caught: outcome.success,
        reactionTimeMs: outcome.reactionTimeMs,
        timedOut: outcome.timedOut,
        frustrationSeverity: outcome.frustrationSeverity,
      ),
    );
    _working.apply(outcome);
  }

  @override
  int? get remainingTrials => null;

  @override
  int? get difficultyOverride => _difficulty.difficulty;
}

/// Mixed sessions: varied, mid-difficulty, learning nothing about anyone.
class MixedTrialSource implements TrialSource {
  MixedTrialSource({
    required this.rng,
    required this.soundEnabled,
    this.selector = const ConfigurationSelector(),
  });

  static const int fixedDifficulty = 4;

  final SeededRandom rng;
  final bool soundEnabled;
  final ConfigurationSelector selector;

  @override
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  }) {
    return selector.select(
      snapshot: PreferenceSnapshot.empty,
      constraints: const SafetyConstraints(),
      difficulty: fixedDifficulty,
      rng: rng,
      history: history,
      soundEnabledThisSession: soundEnabled,
    );
  }

  @override
  TrialConfiguration easier({required List<TrialConfiguration> history}) =>
      _easyConfiguration(
        constraints: const SafetyConstraints(),
        snapshot: PreferenceSnapshot.empty,
        scorer: const PreferenceScorer(),
      );

  @override
  void onTrialOutcome(covariant Object outcome) {}

  @override
  int? get remainingTrials => null;

  @override
  int? get difficultyOverride => null;
}

/// Owner-chosen fixed factors; zones rotate for variety.
class ManualTrialSource implements TrialSource {
  ManualTrialSource({
    required this.preyType,
    required this.movementStyle,
    required this.speedLevel,
    required this.sizeLevel,
    required this.soundMode,
    required this.constraints,
    required this.rng,
  });

  final PreyType preyType;
  final MovementStyle movementStyle;
  final SpeedLevel speedLevel;
  final SizeLevel sizeLevel;
  final SoundMode soundMode;
  final SafetyConstraints constraints;
  final SeededRandom rng;

  @override
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  }) {
    final zones = constraints.centreZoneOnly
        ? const [SpawnZone.centre]
        : SpawnZone.values;
    return TrialConfiguration(
      preyType: preyType,
      movementStyle: movementStyle,
      speedLevel: constraints.allowsSpeed(speedLevel)
          ? speedLevel
          : constraints.maxSpeedLevel,
      sizeLevel: constraints.allowsSize(sizeLevel)
          ? sizeLevel
          : constraints.minSizeLevel,
      soundMode: constraints.allowsSound(soundMode)
          ? soundMode
          : SoundMode.silent,
      spawnZone: zones[rng.nextInt(zones.length)],
    );
  }

  @override
  TrialConfiguration easier({required List<TrialConfiguration> history}) =>
      _easyConfiguration(
        constraints: constraints,
        snapshot: PreferenceSnapshot.empty,
        scorer: const PreferenceScorer(),
      );

  @override
  void onTrialOutcome(covariant Object outcome) {}

  @override
  int? get remainingTrials => null;

  @override
  int? get difficultyOverride => null;
}

/// Developer tools: replays one exact configuration.
class ReplayTrialSource implements TrialSource {
  ReplayTrialSource(this.configuration);

  final TrialConfiguration configuration;

  @override
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  }) => configuration;

  @override
  TrialConfiguration easier({required List<TrialConfiguration> history}) =>
      configuration;

  @override
  void onTrialOutcome(covariant Object outcome) {}

  @override
  int? get remainingTrials => null;

  @override
  int? get difficultyOverride => null;
}

/// In-session working copy of the snapshot so selection reacts within the
/// session while the database stays untouched until finalisation.
class _WorkingSnapshot {
  _WorkingSnapshot(PreferenceSnapshot initial)
    : _stats = {
        for (final entry in initial.stats.entries)
          entry.key: Map.of(entry.value),
      },
      _totalTrials = initial.totalTrials;

  final Map<FactorType, Map<String, FactorStats>> _stats;
  double _totalTrials;

  PreferenceSnapshot get snapshot =>
      PreferenceSnapshot(stats: _stats, totalTrials: _totalTrials);

  void apply(TrialRecord trial) {
    if (!trial.isValidForLearning) return;
    _totalTrials += 1;
    for (final factor in FactorType.values) {
      final value = trial.configuration.factorValue(factor);
      final current = (_stats[factor] ??= {})[value] ?? FactorStats.empty;
      // Simplified in-session update (full decayed update happens at
      // finalisation in the repository): bump the counters that drive
      // selection.
      (_stats[factor] ??= {})[value] = FactorStats(
        impressions: current.impressions + 1,
        successes: current.successes + (trial.success ? 1 : 0),
        timeouts: current.timeouts + (trial.timedOut ? 1 : 0),
        totalMisses: current.totalMisses + trial.missCount,
        frustrationCount:
            current.frustrationCount + (trial.frustrationSeverity > 0 ? 1 : 0),
        reactionTimeEwmaMs: trial.success && trial.reactionTimeMs != null
            ? (current.reactionTimeEwmaMs == null
                  ? trial.reactionTimeMs!.toDouble()
                  : 0.3 * trial.reactionTimeMs! +
                        0.7 * current.reactionTimeEwmaMs!)
            : current.reactionTimeEwmaMs,
        cumulativeReward: current.cumulativeReward,
      );
    }
  }
}
