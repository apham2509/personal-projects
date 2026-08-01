import '../../../shared/models/enums.dart';

/// Version of the questionnaire that produced a profile; bump when questions
/// are added/removed so old answers can be interpreted correctly.
const int onboardingVersion = 1;

/// Mutable-by-copy questionnaire state used by the onboarding wizard and the
/// profile editor. Only [name] is required; everything else defaults to a
/// neutral/unknown answer.
class CatProfileDraft {
  const CatProfileDraft({
    this.name = '',
    this.photoPath,
    this.ageGroup = AgeGroup.unknown,
    this.bodySize = BodySize.medium,
    this.energyLevel = EnergyLevel.medium,
    this.screenExperience = ScreenExperience.none,
    this.favouritePrey = FavouritePrey.unknown,
    this.soundSensitivity = SoundSensitivity.unknown,
    this.treatMotivation = TreatMotivation.unknown,
    this.mobilityConsideration = MobilityConsideration.none,
    this.visionConsideration = VisionConsideration.noneKnown,
    this.hearingConsideration = HearingConsideration.noneKnown,
    this.primaryGoal = PrimaryGoal.play,
    this.notes = '',
  });

  final String name;
  final String? photoPath;
  final AgeGroup ageGroup;
  final BodySize bodySize;
  final EnergyLevel energyLevel;
  final ScreenExperience screenExperience;
  final FavouritePrey favouritePrey;
  final SoundSensitivity soundSensitivity;
  final TreatMotivation treatMotivation;
  final MobilityConsideration mobilityConsideration;
  final VisionConsideration visionConsideration;
  final HearingConsideration hearingConsideration;
  final PrimaryGoal primaryGoal;
  final String notes;

  bool get isValid => name.trim().isNotEmpty;

  CatProfileDraft copyWith({
    String? name,
    String? Function()? photoPath,
    AgeGroup? ageGroup,
    BodySize? bodySize,
    EnergyLevel? energyLevel,
    ScreenExperience? screenExperience,
    FavouritePrey? favouritePrey,
    SoundSensitivity? soundSensitivity,
    TreatMotivation? treatMotivation,
    MobilityConsideration? mobilityConsideration,
    VisionConsideration? visionConsideration,
    HearingConsideration? hearingConsideration,
    PrimaryGoal? primaryGoal,
    String? notes,
  }) {
    return CatProfileDraft(
      name: name ?? this.name,
      photoPath: photoPath != null ? photoPath() : this.photoPath,
      ageGroup: ageGroup ?? this.ageGroup,
      bodySize: bodySize ?? this.bodySize,
      energyLevel: energyLevel ?? this.energyLevel,
      screenExperience: screenExperience ?? this.screenExperience,
      favouritePrey: favouritePrey ?? this.favouritePrey,
      soundSensitivity: soundSensitivity ?? this.soundSensitivity,
      treatMotivation: treatMotivation ?? this.treatMotivation,
      mobilityConsideration:
          mobilityConsideration ?? this.mobilityConsideration,
      visionConsideration: visionConsideration ?? this.visionConsideration,
      hearingConsideration: hearingConsideration ?? this.hearingConsideration,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      notes: notes ?? this.notes,
    );
  }
}

/// Starting difficulty from owner answers (weak prior; the difficulty
/// controller takes over from the first trial). Experience sets the base;
/// senior cats and mobility limitations cap it low so progression starts
/// gently. Documented in docs/PERSONALISATION.md section "Initial priors".
int initialDifficultyFor(CatProfileDraft draft) {
  var difficulty = switch (draft.screenExperience) {
    ScreenExperience.none => 1,
    ScreenExperience.some => 2,
    ScreenExperience.frequent => 3,
  };
  final gentle =
      draft.ageGroup == AgeGroup.senior ||
      draft.ageGroup == AgeGroup.kitten ||
      draft.mobilityConsideration != MobilityConsideration.none;
  if (gentle && difficulty > 2) difficulty = 2;
  return difficulty;
}
