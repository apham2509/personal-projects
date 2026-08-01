import 'dart:math' as math;

import '../../../shared/models/enums.dart';

/// Working statistics for one factor value (e.g. targetType=mouse).
/// Counts are real-valued because they decay gently (DECISIONS.md D-005);
/// raw per-trial history lives in the database untouched.
class FactorStats {
  const FactorStats({
    this.impressions = 0,
    this.successes = 0,
    this.timeouts = 0,
    this.totalMisses = 0,
    this.frustrationCount = 0,
    this.reactionTimeEwmaMs,
    this.cumulativeReward = 0,
  });

  final double impressions;
  final double successes;
  final double timeouts;
  final double totalMisses;
  final double frustrationCount;

  /// EWMA over *successful* reaction times; null until 3 successes.
  final double? reactionTimeEwmaMs;
  final double cumulativeReward;

  static const empty = FactorStats();
}

/// Immutable snapshot of every factor value's stats for one cat, plus the
/// total trial count, as the selector needs it.
class PreferenceSnapshot {
  const PreferenceSnapshot({required this.stats, required this.totalTrials});

  /// Keyed by factor type, then factor value name (enum `.name`).
  final Map<FactorType, Map<String, FactorStats>> stats;
  final double totalTrials;

  FactorStats statsFor(FactorType type, String value) =>
      stats[type]?[value] ?? FactorStats.empty;

  /// Total impressions recorded across all values of one factor dimension
  /// (the `totalFactorTrials` term of the exploration bonus).
  double totalForFactor(FactorType type) => (stats[type] ?? const {}).values
      .fold(0.0, (sum, s) => sum + s.impressions);

  static const empty = PreferenceSnapshot(stats: {}, totalTrials: 0);
}

/// Scoring formulas exactly as documented in docs/PERSONALISATION.md.
/// Pure functions of [FactorStats]; every constant is visible here.
class PreferenceScorer {
  const PreferenceScorer({
    this.reactionFloorMs = 500,
    this.reactionCeilingMs = 8000,
    this.minReactionSamples = 3,
    this.confidenceFullSampleSize = 20,
  });

  /// Reactions at or below the floor score 1.0; at or above the ceiling 0.0.
  final double reactionFloorMs;
  final double reactionCeilingMs;

  /// Below this many successes the reaction score is a neutral 0.5.
  final int minReactionSamples;

  /// Impressions needed for full confidence (1.0).
  final double confidenceFullSampleSize;

  /// Beta(2,2)-smoothed catch rate; prior mean 0.5.
  double smoothedCatchRate(FactorStats s) =>
      (s.successes + 2) / (s.impressions + 4);

  /// Faster successful reactions score higher; neutral until enough data.
  double reactionScore(FactorStats s) {
    final ewma = s.reactionTimeEwmaMs;
    if (ewma == null || s.successes < minReactionSamples) return 0.5;
    final normalised =
        (ewma - reactionFloorMs) / (reactionCeilingMs - reactionFloorMs);
    return (1 - normalised).clamp(0.0, 1.0);
  }

  double calmInteractionScore(FactorStats s) =>
      (1 - (s.frustrationCount + 1) / (s.impressions + 4)).clamp(0.0, 1.0);

  double timeoutScore(FactorStats s) =>
      (1 - (s.timeouts + 1) / (s.impressions + 4)).clamp(0.0, 1.0);

  /// The headline factor utility.
  double utility(FactorStats s) =>
      0.50 * smoothedCatchRate(s) +
      0.25 * reactionScore(s) +
      0.15 * calmInteractionScore(s) +
      0.10 * timeoutScore(s);

  double confidence(FactorStats s) =>
      math.min(s.impressions / confidenceFullSampleSize, 1.0);
}

/// Transparent per-trial reward (docs/PERSONALISATION.md section "Trial
/// reward"). Clamped to [-1.0, 1.25].
class TrialRewardCalculator {
  const TrialRewardCalculator({
    this.reactionFloorMs = 500,
    this.reactionCeilingMs = 8000,
  });

  final double reactionFloorMs;
  final double reactionCeilingMs;

  double calculate({
    required bool caught,
    required int? reactionTimeMs,
    required int missCount,
    required int frustrationSeverity,
    required bool timedOut,
  }) {
    final catchComponent = caught ? 1.0 : 0.0;

    var reactionBonus = 0.0;
    if (caught && reactionTimeMs != null) {
      final normalised =
          ((reactionTimeMs - reactionFloorMs) /
                  (reactionCeilingMs - reactionFloorMs))
              .clamp(0.0, 1.0);
      reactionBonus = 0.25 * (1 - normalised);
    }

    final missPenalty = -0.12 * math.min(missCount, 3);
    final frustrationPenalty = -0.20 * frustrationSeverity;
    final timeoutPenalty = timedOut ? -0.25 : 0.0;

    final reward =
        catchComponent +
        reactionBonus +
        missPenalty +
        frustrationPenalty +
        timeoutPenalty;
    return reward.clamp(-1.0, 1.25);
  }
}

/// Confidence tiers for owner-facing insights. Sample sizes are honest raw
/// counts (from trials), not decayed working counters.
ConfidenceTier confidenceTierFor(int comparableImpressions) {
  if (comparableImpressions < 8) return ConfidenceTier.insufficient;
  if (comparableImpressions < 20) return ConfidenceTier.earlyObservation;
  if (comparableImpressions < 50) return ConfidenceTier.developingPattern;
  return ConfidenceTier.strongPattern;
}

/// Minimum utility gap between first and second place before a "favourite"
/// claim may be shown.
const double favouriteUtilityGap = 0.08;
