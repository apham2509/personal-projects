import '../../l10n/generated/app_localizations.dart';
import '../../shared/models/enums.dart';

/// Central mapping from persisted enums to user-visible strings. Keeps
/// display text in ARB files while enums stay pure storage identifiers.
extension AgeGroupLabel on AgeGroup {
  String label(AppLocalizations l10n) => switch (this) {
    AgeGroup.kitten => l10n.ageKitten,
    AgeGroup.youngAdult => l10n.ageYoungAdult,
    AgeGroup.adult => l10n.ageAdult,
    AgeGroup.senior => l10n.ageSenior,
    AgeGroup.unknown => l10n.ageUnknown,
  };
}

extension BodySizeLabel on BodySize {
  String label(AppLocalizations l10n) => switch (this) {
    BodySize.small => l10n.bodySmall,
    BodySize.medium => l10n.bodyMedium,
    BodySize.large => l10n.bodyLarge,
  };
}

extension EnergyLevelLabel on EnergyLevel {
  String label(AppLocalizations l10n) => switch (this) {
    EnergyLevel.low => l10n.energyLow,
    EnergyLevel.medium => l10n.energyMedium,
    EnergyLevel.high => l10n.energyHigh,
  };
}

extension ScreenExperienceLabel on ScreenExperience {
  String label(AppLocalizations l10n) => switch (this) {
    ScreenExperience.none => l10n.experienceNone,
    ScreenExperience.some => l10n.experienceSome,
    ScreenExperience.frequent => l10n.experienceFrequent,
  };
}

extension FavouritePreyLabel on FavouritePrey {
  String label(AppLocalizations l10n) => switch (this) {
    FavouritePrey.mouse => l10n.preyMouse,
    FavouritePrey.mothBug => l10n.preyMothBug,
    FavouritePrey.fish => l10n.preyFish,
    FavouritePrey.feather => l10n.preyFeather,
    FavouritePrey.ball => l10n.preyBall,
    FavouritePrey.other => l10n.preyOther,
    FavouritePrey.unknown => l10n.preyUnknown,
  };
}

extension SoundSensitivityLabel on SoundSensitivity {
  String label(AppLocalizations l10n) => switch (this) {
    SoundSensitivity.enjoysSound => l10n.soundEnjoys,
    SoundSensitivity.neutral => l10n.soundNeutral,
    SoundSensitivity.easilyStartled => l10n.soundStartled,
    SoundSensitivity.unknown => l10n.soundUnknown,
  };
}

extension TreatMotivationLabel on TreatMotivation {
  String label(AppLocalizations l10n) => switch (this) {
    TreatMotivation.low => l10n.treatLow,
    TreatMotivation.medium => l10n.treatMedium,
    TreatMotivation.high => l10n.treatHigh,
    TreatMotivation.unknown => l10n.treatUnknown,
  };
}

extension MobilityConsiderationLabel on MobilityConsideration {
  String label(AppLocalizations l10n) => switch (this) {
    MobilityConsideration.none => l10n.mobilityNone,
    MobilityConsideration.limitedMovement => l10n.mobilityLimited,
    MobilityConsideration.seniorFriendly => l10n.mobilitySenior,
  };
}

extension VisionConsiderationLabel on VisionConsideration {
  String label(AppLocalizations l10n) => switch (this) {
    VisionConsideration.noneKnown => l10n.visionNone,
    VisionConsideration.reducedVision => l10n.visionReduced,
    VisionConsideration.unknown => l10n.visionUnknown,
  };
}

extension HearingConsiderationLabel on HearingConsideration {
  String label(AppLocalizations l10n) => switch (this) {
    HearingConsideration.noneKnown => l10n.hearingNone,
    HearingConsideration.reducedHearing => l10n.hearingReduced,
    HearingConsideration.unknown => l10n.hearingUnknown,
  };
}

extension PrimaryGoalLabel on PrimaryGoal {
  String label(AppLocalizations l10n) => switch (this) {
    PrimaryGoal.play => l10n.goalPlay,
    PrimaryGoal.mentalEnrichment => l10n.goalEnrichment,
    PrimaryGoal.verbalCueTraining => l10n.goalCueTraining,
    PrimaryGoal.gentleActivity => l10n.goalGentleActivity,
  };
}

extension CalibrationStateLabel on CalibrationState {
  String label(AppLocalizations l10n) => switch (this) {
    CalibrationState.notStarted => l10n.homeCalibrationNotStarted,
    CalibrationState.inProgress => l10n.homeCalibrationInProgress,
    CalibrationState.completed => l10n.homeCalibrationCompleted,
    CalibrationState.skipped => l10n.homeCalibrationSkipped,
  };
}

extension RewardScheduleLabel on RewardSchedule {
  String label(AppLocalizations l10n) => switch (this) {
    RewardSchedule.none => l10n.rewardNone,
    RewardSchedule.manualOnly => l10n.rewardManual,
    RewardSchedule.everyThreeCatches => l10n.rewardEveryThree,
    RewardSchedule.variableTwoToFive => l10n.rewardVariable,
  };
}
