import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';

/// Hard limits derived from the owner questionnaire. The selector, the
/// calibration scheduler, and the difficulty controller may never emit a
/// configuration violating these — they are constraints, not preferences.
class SafetyConstraints {
  const SafetyConstraints({
    this.soundAllowed = true,
    this.minSizeLevel = SizeLevel.small,
    this.maxSpeedLevel = SpeedLevel.fast,
    this.centreZoneOnly = false,
    this.highContrast = false,
  });

  factory SafetyConstraints.fromAnswers({
    required SoundSensitivity soundSensitivity,
    required VisionConsideration visionConsideration,
    required MobilityConsideration mobilityConsideration,
  }) {
    final reducedVision =
        visionConsideration == VisionConsideration.reducedVision;
    return SafetyConstraints(
      soundAllowed: soundSensitivity != SoundSensitivity.easilyStartled,
      minSizeLevel: reducedVision ? SizeLevel.large : SizeLevel.small,
      maxSpeedLevel: switch (mobilityConsideration) {
        MobilityConsideration.limitedMovement => SpeedLevel.slow,
        MobilityConsideration.seniorFriendly => SpeedLevel.medium,
        MobilityConsideration.none => SpeedLevel.fast,
      },
      centreZoneOnly:
          mobilityConsideration == MobilityConsideration.limitedMovement,
      highContrast: reducedVision,
    );
  }

  /// Sound may only ever be enabled when true. Owners can still play sound
  /// for a startle-sensitive cat by editing the profile — never by default.
  final bool soundAllowed;

  /// Targets never render smaller than this.
  final SizeLevel minSizeLevel;

  /// Targets never move faster than this.
  final SpeedLevel maxSpeedLevel;

  /// Restricts spawn zones to the centre (mobility-limited cats should not
  /// be lured across the whole screen).
  final bool centreZoneOnly;

  /// Prey renders in its maximum-contrast palette.
  final bool highContrast;

  bool allowsSize(SizeLevel size) => size.index >= minSizeLevel.index;

  bool allowsSpeed(SpeedLevel speed) => speed.index <= maxSpeedLevel.index;

  bool allowsSound(SoundMode mode) => mode == SoundMode.silent || soundAllowed;

  bool allowsZone(SpawnZone zone) =>
      !centreZoneOnly || zone == SpawnZone.centre;

  bool allows(TrialConfiguration config) =>
      allowsSize(config.sizeLevel) &&
      allowsSpeed(config.speedLevel) &&
      allowsSound(config.soundMode) &&
      allowsZone(config.spawnZone);
}
