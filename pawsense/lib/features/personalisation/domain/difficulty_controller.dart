import '../../../shared/models/enums.dart';

/// Outcome summary of one finished trial, as the controller consumes it.
class TrialOutcome {
  const TrialOutcome({
    required this.caught,
    required this.reactionTimeMs,
    required this.timedOut,
    required this.frustrationSeverity,
  });

  final bool caught;
  final int? reactionTimeMs;
  final bool timedOut;
  final int frustrationSeverity;
}

class DifficultyConfig {
  const DifficultyConfig({
    this.windowSize = 5,
    this.minCatchesToIncrease = 4,
    this.maxMedianReactionMsToIncrease = 2000,
    this.maxSeveritySumToIncrease = 1,
    this.minTrialsBetweenChanges = 3,
    this.maxCatchesToDecrease = 2,
    this.minTimeoutsToDecrease = 2,
    this.minSeveritySumToDecrease = 3,
  });

  final int windowSize;
  final int minCatchesToIncrease;
  final int maxMedianReactionMsToIncrease;
  final int maxSeveritySumToIncrease;

  /// Cooldown: no change within this many trials of the last change,
  /// except immediate safety reductions. Senior cats use 4 (gentler
  /// progression), everyone else 3.
  final int minTrialsBetweenChanges;

  final int maxCatchesToDecrease;
  final int minTimeoutsToDecrease;
  final int minSeveritySumToDecrease;
}

/// What each difficulty band allows (product spec section 11.F). Safety
/// constraints intersect these afterwards and always win.
class DifficultyBands {
  static List<SizeLevel> sizes(int difficulty) => switch (difficulty) {
    <= 2 => const [SizeLevel.large],
    <= 4 => const [SizeLevel.large, SizeLevel.medium],
    <= 6 => const [SizeLevel.medium, SizeLevel.large],
    <= 8 => const [SizeLevel.medium, SizeLevel.small],
    _ => const [SizeLevel.small, SizeLevel.medium],
  };

  static List<SpeedLevel> speeds(int difficulty) => switch (difficulty) {
    <= 2 => const [SpeedLevel.slow],
    <= 4 => const [SpeedLevel.slow, SpeedLevel.medium],
    <= 6 => const [SpeedLevel.medium, SpeedLevel.slow],
    <= 8 => const [SpeedLevel.medium, SpeedLevel.fast],
    _ => const [SpeedLevel.fast, SpeedLevel.medium],
  };

  static List<MovementStyle> movements(int difficulty) => switch (difficulty) {
    <= 2 => const [MovementStyle.smooth],
    <= 4 => const [MovementStyle.smooth, MovementStyle.stopAndGo],
    _ => MovementStyle.values,
  };
}

/// Evidence-gated 0-10 difficulty with cooldowns and immediate safety
/// reductions. Pure and deterministic; the session runner feeds it trial
/// outcomes and reads [difficulty].
class DifficultyController {
  DifficultyController({
    required int initialDifficulty,
    this.config = const DifficultyConfig(),
  }) : _difficulty = initialDifficulty.clamp(0, 10);

  final DifficultyConfig config;

  int _difficulty;
  int _trialsSinceChange = 999; // no cooldown at session start
  final List<TrialOutcome> _window = [];
  int _consecutiveHighFrustration = 0;

  int get difficulty => _difficulty;

  /// Records a finished trial and returns the difficulty change applied
  /// (-2, -1, 0, or +1).
  int onTrialCompleted(TrialOutcome outcome) {
    _window.add(outcome);
    if (_window.length > config.windowSize) _window.removeAt(0);
    _trialsSinceChange++;

    if (outcome.frustrationSeverity >= 2) {
      _consecutiveHighFrustration++;
    } else {
      _consecutiveHighFrustration = 0;
    }

    // Immediate safety reductions bypass the cooldown.
    if (outcome.frustrationSeverity >= 3) {
      final step = _consecutiveHighFrustration >= 2 ? -2 : -1;
      return _apply(step);
    }
    if (_consecutiveHighFrustration >= 2) {
      return _apply(-2);
    }

    if (_window.length < config.windowSize) return 0;
    if (_trialsSinceChange < config.minTrialsBetweenChanges) return 0;

    final catches = _window.where((t) => t.caught).length;
    final timeouts = _window.where((t) => t.timedOut).length;
    final severitySum = _window.fold(
      0,
      (sum, t) => sum + t.frustrationSeverity,
    );
    final anyHigh = _window.any((t) => t.frustrationSeverity >= 3);

    if (catches <= config.maxCatchesToDecrease ||
        timeouts >= config.minTimeoutsToDecrease ||
        severitySum >= config.minSeveritySumToDecrease) {
      return _apply(-1);
    }

    final median = _medianReactionMs();
    if (catches >= config.minCatchesToIncrease &&
        median != null &&
        median <= config.maxMedianReactionMsToIncrease &&
        !anyHigh &&
        severitySum <= config.maxSeveritySumToIncrease) {
      return _apply(1);
    }
    return 0;
  }

  int _apply(int step) {
    final before = _difficulty;
    _difficulty = (_difficulty + step).clamp(0, 10);
    final applied = _difficulty - before;
    if (applied != 0) {
      _trialsSinceChange = 0;
      _window.clear();
    }
    return applied;
  }

  int? _medianReactionMs() {
    final reactions =
        _window
            .where((t) => t.caught && t.reactionTimeMs != null)
            .map((t) => t.reactionTimeMs!)
            .toList()
          ..sort();
    if (reactions.isEmpty) return null;
    final mid = reactions.length ~/ 2;
    if (reactions.length.isOdd) return reactions[mid];
    return (reactions[mid - 1] + reactions[mid]) ~/ 2;
  }
}
