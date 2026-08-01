import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';

/// Everything needed to run one session, resolved before play starts.
class SessionPlan {
  const SessionPlan({
    required this.mode,
    required this.catId,
    required this.plannedDurationSeconds,
    required this.soundEnabled,
    required this.seed,
    required this.initialDifficulty,
    required this.rewardSchedule,
    required this.maxRewardReminders,
    required this.isCalibration,
  });

  final SessionMode mode;

  /// Null for mixed sessions.
  final String? catId;
  final int plannedDurationSeconds;

  /// Session-level owner choice; per-trial sound additionally requires the
  /// cat's safety constraints and the trial configuration to allow it.
  final bool soundEnabled;
  final int seed;
  final int initialDifficulty;
  final RewardSchedule rewardSchedule;
  final int maxRewardReminders;
  final bool isCalibration;
}

/// A finished trial, ready for persistence.
class TrialRecord {
  TrialRecord({
    required this.trialIndex,
    required this.configuration,
    required this.spawnedAtMs,
    required this.becameTouchableAtMs,
    required this.endedAtMs,
    required this.spawnXNormalised,
    required this.spawnYNormalised,
    required this.pathSeed,
    required this.success,
    required this.firstSuccessfulTouchAtMs,
    required this.reactionTimeMs,
    required this.missCount,
    required this.timedOut,
    required this.cueType,
    required this.praiseCueType,
    required this.rewardReminderShown,
    required this.frustrationSeverity,
    required this.frustrationFlags,
    required this.difficultyAtTrial,
  });

  final int trialIndex;
  final TrialConfiguration configuration;

  /// Session-relative monotonic milliseconds.
  final int spawnedAtMs;
  final int becameTouchableAtMs;
  final int endedAtMs;
  final double spawnXNormalised;
  final double spawnYNormalised;
  final int pathSeed;
  final bool success;
  final int? firstSuccessfulTouchAtMs;
  final int? reactionTimeMs;
  final int missCount;
  final bool timedOut;
  final CueType? cueType;
  final CueType? praiseCueType;
  final bool rewardReminderShown;
  final int frustrationSeverity;
  final Set<FrustrationFlag> frustrationFlags;
  final int difficultyAtTrial;

  /// Only trials the cat actually experienced to a conclusion train the
  /// model: caught, or timed out after the full window. Trials cut short by
  /// session end remain raw history but do not update preferences.
  bool get isValidForLearning => success || timedOut;
}

/// A classified touch ready for persistence.
class TouchRecord {
  const TouchRecord({
    required this.trialIndex,
    required this.pointerId,
    required this.logicalInteractionId,
    required this.occurredAtMs,
    required this.xNormalised,
    required this.yNormalised,
    required this.classification,
    required this.deduplicated,
    required this.distanceFromTarget,
  });

  /// Null when no trial was active (e.g. between trials).
  final int? trialIndex;
  final int pointerId;
  final int logicalInteractionId;
  final int occurredAtMs;
  final double xNormalised;
  final double yNormalised;
  final TouchClassification classification;
  final bool deduplicated;
  final double? distanceFromTarget;
}

/// Why and how a session ended, with the summary the results screen needs.
class SessionSummary {
  const SessionSummary({
    required this.status,
    required this.actualDurationMs,
    required this.catches,
    required this.misses,
    required this.timeouts,
    required this.medianReactionMs,
    required this.frustrationCount,
    required this.endDifficulty,
  });

  final SessionStatus status;
  final int actualDurationMs;
  final int catches;
  final int misses;
  final int timeouts;
  final int? medianReactionMs;

  /// Number of learning-valid trials with severity >= 1.
  final int frustrationCount;
  final int endDifficulty;
}
