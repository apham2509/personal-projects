/// Core domain enums for PawSense.
///
/// All enums are persisted by `name` (see the Drift tables), so renaming a
/// value is a breaking schema change and requires a migration. Add new values
/// at the end; never reorder.
library;

// ---------------------------------------------------------------------------
// Trial configuration factors
// ---------------------------------------------------------------------------

enum PreyType { mouse, moth, fish }

enum MovementStyle { smooth, stopAndGo, unpredictable }

enum SpeedLevel { slow, medium, fast }

enum SizeLevel { small, medium, large }

enum SoundMode { silent, sound }

/// Coarse region of the safe play area where a target first appears.
enum SpawnZone { centre, top, bottom, left, right }

/// The factor dimensions the personalisation model tracks independently.
enum FactorType {
  targetType,
  movementStyle,
  speedLevel,
  sizeLevel,
  soundMode,
  spawnZone,
}

// ---------------------------------------------------------------------------
// Cat profile questionnaire
// ---------------------------------------------------------------------------

enum AgeGroup { kitten, youngAdult, adult, senior, unknown }

enum BodySize { small, medium, large }

enum EnergyLevel { low, medium, high }

enum ScreenExperience { none, some, frequent }

enum FavouritePrey { mouse, mothBug, fish, feather, ball, other, unknown }

enum SoundSensitivity { enjoysSound, neutral, easilyStartled, unknown }

enum TreatMotivation { low, medium, high, unknown }

enum MobilityConsideration { none, limitedMovement, seniorFriendly }

enum VisionConsideration { noneKnown, reducedVision, unknown }

enum HearingConsideration { noneKnown, reducedHearing, unknown }

enum PrimaryGoal { play, mentalEnrichment, verbalCueTraining, gentleActivity }

enum CalibrationState { notStarted, inProgress, completed, skipped }

// ---------------------------------------------------------------------------
// Sessions and events
// ---------------------------------------------------------------------------

enum SessionMode { freePlay, touchTraining, calibration, mixed }

enum SessionStatus {
  inProgress,
  completed,
  ownerStopped,
  disengaged,
  frustrated,
  backgrounded,
  interrupted,
}

/// Owner-recorded voice cue slots. One recording per slot per cat.
enum CueType { catName, touch, good, goodJob, allDone }

enum TouchClassification {
  hit,
  miss,
  edge,
  postCapture,
  ownerGesture,
  ignoredDuplicate,
}

enum RewardSchedule { none, manualOnly, everyThreeCatches, variableTwoToFive }

/// The owner's subjective impression, stored separately from observed data.
enum OwnerFeedback { engaged, neutral, frustrated }

/// Why a session stopped. Mirrors [SessionStatus] terminal values.
enum FrustrationFlag {
  missBurst,
  edgeBurst,
  postCaptureBurst,
  rapidTapBurst,
  longHold,
  consecutiveTimeouts,
  repeatedImpossibleReach,
}

/// Confidence tiers used by owner-facing insights.
enum ConfidenceTier {
  insufficient,
  earlyObservation,
  developingPattern,
  strongPattern,
}
