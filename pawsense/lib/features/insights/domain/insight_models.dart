import '../../../shared/models/enums.dart';

/// Pure inputs for insight computation, mapped from database rows by the
/// insights repository. Only learning-relevant fields cross this boundary.
class TrialFact {
  const TrialFact({
    required this.preyType,
    required this.movementStyle,
    required this.speedLevel,
    required this.sizeLevel,
    required this.soundMode,
    required this.success,
    required this.timedOut,
    required this.reactionTimeMs,
    required this.missCount,
    required this.frustrationSeverity,
    required this.cueType,
    required this.difficultyAtTrial,
    required this.endedAtUtc,
  });

  final PreyType preyType;
  final MovementStyle movementStyle;
  final SpeedLevel speedLevel;
  final SizeLevel sizeLevel;
  final SoundMode soundMode;
  final bool success;
  final bool timedOut;
  final int? reactionTimeMs;
  final int missCount;
  final int frustrationSeverity;
  final CueType? cueType;
  final int difficultyAtTrial;
  final DateTime? endedAtUtc;

  /// Concluded trials only (catch or full timeout) count as evidence.
  bool get isComparable => success || timedOut;

  String factorValue(FactorType factor) => switch (factor) {
    FactorType.targetType => preyType.name,
    FactorType.movementStyle => movementStyle.name,
    FactorType.speedLevel => speedLevel.name,
    FactorType.sizeLevel => sizeLevel.name,
    FactorType.soundMode => soundMode.name,
    FactorType.spawnZone => '',
  };
}

class SessionFact {
  const SessionFact({
    required this.id,
    required this.mode,
    required this.status,
    required this.startedAtUtc,
    required this.actualDurationMs,
    required this.catches,
    required this.misses,
    required this.timeouts,
    required this.medianReactionMs,
    required this.frustrationCount,
    required this.isCalibration,
  });

  final String id;
  final SessionMode mode;
  final SessionStatus status;
  final DateTime startedAtUtc;
  final int? actualDurationMs;
  final int catches;
  final int misses;
  final int timeouts;
  final int? medianReactionMs;
  final int frustrationCount;
  final bool isCalibration;

  int get comparableTrials => catches + timeouts;
  double? get catchRate =>
      comparableTrials == 0 ? null : catches / comparableTrials;
}

class TouchFact {
  const TouchFact({
    required this.xNormalised,
    required this.yNormalised,
    required this.classification,
  });

  final double xNormalised;
  final double yNormalised;
  final TouchClassification classification;
}

/// A gated behavioural claim about one factor dimension.
class FavouriteInsight {
  const FavouriteInsight({
    required this.factorType,
    required this.topValue,
    required this.topSuccesses,
    required this.topComparable,
    required this.tier,
    required this.utilityGap,
  });

  final FactorType factorType;

  /// Enum name of the leading value.
  final String topValue;

  /// Raw catches on the leading value (honest counts, not decayed).
  final int topSuccesses;

  /// Raw comparable impressions of the leading value.
  final int topComparable;
  final ConfidenceTier tier;

  /// Utility lead over the runner-up (raw-stats utilities).
  final double utilityGap;

  /// Only insights that clear both gates may render a "favourite" claim.
  bool get showable =>
      tier != ConfidenceTier.insufficient && utilityGap >= 0.08;
}

/// One point of a per-session trend line, oldest first.
class TrendPoint {
  const TrendPoint({required this.sessionIndex, required this.value});

  final int sessionIndex;
  final double value;
}

/// Heatmap of paw touches on a fixed normalised grid.
class TouchHeatmap {
  const TouchHeatmap({
    required this.columns,
    required this.rows,
    required this.hitCounts,
    required this.otherCounts,
    required this.totalTouches,
  });

  final int columns;
  final int rows;

  /// Row-major [rows][columns] counts of catching touches.
  final List<List<int>> hitCounts;

  /// Row-major counts of misses + edge touches (post-capture excluded).
  final List<List<int>> otherCounts;
  final int totalTouches;

  int maxCellCount() {
    var max = 0;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        final total = hitCounts[r][c] + otherCounts[r][c];
        if (total > max) max = total;
      }
    }
    return max;
  }
}

/// Cue training summary for one cue type.
class CueInsight {
  const CueInsight({
    required this.cueType,
    required this.exposures,
    required this.successfulResponses,
    required this.reactionTimeEwmaMs,
  });

  final CueType cueType;
  final int exposures;
  final int successfulResponses;
  final double? reactionTimeEwmaMs;

  double? get responseRate =>
      exposures == 0 ? null : successfulResponses / exposures;
}

/// Time-of-day buckets in the device's local time.
enum DayPart { morning, afternoon, evening, night }

class DayPartPattern {
  const DayPartPattern({
    required this.best,
    required this.sessionsInBest,
    required this.catchRateInBest,
    required this.totalSessions,
  });

  final DayPart best;
  final int sessionsInBest;
  final double catchRateInBest;
  final int totalSessions;
}

/// Everything the insights screen renders.
class CatInsights {
  const CatInsights({
    required this.lifetimeSessions,
    required this.sessionsLast7Days,
    required this.lifetimeCatches,
    required this.lifetimeComparableTrials,
    required this.medianReactionMs,
    required this.totalPlayMs,
    required this.favourites,
    required this.catchRateTrend,
    required this.reactionTrend,
    required this.difficultyTrend,
    required this.heatmap,
    required this.cues,
    required this.completionReasons,
    required this.dayPartPattern,
    required this.frustrationTrials,
    required this.personalityTitleKey,
  });

  final int lifetimeSessions;
  final int sessionsLast7Days;
  final int lifetimeCatches;
  final int lifetimeComparableTrials;
  final int? medianReactionMs;
  final int totalPlayMs;
  final List<FavouriteInsight> favourites;
  final List<TrendPoint> catchRateTrend;
  final List<TrendPoint> reactionTrend;
  final List<TrendPoint> difficultyTrend;
  final TouchHeatmap heatmap;
  final List<CueInsight> cues;
  final Map<SessionStatus, int> completionReasons;

  /// Null until enough sessions exist (>= 10).
  final DayPartPattern? dayPartPattern;
  final int frustrationTrials;

  /// Stable key of the playful personality title (l10n resolves it), null
  /// until prey + movement favourites are both showable.
  final String? personalityTitleKey;

  double? get lifetimeCatchRate => lifetimeComparableTrials == 0
      ? null
      : lifetimeCatches / lifetimeComparableTrials;
}
