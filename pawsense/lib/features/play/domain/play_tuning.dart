import '../../../shared/models/enums.dart';

/// Every gameplay magic number in one place, expressed device-independently.
///
/// Length units: fractions of the *shortest* logical screen dimension.
/// Speed units: fractions of the shortest dimension per second.
/// Time units: milliseconds unless suffixed otherwise.
///
/// The defaults implement the V1 product specification. Tests and the
/// developer screen may construct modified copies; production code uses
/// [defaultPlayTuning].
class PlayTuning {
  const PlayTuning({
    this.safeMarginFraction = 0.08,
    this.sizeFractionLarge = 0.15,
    this.sizeFractionMedium = 0.11,
    this.sizeFractionSmall = 0.08,
    this.speedFractionSlow = 0.12,
    this.speedFractionMedium = 0.22,
    this.speedFractionFast = 0.35,
    this.hitboxInflationFactor = 1.25,
    this.minHitboxDiameterFraction = 0.10,
    this.clusterWindowMs = 180,
    this.clusterRadiusFraction = 0.04,
    this.longHoldMs = 2000,
    this.trialTimeoutMs = 12000,
    this.interTrialDelayMs = 1100,
    this.targetSpawnInMs = 250,
    this.attentionNudgeAfterMs = 12000,
    this.easierTargetAfterMs = 20000,
    this.endDisengagedAfterMs = 30000,
    this.cueDelayMinMs = 300,
    this.cueDelayMaxMs = 700,
    this.maxSessionSeconds = 300,
    this.defaultSessionSeconds = 180,
    this.sessionDurationOptionsSeconds = const [60, 120, 180, 300],
    this.ownerExitHoldMs = 2000,
    this.ownerExitCornerFraction = 0.18,
    this.countdownSeconds = 3,
    this.nearMissRadiusFraction = 0.06,
  });

  // --- Geometry -----------------------------------------------------------

  /// Targets never move closer to any screen edge than this fraction of that
  /// edge's dimension.
  final double safeMarginFraction;

  /// Visible target diameter as a fraction of the shortest screen dimension.
  final double sizeFractionLarge;
  final double sizeFractionMedium;
  final double sizeFractionSmall;

  /// Movement speed as a fraction of the shortest screen dimension per second.
  final double speedFractionSlow;
  final double speedFractionMedium;
  final double speedFractionFast;

  /// The touchable hitbox is the visible bounds scaled by this factor.
  final double hitboxInflationFactor;

  /// The hitbox never shrinks below this diameter, regardless of visual size.
  final double minHitboxDiameterFraction;

  // --- Touch processing ---------------------------------------------------

  /// Raw pointer-downs within this window and radius merge into one logical
  /// paw interaction.
  final int clusterWindowMs;

  /// Cluster radius as a fraction of the shortest screen dimension.
  final double clusterRadiusFraction;

  /// A pointer held down longer than this counts as a long-hold signal.
  final int longHoldMs;

  /// Misses closer than this to the hitbox edge count towards the
  /// repeated-impossible-reach frustration flag.
  final double nearMissRadiusFraction;

  // --- Trial lifecycle ----------------------------------------------------

  /// A trial with no catch ends as a timeout after this long.
  final int trialTimeoutMs;

  /// Pause between a trial ending and the next target spawning (capture
  /// celebration plays during this window).
  final int interTrialDelayMs;

  /// Spawn-in animation length; the target becomes touchable when it ends
  /// (reaction time anchors here).
  final int targetSpawnInMs;

  // --- Disengagement ------------------------------------------------------

  final int attentionNudgeAfterMs;
  final int easierTargetAfterMs;
  final int endDisengagedAfterMs;

  // --- Cue training -------------------------------------------------------

  /// Delay between the Touch cue finishing and the target spawning. Jittered
  /// uniformly within this range so the cat cannot key off exact timing.
  final int cueDelayMinMs;
  final int cueDelayMaxMs;

  // --- Session ------------------------------------------------------------

  final int maxSessionSeconds;
  final int defaultSessionSeconds;
  final List<int> sessionDurationOptionsSeconds;

  /// The owner exit gesture: both top corners held simultaneously this long.
  final int ownerExitHoldMs;

  /// Corner zone size for the exit gesture, as a fraction of each screen
  /// dimension.
  final double ownerExitCornerFraction;

  /// Calm start countdown before targets appear.
  final int countdownSeconds;

  // --- Lookups ------------------------------------------------------------

  double sizeFraction(SizeLevel level) => switch (level) {
    SizeLevel.large => sizeFractionLarge,
    SizeLevel.medium => sizeFractionMedium,
    SizeLevel.small => sizeFractionSmall,
  };

  double speedFraction(SpeedLevel level) => switch (level) {
    SpeedLevel.slow => speedFractionSlow,
    SpeedLevel.medium => speedFractionMedium,
    SpeedLevel.fast => speedFractionFast,
  };
}

const defaultPlayTuning = PlayTuning();
