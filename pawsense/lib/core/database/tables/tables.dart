import 'package:drift/drift.dart';

import '../../../shared/models/enums.dart';
import '../converters.dart';

/// Schema notes
///
/// - Primary keys are UUID v4 strings generated in repositories.
/// - Enums persist by name (`textEnum`); renaming/reordering persisted enum
///   values is a breaking change requiring a migration.
/// - DateTimes persist as ISO-8601 UTC text (see build.yaml); repositories
///   must only write values obtained from [Clock.nowUtc].
/// - Foreign keys cascade so profile deletion removes all dependent data;
///   `PRAGMA foreign_keys = ON` is enabled in `beforeOpen`.

class CatProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 40)();

  /// Path relative to the app documents directory, or null for the initial
  /// letter avatar.
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();
  DateTimeColumn get archivedAtUtc => dateTime().nullable()();

  TextColumn get ageGroup => textEnum<AgeGroup>()();
  TextColumn get bodySize => textEnum<BodySize>()();
  TextColumn get energyLevel => textEnum<EnergyLevel>()();
  TextColumn get screenExperience => textEnum<ScreenExperience>()();
  TextColumn get favouritePrey => textEnum<FavouritePrey>().nullable()();
  TextColumn get soundSensitivity => textEnum<SoundSensitivity>()();
  TextColumn get treatMotivation => textEnum<TreatMotivation>()();
  TextColumn get mobilityConsideration => textEnum<MobilityConsideration>()();
  TextColumn get visionConsideration => textEnum<VisionConsideration>()();
  TextColumn get hearingConsideration => textEnum<HearingConsideration>()();
  TextColumn get primaryGoal => textEnum<PrimaryGoal>()();
  TextColumn get notes => text().nullable()();

  IntColumn get onboardingVersion => integer()();
  TextColumn get calibrationState => textEnum<CalibrationState>()();

  /// 0-10; live value maintained by the difficulty controller.
  IntColumn get currentDifficulty => integer()();
  TextColumn get algorithmVersion => text()();

  /// Explicit ordering for the profile picker (lower first).
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VoiceCues extends Table {
  TextColumn get id => text()();
  TextColumn get catId =>
      text().references(CatProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get cueType => textEnum<CueType>()();

  /// Path relative to the app documents directory.
  TextColumn get filePath => text()();
  IntColumn get durationMs => integer()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {catId, cueType},
  ];
}

class Sessions extends Table {
  TextColumn get id => text()();

  /// Null for mixed sessions (no individual cat attribution).
  TextColumn get catId => text().nullable().references(
    CatProfiles,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get mode => textEnum<SessionMode>()();
  DateTimeColumn get startedAtUtc => dateTime()();
  DateTimeColumn get endedAtUtc => dateTime().nullable()();
  IntColumn get plannedDurationSeconds => integer()();
  IntColumn get actualDurationMs => integer().nullable()();
  TextColumn get status => textEnum<SessionStatus>()();
  BoolColumn get calibrationSession => boolean()();
  IntColumn get randomSeed => integer()();
  TextColumn get algorithmVersion => text()();
  TextColumn get appVersion => text()();
  TextColumn get platform => text()();
  RealColumn get screenWidthLogical => real()();
  RealColumn get screenHeightLogical => real()();
  TextColumn get ownerSubjectiveFeedback =>
      textEnum<OwnerFeedback>().nullable()();

  // Aggregates, filled when the session is finalised.
  IntColumn get catches => integer()();
  IntColumn get misses => integer()();
  IntColumn get timeouts => integer()();
  IntColumn get medianReactionMs => integer().nullable()();
  IntColumn get frustrationCount => integer()();

  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TargetTrials extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get trialIndex => integer()();

  TextColumn get targetType => textEnum<PreyType>()();
  TextColumn get movementStyle => textEnum<MovementStyle>()();
  TextColumn get speedLevel => textEnum<SpeedLevel>()();
  TextColumn get sizeLevel => textEnum<SizeLevel>()();
  TextColumn get soundMode => textEnum<SoundMode>()();
  TextColumn get spawnZone => textEnum<SpawnZone>()();

  DateTimeColumn get spawnedAtUtc => dateTime()();
  DateTimeColumn get becameTouchableAtUtc => dateTime()();
  DateTimeColumn get endedAtUtc => dateTime().nullable()();
  RealColumn get spawnXNormalised => real()();
  RealColumn get spawnYNormalised => real()();
  IntColumn get targetPathSeed => integer()();

  BoolColumn get success => boolean()();
  DateTimeColumn get firstSuccessfulTouchAtUtc => dateTime().nullable()();
  IntColumn get reactionTimeMs => integer().nullable()();
  IntColumn get missCount => integer()();
  BoolColumn get timeout => boolean()();

  TextColumn get cueType => textEnum<CueType>().nullable()();
  TextColumn get praiseCueType => textEnum<CueType>().nullable()();
  BoolColumn get rewardReminderShown => boolean()();

  /// 0 none, 1 mild, 2 repeated, 3 high.
  IntColumn get frustrationSeverity => integer()();
  TextColumn get frustrationFlags =>
      text().map(const FrustrationFlagSetConverter())();
  RealColumn get trialReward => real()();
  TextColumn get algorithmVersion => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TouchEvents extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get trialId => text().nullable().references(
    TargetTrials,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get pointerId => integer()();

  /// Groups raw contacts that were clustered into one paw interaction.
  IntColumn get logicalInteractionId => integer()();
  DateTimeColumn get occurredAtUtc => dateTime()();
  RealColumn get xNormalised => real()();
  RealColumn get yNormalised => real()();
  TextColumn get classification => textEnum<TouchClassification>()();
  BoolColumn get deduplicated => boolean()();

  /// Distance from the active target centre in shortest-dimension units,
  /// null when no target was active.
  RealColumn get distanceFromTarget => real().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PreferenceStats extends Table {
  TextColumn get id => text()();
  TextColumn get catId =>
      text().references(CatProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get factorType => textEnum<FactorType>()();
  TextColumn get factorValue => text()();

  // Real-valued because they decay gently (DECISIONS.md D-005). Raw history
  // stays in TargetTrials; these are the model's working counters.
  RealColumn get impressions => real()();
  RealColumn get successes => real()();
  RealColumn get timeouts => real()();
  RealColumn get totalMisses => real()();
  RealColumn get frustrationCount => real()();
  RealColumn get reactionTimeEwmaMs => real().nullable()();
  RealColumn get cumulativeReward => real()();

  DateTimeColumn get lastUsedAtUtc => dateTime().nullable()();
  DateTimeColumn get updatedAtUtc => dateTime()();
  TextColumn get algorithmVersion => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {catId, factorType, factorValue, algorithmVersion},
  ];
}

class CueProgress extends Table {
  TextColumn get id => text()();
  TextColumn get catId =>
      text().references(CatProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get cueType => textEnum<CueType>()();
  IntColumn get exposures => integer()();
  IntColumn get successfulResponses => integer()();
  RealColumn get reactionTimeEwmaMs => real().nullable()();
  DateTimeColumn get lastUsedAtUtc => dateTime().nullable()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {catId, cueType},
  ];
}

/// Single-row settings table; the row (id = 1) is inserted at creation.
class AppSettings extends Table {
  IntColumn get id => integer()();
  IntColumn get defaultSessionDurationSeconds =>
      integer().withDefault(const Constant(180))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get rewardSchedule => textEnum<RewardSchedule>().withDefault(
    Constant(RewardSchedule.none.name),
  )();
  IntColumn get maxRewardReminders =>
      integer().withDefault(const Constant(3))();
  TextColumn get ownerPinHash => text().nullable()();
  TextColumn get ownerPinSalt => text().nullable()();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  IntColumn get privacyVersionAccepted =>
      integer().withDefault(const Constant(0))();
  TextColumn get preferredLocale => text().nullable()();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();
  BoolColumn get highContrastMode =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
