// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatProfilesTable extends CatProfiles
    with TableInfo<$CatProfilesTable, CatProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtUtcMeta = const VerificationMeta(
    'archivedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAtUtc =
      GeneratedColumn<DateTime>(
        'archived_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<AgeGroup, String> ageGroup =
      GeneratedColumn<String>(
        'age_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AgeGroup>($CatProfilesTable.$converterageGroup);
  @override
  late final GeneratedColumnWithTypeConverter<BodySize, String> bodySize =
      GeneratedColumn<String>(
        'body_size',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BodySize>($CatProfilesTable.$converterbodySize);
  @override
  late final GeneratedColumnWithTypeConverter<EnergyLevel, String> energyLevel =
      GeneratedColumn<String>(
        'energy_level',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EnergyLevel>($CatProfilesTable.$converterenergyLevel);
  @override
  late final GeneratedColumnWithTypeConverter<ScreenExperience, String>
  screenExperience =
      GeneratedColumn<String>(
        'screen_experience',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ScreenExperience>(
        $CatProfilesTable.$converterscreenExperience,
      );
  @override
  late final GeneratedColumnWithTypeConverter<FavouritePrey?, String>
  favouritePrey = GeneratedColumn<String>(
    'favourite_prey',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<FavouritePrey?>($CatProfilesTable.$converterfavouritePreyn);
  @override
  late final GeneratedColumnWithTypeConverter<SoundSensitivity, String>
  soundSensitivity =
      GeneratedColumn<String>(
        'sound_sensitivity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SoundSensitivity>(
        $CatProfilesTable.$convertersoundSensitivity,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TreatMotivation, String>
  treatMotivation = GeneratedColumn<String>(
    'treat_motivation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TreatMotivation>($CatProfilesTable.$convertertreatMotivation);
  @override
  late final GeneratedColumnWithTypeConverter<MobilityConsideration, String>
  mobilityConsideration =
      GeneratedColumn<String>(
        'mobility_consideration',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MobilityConsideration>(
        $CatProfilesTable.$convertermobilityConsideration,
      );
  @override
  late final GeneratedColumnWithTypeConverter<VisionConsideration, String>
  visionConsideration =
      GeneratedColumn<String>(
        'vision_consideration',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<VisionConsideration>(
        $CatProfilesTable.$convertervisionConsideration,
      );
  @override
  late final GeneratedColumnWithTypeConverter<HearingConsideration, String>
  hearingConsideration =
      GeneratedColumn<String>(
        'hearing_consideration',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HearingConsideration>(
        $CatProfilesTable.$converterhearingConsideration,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PrimaryGoal, String> primaryGoal =
      GeneratedColumn<String>(
        'primary_goal',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PrimaryGoal>($CatProfilesTable.$converterprimaryGoal);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingVersionMeta = const VerificationMeta(
    'onboardingVersion',
  );
  @override
  late final GeneratedColumn<int> onboardingVersion = GeneratedColumn<int>(
    'onboarding_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CalibrationState, String>
  calibrationState =
      GeneratedColumn<String>(
        'calibration_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CalibrationState>(
        $CatProfilesTable.$convertercalibrationState,
      );
  static const VerificationMeta _currentDifficultyMeta = const VerificationMeta(
    'currentDifficulty',
  );
  @override
  late final GeneratedColumn<int> currentDifficulty = GeneratedColumn<int>(
    'current_difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _algorithmVersionMeta = const VerificationMeta(
    'algorithmVersion',
  );
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
    'algorithm_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    photoPath,
    createdAtUtc,
    updatedAtUtc,
    archivedAtUtc,
    ageGroup,
    bodySize,
    energyLevel,
    screenExperience,
    favouritePrey,
    soundSensitivity,
    treatMotivation,
    mobilityConsideration,
    visionConsideration,
    hearingConsideration,
    primaryGoal,
    notes,
    onboardingVersion,
    calibrationState,
    currentDifficulty,
    algorithmVersion,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cat_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('archived_at_utc')) {
      context.handle(
        _archivedAtUtcMeta,
        archivedAtUtc.isAcceptableOrUnknown(
          data['archived_at_utc']!,
          _archivedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('onboarding_version')) {
      context.handle(
        _onboardingVersionMeta,
        onboardingVersion.isAcceptableOrUnknown(
          data['onboarding_version']!,
          _onboardingVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onboardingVersionMeta);
    }
    if (data.containsKey('current_difficulty')) {
      context.handle(
        _currentDifficultyMeta,
        currentDifficulty.isAcceptableOrUnknown(
          data['current_difficulty']!,
          _currentDifficultyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentDifficultyMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
        _algorithmVersionMeta,
        algorithmVersion.isAcceptableOrUnknown(
          data['algorithm_version']!,
          _algorithmVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      archivedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at_utc'],
      ),
      ageGroup: $CatProfilesTable.$converterageGroup.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}age_group'],
        )!,
      ),
      bodySize: $CatProfilesTable.$converterbodySize.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}body_size'],
        )!,
      ),
      energyLevel: $CatProfilesTable.$converterenergyLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}energy_level'],
        )!,
      ),
      screenExperience: $CatProfilesTable.$converterscreenExperience.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}screen_experience'],
        )!,
      ),
      favouritePrey: $CatProfilesTable.$converterfavouritePreyn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}favourite_prey'],
        ),
      ),
      soundSensitivity: $CatProfilesTable.$convertersoundSensitivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sound_sensitivity'],
        )!,
      ),
      treatMotivation: $CatProfilesTable.$convertertreatMotivation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}treat_motivation'],
        )!,
      ),
      mobilityConsideration: $CatProfilesTable.$convertermobilityConsideration
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}mobility_consideration'],
            )!,
          ),
      visionConsideration: $CatProfilesTable.$convertervisionConsideration
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}vision_consideration'],
            )!,
          ),
      hearingConsideration: $CatProfilesTable.$converterhearingConsideration
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}hearing_consideration'],
            )!,
          ),
      primaryGoal: $CatProfilesTable.$converterprimaryGoal.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}primary_goal'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      onboardingVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onboarding_version'],
      )!,
      calibrationState: $CatProfilesTable.$convertercalibrationState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}calibration_state'],
        )!,
      ),
      currentDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_difficulty'],
      )!,
      algorithmVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm_version'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CatProfilesTable createAlias(String alias) {
    return $CatProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AgeGroup, String, String> $converterageGroup =
      const EnumNameConverter<AgeGroup>(AgeGroup.values);
  static JsonTypeConverter2<BodySize, String, String> $converterbodySize =
      const EnumNameConverter<BodySize>(BodySize.values);
  static JsonTypeConverter2<EnergyLevel, String, String> $converterenergyLevel =
      const EnumNameConverter<EnergyLevel>(EnergyLevel.values);
  static JsonTypeConverter2<ScreenExperience, String, String>
  $converterscreenExperience = const EnumNameConverter<ScreenExperience>(
    ScreenExperience.values,
  );
  static JsonTypeConverter2<FavouritePrey, String, String>
  $converterfavouritePrey = const EnumNameConverter<FavouritePrey>(
    FavouritePrey.values,
  );
  static JsonTypeConverter2<FavouritePrey?, String?, String?>
  $converterfavouritePreyn = JsonTypeConverter2.asNullable(
    $converterfavouritePrey,
  );
  static JsonTypeConverter2<SoundSensitivity, String, String>
  $convertersoundSensitivity = const EnumNameConverter<SoundSensitivity>(
    SoundSensitivity.values,
  );
  static JsonTypeConverter2<TreatMotivation, String, String>
  $convertertreatMotivation = const EnumNameConverter<TreatMotivation>(
    TreatMotivation.values,
  );
  static JsonTypeConverter2<MobilityConsideration, String, String>
  $convertermobilityConsideration =
      const EnumNameConverter<MobilityConsideration>(
        MobilityConsideration.values,
      );
  static JsonTypeConverter2<VisionConsideration, String, String>
  $convertervisionConsideration = const EnumNameConverter<VisionConsideration>(
    VisionConsideration.values,
  );
  static JsonTypeConverter2<HearingConsideration, String, String>
  $converterhearingConsideration =
      const EnumNameConverter<HearingConsideration>(
        HearingConsideration.values,
      );
  static JsonTypeConverter2<PrimaryGoal, String, String> $converterprimaryGoal =
      const EnumNameConverter<PrimaryGoal>(PrimaryGoal.values);
  static JsonTypeConverter2<CalibrationState, String, String>
  $convertercalibrationState = const EnumNameConverter<CalibrationState>(
    CalibrationState.values,
  );
}

class CatProfile extends DataClass implements Insertable<CatProfile> {
  final String id;
  final String name;

  /// Path relative to the app documents directory, or null for the initial
  /// letter avatar.
  final String? photoPath;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final DateTime? archivedAtUtc;
  final AgeGroup ageGroup;
  final BodySize bodySize;
  final EnergyLevel energyLevel;
  final ScreenExperience screenExperience;
  final FavouritePrey? favouritePrey;
  final SoundSensitivity soundSensitivity;
  final TreatMotivation treatMotivation;
  final MobilityConsideration mobilityConsideration;
  final VisionConsideration visionConsideration;
  final HearingConsideration hearingConsideration;
  final PrimaryGoal primaryGoal;
  final String? notes;
  final int onboardingVersion;
  final CalibrationState calibrationState;

  /// 0-10; live value maintained by the difficulty controller.
  final int currentDifficulty;
  final String algorithmVersion;

  /// Explicit ordering for the profile picker (lower first).
  final int sortOrder;
  const CatProfile({
    required this.id,
    required this.name,
    this.photoPath,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.archivedAtUtc,
    required this.ageGroup,
    required this.bodySize,
    required this.energyLevel,
    required this.screenExperience,
    this.favouritePrey,
    required this.soundSensitivity,
    required this.treatMotivation,
    required this.mobilityConsideration,
    required this.visionConsideration,
    required this.hearingConsideration,
    required this.primaryGoal,
    this.notes,
    required this.onboardingVersion,
    required this.calibrationState,
    required this.currentDifficulty,
    required this.algorithmVersion,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<DateTime>(archivedAtUtc);
    }
    {
      map['age_group'] = Variable<String>(
        $CatProfilesTable.$converterageGroup.toSql(ageGroup),
      );
    }
    {
      map['body_size'] = Variable<String>(
        $CatProfilesTable.$converterbodySize.toSql(bodySize),
      );
    }
    {
      map['energy_level'] = Variable<String>(
        $CatProfilesTable.$converterenergyLevel.toSql(energyLevel),
      );
    }
    {
      map['screen_experience'] = Variable<String>(
        $CatProfilesTable.$converterscreenExperience.toSql(screenExperience),
      );
    }
    if (!nullToAbsent || favouritePrey != null) {
      map['favourite_prey'] = Variable<String>(
        $CatProfilesTable.$converterfavouritePreyn.toSql(favouritePrey),
      );
    }
    {
      map['sound_sensitivity'] = Variable<String>(
        $CatProfilesTable.$convertersoundSensitivity.toSql(soundSensitivity),
      );
    }
    {
      map['treat_motivation'] = Variable<String>(
        $CatProfilesTable.$convertertreatMotivation.toSql(treatMotivation),
      );
    }
    {
      map['mobility_consideration'] = Variable<String>(
        $CatProfilesTable.$convertermobilityConsideration.toSql(
          mobilityConsideration,
        ),
      );
    }
    {
      map['vision_consideration'] = Variable<String>(
        $CatProfilesTable.$convertervisionConsideration.toSql(
          visionConsideration,
        ),
      );
    }
    {
      map['hearing_consideration'] = Variable<String>(
        $CatProfilesTable.$converterhearingConsideration.toSql(
          hearingConsideration,
        ),
      );
    }
    {
      map['primary_goal'] = Variable<String>(
        $CatProfilesTable.$converterprimaryGoal.toSql(primaryGoal),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['onboarding_version'] = Variable<int>(onboardingVersion);
    {
      map['calibration_state'] = Variable<String>(
        $CatProfilesTable.$convertercalibrationState.toSql(calibrationState),
      );
    }
    map['current_difficulty'] = Variable<int>(currentDifficulty);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CatProfilesCompanion toCompanion(bool nullToAbsent) {
    return CatProfilesCompanion(
      id: Value(id),
      name: Value(name),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
      ageGroup: Value(ageGroup),
      bodySize: Value(bodySize),
      energyLevel: Value(energyLevel),
      screenExperience: Value(screenExperience),
      favouritePrey: favouritePrey == null && nullToAbsent
          ? const Value.absent()
          : Value(favouritePrey),
      soundSensitivity: Value(soundSensitivity),
      treatMotivation: Value(treatMotivation),
      mobilityConsideration: Value(mobilityConsideration),
      visionConsideration: Value(visionConsideration),
      hearingConsideration: Value(hearingConsideration),
      primaryGoal: Value(primaryGoal),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      onboardingVersion: Value(onboardingVersion),
      calibrationState: Value(calibrationState),
      currentDifficulty: Value(currentDifficulty),
      algorithmVersion: Value(algorithmVersion),
      sortOrder: Value(sortOrder),
    );
  }

  factory CatProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      archivedAtUtc: serializer.fromJson<DateTime?>(json['archivedAtUtc']),
      ageGroup: $CatProfilesTable.$converterageGroup.fromJson(
        serializer.fromJson<String>(json['ageGroup']),
      ),
      bodySize: $CatProfilesTable.$converterbodySize.fromJson(
        serializer.fromJson<String>(json['bodySize']),
      ),
      energyLevel: $CatProfilesTable.$converterenergyLevel.fromJson(
        serializer.fromJson<String>(json['energyLevel']),
      ),
      screenExperience: $CatProfilesTable.$converterscreenExperience.fromJson(
        serializer.fromJson<String>(json['screenExperience']),
      ),
      favouritePrey: $CatProfilesTable.$converterfavouritePreyn.fromJson(
        serializer.fromJson<String?>(json['favouritePrey']),
      ),
      soundSensitivity: $CatProfilesTable.$convertersoundSensitivity.fromJson(
        serializer.fromJson<String>(json['soundSensitivity']),
      ),
      treatMotivation: $CatProfilesTable.$convertertreatMotivation.fromJson(
        serializer.fromJson<String>(json['treatMotivation']),
      ),
      mobilityConsideration: $CatProfilesTable.$convertermobilityConsideration
          .fromJson(serializer.fromJson<String>(json['mobilityConsideration'])),
      visionConsideration: $CatProfilesTable.$convertervisionConsideration
          .fromJson(serializer.fromJson<String>(json['visionConsideration'])),
      hearingConsideration: $CatProfilesTable.$converterhearingConsideration
          .fromJson(serializer.fromJson<String>(json['hearingConsideration'])),
      primaryGoal: $CatProfilesTable.$converterprimaryGoal.fromJson(
        serializer.fromJson<String>(json['primaryGoal']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      onboardingVersion: serializer.fromJson<int>(json['onboardingVersion']),
      calibrationState: $CatProfilesTable.$convertercalibrationState.fromJson(
        serializer.fromJson<String>(json['calibrationState']),
      ),
      currentDifficulty: serializer.fromJson<int>(json['currentDifficulty']),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'archivedAtUtc': serializer.toJson<DateTime?>(archivedAtUtc),
      'ageGroup': serializer.toJson<String>(
        $CatProfilesTable.$converterageGroup.toJson(ageGroup),
      ),
      'bodySize': serializer.toJson<String>(
        $CatProfilesTable.$converterbodySize.toJson(bodySize),
      ),
      'energyLevel': serializer.toJson<String>(
        $CatProfilesTable.$converterenergyLevel.toJson(energyLevel),
      ),
      'screenExperience': serializer.toJson<String>(
        $CatProfilesTable.$converterscreenExperience.toJson(screenExperience),
      ),
      'favouritePrey': serializer.toJson<String?>(
        $CatProfilesTable.$converterfavouritePreyn.toJson(favouritePrey),
      ),
      'soundSensitivity': serializer.toJson<String>(
        $CatProfilesTable.$convertersoundSensitivity.toJson(soundSensitivity),
      ),
      'treatMotivation': serializer.toJson<String>(
        $CatProfilesTable.$convertertreatMotivation.toJson(treatMotivation),
      ),
      'mobilityConsideration': serializer.toJson<String>(
        $CatProfilesTable.$convertermobilityConsideration.toJson(
          mobilityConsideration,
        ),
      ),
      'visionConsideration': serializer.toJson<String>(
        $CatProfilesTable.$convertervisionConsideration.toJson(
          visionConsideration,
        ),
      ),
      'hearingConsideration': serializer.toJson<String>(
        $CatProfilesTable.$converterhearingConsideration.toJson(
          hearingConsideration,
        ),
      ),
      'primaryGoal': serializer.toJson<String>(
        $CatProfilesTable.$converterprimaryGoal.toJson(primaryGoal),
      ),
      'notes': serializer.toJson<String?>(notes),
      'onboardingVersion': serializer.toJson<int>(onboardingVersion),
      'calibrationState': serializer.toJson<String>(
        $CatProfilesTable.$convertercalibrationState.toJson(calibrationState),
      ),
      'currentDifficulty': serializer.toJson<int>(currentDifficulty),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CatProfile copyWith({
    String? id,
    String? name,
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    Value<DateTime?> archivedAtUtc = const Value.absent(),
    AgeGroup? ageGroup,
    BodySize? bodySize,
    EnergyLevel? energyLevel,
    ScreenExperience? screenExperience,
    Value<FavouritePrey?> favouritePrey = const Value.absent(),
    SoundSensitivity? soundSensitivity,
    TreatMotivation? treatMotivation,
    MobilityConsideration? mobilityConsideration,
    VisionConsideration? visionConsideration,
    HearingConsideration? hearingConsideration,
    PrimaryGoal? primaryGoal,
    Value<String?> notes = const Value.absent(),
    int? onboardingVersion,
    CalibrationState? calibrationState,
    int? currentDifficulty,
    String? algorithmVersion,
    int? sortOrder,
  }) => CatProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
    ageGroup: ageGroup ?? this.ageGroup,
    bodySize: bodySize ?? this.bodySize,
    energyLevel: energyLevel ?? this.energyLevel,
    screenExperience: screenExperience ?? this.screenExperience,
    favouritePrey: favouritePrey.present
        ? favouritePrey.value
        : this.favouritePrey,
    soundSensitivity: soundSensitivity ?? this.soundSensitivity,
    treatMotivation: treatMotivation ?? this.treatMotivation,
    mobilityConsideration: mobilityConsideration ?? this.mobilityConsideration,
    visionConsideration: visionConsideration ?? this.visionConsideration,
    hearingConsideration: hearingConsideration ?? this.hearingConsideration,
    primaryGoal: primaryGoal ?? this.primaryGoal,
    notes: notes.present ? notes.value : this.notes,
    onboardingVersion: onboardingVersion ?? this.onboardingVersion,
    calibrationState: calibrationState ?? this.calibrationState,
    currentDifficulty: currentDifficulty ?? this.currentDifficulty,
    algorithmVersion: algorithmVersion ?? this.algorithmVersion,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CatProfile copyWithCompanion(CatProfilesCompanion data) {
    return CatProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      archivedAtUtc: data.archivedAtUtc.present
          ? data.archivedAtUtc.value
          : this.archivedAtUtc,
      ageGroup: data.ageGroup.present ? data.ageGroup.value : this.ageGroup,
      bodySize: data.bodySize.present ? data.bodySize.value : this.bodySize,
      energyLevel: data.energyLevel.present
          ? data.energyLevel.value
          : this.energyLevel,
      screenExperience: data.screenExperience.present
          ? data.screenExperience.value
          : this.screenExperience,
      favouritePrey: data.favouritePrey.present
          ? data.favouritePrey.value
          : this.favouritePrey,
      soundSensitivity: data.soundSensitivity.present
          ? data.soundSensitivity.value
          : this.soundSensitivity,
      treatMotivation: data.treatMotivation.present
          ? data.treatMotivation.value
          : this.treatMotivation,
      mobilityConsideration: data.mobilityConsideration.present
          ? data.mobilityConsideration.value
          : this.mobilityConsideration,
      visionConsideration: data.visionConsideration.present
          ? data.visionConsideration.value
          : this.visionConsideration,
      hearingConsideration: data.hearingConsideration.present
          ? data.hearingConsideration.value
          : this.hearingConsideration,
      primaryGoal: data.primaryGoal.present
          ? data.primaryGoal.value
          : this.primaryGoal,
      notes: data.notes.present ? data.notes.value : this.notes,
      onboardingVersion: data.onboardingVersion.present
          ? data.onboardingVersion.value
          : this.onboardingVersion,
      calibrationState: data.calibrationState.present
          ? data.calibrationState.value
          : this.calibrationState,
      currentDifficulty: data.currentDifficulty.present
          ? data.currentDifficulty.value
          : this.currentDifficulty,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('bodySize: $bodySize, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('screenExperience: $screenExperience, ')
          ..write('favouritePrey: $favouritePrey, ')
          ..write('soundSensitivity: $soundSensitivity, ')
          ..write('treatMotivation: $treatMotivation, ')
          ..write('mobilityConsideration: $mobilityConsideration, ')
          ..write('visionConsideration: $visionConsideration, ')
          ..write('hearingConsideration: $hearingConsideration, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('notes: $notes, ')
          ..write('onboardingVersion: $onboardingVersion, ')
          ..write('calibrationState: $calibrationState, ')
          ..write('currentDifficulty: $currentDifficulty, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    photoPath,
    createdAtUtc,
    updatedAtUtc,
    archivedAtUtc,
    ageGroup,
    bodySize,
    energyLevel,
    screenExperience,
    favouritePrey,
    soundSensitivity,
    treatMotivation,
    mobilityConsideration,
    visionConsideration,
    hearingConsideration,
    primaryGoal,
    notes,
    onboardingVersion,
    calibrationState,
    currentDifficulty,
    algorithmVersion,
    sortOrder,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.photoPath == this.photoPath &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc &&
          other.ageGroup == this.ageGroup &&
          other.bodySize == this.bodySize &&
          other.energyLevel == this.energyLevel &&
          other.screenExperience == this.screenExperience &&
          other.favouritePrey == this.favouritePrey &&
          other.soundSensitivity == this.soundSensitivity &&
          other.treatMotivation == this.treatMotivation &&
          other.mobilityConsideration == this.mobilityConsideration &&
          other.visionConsideration == this.visionConsideration &&
          other.hearingConsideration == this.hearingConsideration &&
          other.primaryGoal == this.primaryGoal &&
          other.notes == this.notes &&
          other.onboardingVersion == this.onboardingVersion &&
          other.calibrationState == this.calibrationState &&
          other.currentDifficulty == this.currentDifficulty &&
          other.algorithmVersion == this.algorithmVersion &&
          other.sortOrder == this.sortOrder);
}

class CatProfilesCompanion extends UpdateCompanion<CatProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> photoPath;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<DateTime?> archivedAtUtc;
  final Value<AgeGroup> ageGroup;
  final Value<BodySize> bodySize;
  final Value<EnergyLevel> energyLevel;
  final Value<ScreenExperience> screenExperience;
  final Value<FavouritePrey?> favouritePrey;
  final Value<SoundSensitivity> soundSensitivity;
  final Value<TreatMotivation> treatMotivation;
  final Value<MobilityConsideration> mobilityConsideration;
  final Value<VisionConsideration> visionConsideration;
  final Value<HearingConsideration> hearingConsideration;
  final Value<PrimaryGoal> primaryGoal;
  final Value<String?> notes;
  final Value<int> onboardingVersion;
  final Value<CalibrationState> calibrationState;
  final Value<int> currentDifficulty;
  final Value<String> algorithmVersion;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CatProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.ageGroup = const Value.absent(),
    this.bodySize = const Value.absent(),
    this.energyLevel = const Value.absent(),
    this.screenExperience = const Value.absent(),
    this.favouritePrey = const Value.absent(),
    this.soundSensitivity = const Value.absent(),
    this.treatMotivation = const Value.absent(),
    this.mobilityConsideration = const Value.absent(),
    this.visionConsideration = const Value.absent(),
    this.hearingConsideration = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.notes = const Value.absent(),
    this.onboardingVersion = const Value.absent(),
    this.calibrationState = const Value.absent(),
    this.currentDifficulty = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatProfilesCompanion.insert({
    required String id,
    required String name,
    this.photoPath = const Value.absent(),
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.archivedAtUtc = const Value.absent(),
    required AgeGroup ageGroup,
    required BodySize bodySize,
    required EnergyLevel energyLevel,
    required ScreenExperience screenExperience,
    this.favouritePrey = const Value.absent(),
    required SoundSensitivity soundSensitivity,
    required TreatMotivation treatMotivation,
    required MobilityConsideration mobilityConsideration,
    required VisionConsideration visionConsideration,
    required HearingConsideration hearingConsideration,
    required PrimaryGoal primaryGoal,
    this.notes = const Value.absent(),
    required int onboardingVersion,
    required CalibrationState calibrationState,
    required int currentDifficulty,
    required String algorithmVersion,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       ageGroup = Value(ageGroup),
       bodySize = Value(bodySize),
       energyLevel = Value(energyLevel),
       screenExperience = Value(screenExperience),
       soundSensitivity = Value(soundSensitivity),
       treatMotivation = Value(treatMotivation),
       mobilityConsideration = Value(mobilityConsideration),
       visionConsideration = Value(visionConsideration),
       hearingConsideration = Value(hearingConsideration),
       primaryGoal = Value(primaryGoal),
       onboardingVersion = Value(onboardingVersion),
       calibrationState = Value(calibrationState),
       currentDifficulty = Value(currentDifficulty),
       algorithmVersion = Value(algorithmVersion),
       sortOrder = Value(sortOrder);
  static Insertable<CatProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<DateTime>? archivedAtUtc,
    Expression<String>? ageGroup,
    Expression<String>? bodySize,
    Expression<String>? energyLevel,
    Expression<String>? screenExperience,
    Expression<String>? favouritePrey,
    Expression<String>? soundSensitivity,
    Expression<String>? treatMotivation,
    Expression<String>? mobilityConsideration,
    Expression<String>? visionConsideration,
    Expression<String>? hearingConsideration,
    Expression<String>? primaryGoal,
    Expression<String>? notes,
    Expression<int>? onboardingVersion,
    Expression<String>? calibrationState,
    Expression<int>? currentDifficulty,
    Expression<String>? algorithmVersion,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (ageGroup != null) 'age_group': ageGroup,
      if (bodySize != null) 'body_size': bodySize,
      if (energyLevel != null) 'energy_level': energyLevel,
      if (screenExperience != null) 'screen_experience': screenExperience,
      if (favouritePrey != null) 'favourite_prey': favouritePrey,
      if (soundSensitivity != null) 'sound_sensitivity': soundSensitivity,
      if (treatMotivation != null) 'treat_motivation': treatMotivation,
      if (mobilityConsideration != null)
        'mobility_consideration': mobilityConsideration,
      if (visionConsideration != null)
        'vision_consideration': visionConsideration,
      if (hearingConsideration != null)
        'hearing_consideration': hearingConsideration,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (notes != null) 'notes': notes,
      if (onboardingVersion != null) 'onboarding_version': onboardingVersion,
      if (calibrationState != null) 'calibration_state': calibrationState,
      if (currentDifficulty != null) 'current_difficulty': currentDifficulty,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? photoPath,
    Value<DateTime>? createdAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<DateTime?>? archivedAtUtc,
    Value<AgeGroup>? ageGroup,
    Value<BodySize>? bodySize,
    Value<EnergyLevel>? energyLevel,
    Value<ScreenExperience>? screenExperience,
    Value<FavouritePrey?>? favouritePrey,
    Value<SoundSensitivity>? soundSensitivity,
    Value<TreatMotivation>? treatMotivation,
    Value<MobilityConsideration>? mobilityConsideration,
    Value<VisionConsideration>? visionConsideration,
    Value<HearingConsideration>? hearingConsideration,
    Value<PrimaryGoal>? primaryGoal,
    Value<String?>? notes,
    Value<int>? onboardingVersion,
    Value<CalibrationState>? calibrationState,
    Value<int>? currentDifficulty,
    Value<String>? algorithmVersion,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CatProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      archivedAtUtc: archivedAtUtc ?? this.archivedAtUtc,
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
      onboardingVersion: onboardingVersion ?? this.onboardingVersion,
      calibrationState: calibrationState ?? this.calibrationState,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (archivedAtUtc.present) {
      map['archived_at_utc'] = Variable<DateTime>(archivedAtUtc.value);
    }
    if (ageGroup.present) {
      map['age_group'] = Variable<String>(
        $CatProfilesTable.$converterageGroup.toSql(ageGroup.value),
      );
    }
    if (bodySize.present) {
      map['body_size'] = Variable<String>(
        $CatProfilesTable.$converterbodySize.toSql(bodySize.value),
      );
    }
    if (energyLevel.present) {
      map['energy_level'] = Variable<String>(
        $CatProfilesTable.$converterenergyLevel.toSql(energyLevel.value),
      );
    }
    if (screenExperience.present) {
      map['screen_experience'] = Variable<String>(
        $CatProfilesTable.$converterscreenExperience.toSql(
          screenExperience.value,
        ),
      );
    }
    if (favouritePrey.present) {
      map['favourite_prey'] = Variable<String>(
        $CatProfilesTable.$converterfavouritePreyn.toSql(favouritePrey.value),
      );
    }
    if (soundSensitivity.present) {
      map['sound_sensitivity'] = Variable<String>(
        $CatProfilesTable.$convertersoundSensitivity.toSql(
          soundSensitivity.value,
        ),
      );
    }
    if (treatMotivation.present) {
      map['treat_motivation'] = Variable<String>(
        $CatProfilesTable.$convertertreatMotivation.toSql(
          treatMotivation.value,
        ),
      );
    }
    if (mobilityConsideration.present) {
      map['mobility_consideration'] = Variable<String>(
        $CatProfilesTable.$convertermobilityConsideration.toSql(
          mobilityConsideration.value,
        ),
      );
    }
    if (visionConsideration.present) {
      map['vision_consideration'] = Variable<String>(
        $CatProfilesTable.$convertervisionConsideration.toSql(
          visionConsideration.value,
        ),
      );
    }
    if (hearingConsideration.present) {
      map['hearing_consideration'] = Variable<String>(
        $CatProfilesTable.$converterhearingConsideration.toSql(
          hearingConsideration.value,
        ),
      );
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<String>(
        $CatProfilesTable.$converterprimaryGoal.toSql(primaryGoal.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (onboardingVersion.present) {
      map['onboarding_version'] = Variable<int>(onboardingVersion.value);
    }
    if (calibrationState.present) {
      map['calibration_state'] = Variable<String>(
        $CatProfilesTable.$convertercalibrationState.toSql(
          calibrationState.value,
        ),
      );
    }
    if (currentDifficulty.present) {
      map['current_difficulty'] = Variable<int>(currentDifficulty.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('bodySize: $bodySize, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('screenExperience: $screenExperience, ')
          ..write('favouritePrey: $favouritePrey, ')
          ..write('soundSensitivity: $soundSensitivity, ')
          ..write('treatMotivation: $treatMotivation, ')
          ..write('mobilityConsideration: $mobilityConsideration, ')
          ..write('visionConsideration: $visionConsideration, ')
          ..write('hearingConsideration: $hearingConsideration, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('notes: $notes, ')
          ..write('onboardingVersion: $onboardingVersion, ')
          ..write('calibrationState: $calibrationState, ')
          ..write('currentDifficulty: $currentDifficulty, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoiceCuesTable extends VoiceCues
    with TableInfo<$VoiceCuesTable, VoiceCue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoiceCuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cat_profiles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CueType, String> cueType =
      GeneratedColumn<String>(
        'cue_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CueType>($VoiceCuesTable.$convertercueType);
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    cueType,
    filePath,
    durationMs,
    createdAtUtc,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voice_cues';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoiceCue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {catId, cueType},
  ];
  @override
  VoiceCue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoiceCue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_id'],
      )!,
      cueType: $VoiceCuesTable.$convertercueType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cue_type'],
        )!,
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $VoiceCuesTable createAlias(String alias) {
    return $VoiceCuesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CueType, String, String> $convertercueType =
      const EnumNameConverter<CueType>(CueType.values);
}

class VoiceCue extends DataClass implements Insertable<VoiceCue> {
  final String id;
  final String catId;
  final CueType cueType;

  /// Path relative to the app documents directory.
  final String filePath;
  final int durationMs;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  const VoiceCue({
    required this.id,
    required this.catId,
    required this.cueType,
    required this.filePath,
    required this.durationMs,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cat_id'] = Variable<String>(catId);
    {
      map['cue_type'] = Variable<String>(
        $VoiceCuesTable.$convertercueType.toSql(cueType),
      );
    }
    map['file_path'] = Variable<String>(filePath);
    map['duration_ms'] = Variable<int>(durationMs);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  VoiceCuesCompanion toCompanion(bool nullToAbsent) {
    return VoiceCuesCompanion(
      id: Value(id),
      catId: Value(catId),
      cueType: Value(cueType),
      filePath: Value(filePath),
      durationMs: Value(durationMs),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory VoiceCue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoiceCue(
      id: serializer.fromJson<String>(json['id']),
      catId: serializer.fromJson<String>(json['catId']),
      cueType: $VoiceCuesTable.$convertercueType.fromJson(
        serializer.fromJson<String>(json['cueType']),
      ),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catId': serializer.toJson<String>(catId),
      'cueType': serializer.toJson<String>(
        $VoiceCuesTable.$convertercueType.toJson(cueType),
      ),
      'filePath': serializer.toJson<String>(filePath),
      'durationMs': serializer.toJson<int>(durationMs),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  VoiceCue copyWith({
    String? id,
    String? catId,
    CueType? cueType,
    String? filePath,
    int? durationMs,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
  }) => VoiceCue(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    cueType: cueType ?? this.cueType,
    filePath: filePath ?? this.filePath,
    durationMs: durationMs ?? this.durationMs,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  VoiceCue copyWithCompanion(VoiceCuesCompanion data) {
    return VoiceCue(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      cueType: data.cueType.present ? data.cueType.value : this.cueType,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoiceCue(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('cueType: $cueType, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    cueType,
    filePath,
    durationMs,
    createdAtUtc,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoiceCue &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.cueType == this.cueType &&
          other.filePath == this.filePath &&
          other.durationMs == this.durationMs &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class VoiceCuesCompanion extends UpdateCompanion<VoiceCue> {
  final Value<String> id;
  final Value<String> catId;
  final Value<CueType> cueType;
  final Value<String> filePath;
  final Value<int> durationMs;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const VoiceCuesCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.cueType = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoiceCuesCompanion.insert({
    required String id,
    required String catId,
    required CueType cueType,
    required String filePath,
    required int durationMs,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       catId = Value(catId),
       cueType = Value(cueType),
       filePath = Value(filePath),
       durationMs = Value(durationMs),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<VoiceCue> custom({
    Expression<String>? id,
    Expression<String>? catId,
    Expression<String>? cueType,
    Expression<String>? filePath,
    Expression<int>? durationMs,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (cueType != null) 'cue_type': cueType,
      if (filePath != null) 'file_path': filePath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoiceCuesCompanion copyWith({
    Value<String>? id,
    Value<String>? catId,
    Value<CueType>? cueType,
    Value<String>? filePath,
    Value<int>? durationMs,
    Value<DateTime>? createdAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return VoiceCuesCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      cueType: cueType ?? this.cueType,
      filePath: filePath ?? this.filePath,
      durationMs: durationMs ?? this.durationMs,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (cueType.present) {
      map['cue_type'] = Variable<String>(
        $VoiceCuesTable.$convertercueType.toSql(cueType.value),
      );
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoiceCuesCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('cueType: $cueType, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
    'cat_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cat_profiles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionMode>($SessionsTable.$convertermode);
  static const VerificationMeta _startedAtUtcMeta = const VerificationMeta(
    'startedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startedAtUtc = GeneratedColumn<DateTime>(
    'started_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtUtcMeta = const VerificationMeta(
    'endedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> endedAtUtc = GeneratedColumn<DateTime>(
    'ended_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDurationSecondsMeta =
      const VerificationMeta('plannedDurationSeconds');
  @override
  late final GeneratedColumn<int> plannedDurationSeconds = GeneratedColumn<int>(
    'planned_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualDurationMsMeta = const VerificationMeta(
    'actualDurationMs',
  );
  @override
  late final GeneratedColumn<int> actualDurationMs = GeneratedColumn<int>(
    'actual_duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionStatus>($SessionsTable.$converterstatus);
  static const VerificationMeta _calibrationSessionMeta =
      const VerificationMeta('calibrationSession');
  @override
  late final GeneratedColumn<bool> calibrationSession = GeneratedColumn<bool>(
    'calibration_session',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calibration_session" IN (0, 1))',
    ),
  );
  static const VerificationMeta _randomSeedMeta = const VerificationMeta(
    'randomSeed',
  );
  @override
  late final GeneratedColumn<int> randomSeed = GeneratedColumn<int>(
    'random_seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _algorithmVersionMeta = const VerificationMeta(
    'algorithmVersion',
  );
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
    'algorithm_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _screenWidthLogicalMeta =
      const VerificationMeta('screenWidthLogical');
  @override
  late final GeneratedColumn<double> screenWidthLogical =
      GeneratedColumn<double>(
        'screen_width_logical',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _screenHeightLogicalMeta =
      const VerificationMeta('screenHeightLogical');
  @override
  late final GeneratedColumn<double> screenHeightLogical =
      GeneratedColumn<double>(
        'screen_height_logical',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<OwnerFeedback?, String>
  ownerSubjectiveFeedback =
      GeneratedColumn<String>(
        'owner_subjective_feedback',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<OwnerFeedback?>(
        $SessionsTable.$converterownerSubjectiveFeedbackn,
      );
  static const VerificationMeta _catchesMeta = const VerificationMeta(
    'catches',
  );
  @override
  late final GeneratedColumn<int> catches = GeneratedColumn<int>(
    'catches',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _missesMeta = const VerificationMeta('misses');
  @override
  late final GeneratedColumn<int> misses = GeneratedColumn<int>(
    'misses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeoutsMeta = const VerificationMeta(
    'timeouts',
  );
  @override
  late final GeneratedColumn<int> timeouts = GeneratedColumn<int>(
    'timeouts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medianReactionMsMeta = const VerificationMeta(
    'medianReactionMs',
  );
  @override
  late final GeneratedColumn<int> medianReactionMs = GeneratedColumn<int>(
    'median_reaction_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frustrationCountMeta = const VerificationMeta(
    'frustrationCount',
  );
  @override
  late final GeneratedColumn<int> frustrationCount = GeneratedColumn<int>(
    'frustration_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    mode,
    startedAtUtc,
    endedAtUtc,
    plannedDurationSeconds,
    actualDurationMs,
    status,
    calibrationSession,
    randomSeed,
    algorithmVersion,
    appVersion,
    platform,
    screenWidthLogical,
    screenHeightLogical,
    ownerSubjectiveFeedback,
    catches,
    misses,
    timeouts,
    medianReactionMs,
    frustrationCount,
    createdAtUtc,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    }
    if (data.containsKey('started_at_utc')) {
      context.handle(
        _startedAtUtcMeta,
        startedAtUtc.isAcceptableOrUnknown(
          data['started_at_utc']!,
          _startedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMeta);
    }
    if (data.containsKey('ended_at_utc')) {
      context.handle(
        _endedAtUtcMeta,
        endedAtUtc.isAcceptableOrUnknown(
          data['ended_at_utc']!,
          _endedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('planned_duration_seconds')) {
      context.handle(
        _plannedDurationSecondsMeta,
        plannedDurationSeconds.isAcceptableOrUnknown(
          data['planned_duration_seconds']!,
          _plannedDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDurationSecondsMeta);
    }
    if (data.containsKey('actual_duration_ms')) {
      context.handle(
        _actualDurationMsMeta,
        actualDurationMs.isAcceptableOrUnknown(
          data['actual_duration_ms']!,
          _actualDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('calibration_session')) {
      context.handle(
        _calibrationSessionMeta,
        calibrationSession.isAcceptableOrUnknown(
          data['calibration_session']!,
          _calibrationSessionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calibrationSessionMeta);
    }
    if (data.containsKey('random_seed')) {
      context.handle(
        _randomSeedMeta,
        randomSeed.isAcceptableOrUnknown(data['random_seed']!, _randomSeedMeta),
      );
    } else if (isInserting) {
      context.missing(_randomSeedMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
        _algorithmVersionMeta,
        algorithmVersion.isAcceptableOrUnknown(
          data['algorithm_version']!,
          _algorithmVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('screen_width_logical')) {
      context.handle(
        _screenWidthLogicalMeta,
        screenWidthLogical.isAcceptableOrUnknown(
          data['screen_width_logical']!,
          _screenWidthLogicalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_screenWidthLogicalMeta);
    }
    if (data.containsKey('screen_height_logical')) {
      context.handle(
        _screenHeightLogicalMeta,
        screenHeightLogical.isAcceptableOrUnknown(
          data['screen_height_logical']!,
          _screenHeightLogicalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_screenHeightLogicalMeta);
    }
    if (data.containsKey('catches')) {
      context.handle(
        _catchesMeta,
        catches.isAcceptableOrUnknown(data['catches']!, _catchesMeta),
      );
    } else if (isInserting) {
      context.missing(_catchesMeta);
    }
    if (data.containsKey('misses')) {
      context.handle(
        _missesMeta,
        misses.isAcceptableOrUnknown(data['misses']!, _missesMeta),
      );
    } else if (isInserting) {
      context.missing(_missesMeta);
    }
    if (data.containsKey('timeouts')) {
      context.handle(
        _timeoutsMeta,
        timeouts.isAcceptableOrUnknown(data['timeouts']!, _timeoutsMeta),
      );
    } else if (isInserting) {
      context.missing(_timeoutsMeta);
    }
    if (data.containsKey('median_reaction_ms')) {
      context.handle(
        _medianReactionMsMeta,
        medianReactionMs.isAcceptableOrUnknown(
          data['median_reaction_ms']!,
          _medianReactionMsMeta,
        ),
      );
    }
    if (data.containsKey('frustration_count')) {
      context.handle(
        _frustrationCountMeta,
        frustrationCount.isAcceptableOrUnknown(
          data['frustration_count']!,
          _frustrationCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frustrationCountMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_id'],
      ),
      mode: $SessionsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      startedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at_utc'],
      )!,
      endedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at_utc'],
      ),
      plannedDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_seconds'],
      )!,
      actualDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration_ms'],
      ),
      status: $SessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      calibrationSession: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calibration_session'],
      )!,
      randomSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}random_seed'],
      )!,
      algorithmVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm_version'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      screenWidthLogical: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}screen_width_logical'],
      )!,
      screenHeightLogical: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}screen_height_logical'],
      )!,
      ownerSubjectiveFeedback: $SessionsTable.$converterownerSubjectiveFeedbackn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}owner_subjective_feedback'],
            ),
          ),
      catches: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}catches'],
      )!,
      misses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}misses'],
      )!,
      timeouts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timeouts'],
      )!,
      medianReactionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}median_reaction_ms'],
      ),
      frustrationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frustration_count'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SessionMode, String, String> $convertermode =
      const EnumNameConverter<SessionMode>(SessionMode.values);
  static JsonTypeConverter2<SessionStatus, String, String> $converterstatus =
      const EnumNameConverter<SessionStatus>(SessionStatus.values);
  static JsonTypeConverter2<OwnerFeedback, String, String>
  $converterownerSubjectiveFeedback = const EnumNameConverter<OwnerFeedback>(
    OwnerFeedback.values,
  );
  static JsonTypeConverter2<OwnerFeedback?, String?, String?>
  $converterownerSubjectiveFeedbackn = JsonTypeConverter2.asNullable(
    $converterownerSubjectiveFeedback,
  );
}

class Session extends DataClass implements Insertable<Session> {
  final String id;

  /// Null for mixed sessions (no individual cat attribution).
  final String? catId;
  final SessionMode mode;
  final DateTime startedAtUtc;
  final DateTime? endedAtUtc;
  final int plannedDurationSeconds;
  final int? actualDurationMs;
  final SessionStatus status;
  final bool calibrationSession;
  final int randomSeed;
  final String algorithmVersion;
  final String appVersion;
  final String platform;
  final double screenWidthLogical;
  final double screenHeightLogical;
  final OwnerFeedback? ownerSubjectiveFeedback;
  final int catches;
  final int misses;
  final int timeouts;
  final int? medianReactionMs;
  final int frustrationCount;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  const Session({
    required this.id,
    this.catId,
    required this.mode,
    required this.startedAtUtc,
    this.endedAtUtc,
    required this.plannedDurationSeconds,
    this.actualDurationMs,
    required this.status,
    required this.calibrationSession,
    required this.randomSeed,
    required this.algorithmVersion,
    required this.appVersion,
    required this.platform,
    required this.screenWidthLogical,
    required this.screenHeightLogical,
    this.ownerSubjectiveFeedback,
    required this.catches,
    required this.misses,
    required this.timeouts,
    this.medianReactionMs,
    required this.frustrationCount,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || catId != null) {
      map['cat_id'] = Variable<String>(catId);
    }
    {
      map['mode'] = Variable<String>($SessionsTable.$convertermode.toSql(mode));
    }
    map['started_at_utc'] = Variable<DateTime>(startedAtUtc);
    if (!nullToAbsent || endedAtUtc != null) {
      map['ended_at_utc'] = Variable<DateTime>(endedAtUtc);
    }
    map['planned_duration_seconds'] = Variable<int>(plannedDurationSeconds);
    if (!nullToAbsent || actualDurationMs != null) {
      map['actual_duration_ms'] = Variable<int>(actualDurationMs);
    }
    {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status),
      );
    }
    map['calibration_session'] = Variable<bool>(calibrationSession);
    map['random_seed'] = Variable<int>(randomSeed);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    map['app_version'] = Variable<String>(appVersion);
    map['platform'] = Variable<String>(platform);
    map['screen_width_logical'] = Variable<double>(screenWidthLogical);
    map['screen_height_logical'] = Variable<double>(screenHeightLogical);
    if (!nullToAbsent || ownerSubjectiveFeedback != null) {
      map['owner_subjective_feedback'] = Variable<String>(
        $SessionsTable.$converterownerSubjectiveFeedbackn.toSql(
          ownerSubjectiveFeedback,
        ),
      );
    }
    map['catches'] = Variable<int>(catches);
    map['misses'] = Variable<int>(misses);
    map['timeouts'] = Variable<int>(timeouts);
    if (!nullToAbsent || medianReactionMs != null) {
      map['median_reaction_ms'] = Variable<int>(medianReactionMs);
    }
    map['frustration_count'] = Variable<int>(frustrationCount);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      catId: catId == null && nullToAbsent
          ? const Value.absent()
          : Value(catId),
      mode: Value(mode),
      startedAtUtc: Value(startedAtUtc),
      endedAtUtc: endedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtc),
      plannedDurationSeconds: Value(plannedDurationSeconds),
      actualDurationMs: actualDurationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDurationMs),
      status: Value(status),
      calibrationSession: Value(calibrationSession),
      randomSeed: Value(randomSeed),
      algorithmVersion: Value(algorithmVersion),
      appVersion: Value(appVersion),
      platform: Value(platform),
      screenWidthLogical: Value(screenWidthLogical),
      screenHeightLogical: Value(screenHeightLogical),
      ownerSubjectiveFeedback: ownerSubjectiveFeedback == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerSubjectiveFeedback),
      catches: Value(catches),
      misses: Value(misses),
      timeouts: Value(timeouts),
      medianReactionMs: medianReactionMs == null && nullToAbsent
          ? const Value.absent()
          : Value(medianReactionMs),
      frustrationCount: Value(frustrationCount),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      catId: serializer.fromJson<String?>(json['catId']),
      mode: $SessionsTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
      startedAtUtc: serializer.fromJson<DateTime>(json['startedAtUtc']),
      endedAtUtc: serializer.fromJson<DateTime?>(json['endedAtUtc']),
      plannedDurationSeconds: serializer.fromJson<int>(
        json['plannedDurationSeconds'],
      ),
      actualDurationMs: serializer.fromJson<int?>(json['actualDurationMs']),
      status: $SessionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      calibrationSession: serializer.fromJson<bool>(json['calibrationSession']),
      randomSeed: serializer.fromJson<int>(json['randomSeed']),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      platform: serializer.fromJson<String>(json['platform']),
      screenWidthLogical: serializer.fromJson<double>(
        json['screenWidthLogical'],
      ),
      screenHeightLogical: serializer.fromJson<double>(
        json['screenHeightLogical'],
      ),
      ownerSubjectiveFeedback: $SessionsTable.$converterownerSubjectiveFeedbackn
          .fromJson(
            serializer.fromJson<String?>(json['ownerSubjectiveFeedback']),
          ),
      catches: serializer.fromJson<int>(json['catches']),
      misses: serializer.fromJson<int>(json['misses']),
      timeouts: serializer.fromJson<int>(json['timeouts']),
      medianReactionMs: serializer.fromJson<int?>(json['medianReactionMs']),
      frustrationCount: serializer.fromJson<int>(json['frustrationCount']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catId': serializer.toJson<String?>(catId),
      'mode': serializer.toJson<String>(
        $SessionsTable.$convertermode.toJson(mode),
      ),
      'startedAtUtc': serializer.toJson<DateTime>(startedAtUtc),
      'endedAtUtc': serializer.toJson<DateTime?>(endedAtUtc),
      'plannedDurationSeconds': serializer.toJson<int>(plannedDurationSeconds),
      'actualDurationMs': serializer.toJson<int?>(actualDurationMs),
      'status': serializer.toJson<String>(
        $SessionsTable.$converterstatus.toJson(status),
      ),
      'calibrationSession': serializer.toJson<bool>(calibrationSession),
      'randomSeed': serializer.toJson<int>(randomSeed),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
      'appVersion': serializer.toJson<String>(appVersion),
      'platform': serializer.toJson<String>(platform),
      'screenWidthLogical': serializer.toJson<double>(screenWidthLogical),
      'screenHeightLogical': serializer.toJson<double>(screenHeightLogical),
      'ownerSubjectiveFeedback': serializer.toJson<String?>(
        $SessionsTable.$converterownerSubjectiveFeedbackn.toJson(
          ownerSubjectiveFeedback,
        ),
      ),
      'catches': serializer.toJson<int>(catches),
      'misses': serializer.toJson<int>(misses),
      'timeouts': serializer.toJson<int>(timeouts),
      'medianReactionMs': serializer.toJson<int?>(medianReactionMs),
      'frustrationCount': serializer.toJson<int>(frustrationCount),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  Session copyWith({
    String? id,
    Value<String?> catId = const Value.absent(),
    SessionMode? mode,
    DateTime? startedAtUtc,
    Value<DateTime?> endedAtUtc = const Value.absent(),
    int? plannedDurationSeconds,
    Value<int?> actualDurationMs = const Value.absent(),
    SessionStatus? status,
    bool? calibrationSession,
    int? randomSeed,
    String? algorithmVersion,
    String? appVersion,
    String? platform,
    double? screenWidthLogical,
    double? screenHeightLogical,
    Value<OwnerFeedback?> ownerSubjectiveFeedback = const Value.absent(),
    int? catches,
    int? misses,
    int? timeouts,
    Value<int?> medianReactionMs = const Value.absent(),
    int? frustrationCount,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
  }) => Session(
    id: id ?? this.id,
    catId: catId.present ? catId.value : this.catId,
    mode: mode ?? this.mode,
    startedAtUtc: startedAtUtc ?? this.startedAtUtc,
    endedAtUtc: endedAtUtc.present ? endedAtUtc.value : this.endedAtUtc,
    plannedDurationSeconds:
        plannedDurationSeconds ?? this.plannedDurationSeconds,
    actualDurationMs: actualDurationMs.present
        ? actualDurationMs.value
        : this.actualDurationMs,
    status: status ?? this.status,
    calibrationSession: calibrationSession ?? this.calibrationSession,
    randomSeed: randomSeed ?? this.randomSeed,
    algorithmVersion: algorithmVersion ?? this.algorithmVersion,
    appVersion: appVersion ?? this.appVersion,
    platform: platform ?? this.platform,
    screenWidthLogical: screenWidthLogical ?? this.screenWidthLogical,
    screenHeightLogical: screenHeightLogical ?? this.screenHeightLogical,
    ownerSubjectiveFeedback: ownerSubjectiveFeedback.present
        ? ownerSubjectiveFeedback.value
        : this.ownerSubjectiveFeedback,
    catches: catches ?? this.catches,
    misses: misses ?? this.misses,
    timeouts: timeouts ?? this.timeouts,
    medianReactionMs: medianReactionMs.present
        ? medianReactionMs.value
        : this.medianReactionMs,
    frustrationCount: frustrationCount ?? this.frustrationCount,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      mode: data.mode.present ? data.mode.value : this.mode,
      startedAtUtc: data.startedAtUtc.present
          ? data.startedAtUtc.value
          : this.startedAtUtc,
      endedAtUtc: data.endedAtUtc.present
          ? data.endedAtUtc.value
          : this.endedAtUtc,
      plannedDurationSeconds: data.plannedDurationSeconds.present
          ? data.plannedDurationSeconds.value
          : this.plannedDurationSeconds,
      actualDurationMs: data.actualDurationMs.present
          ? data.actualDurationMs.value
          : this.actualDurationMs,
      status: data.status.present ? data.status.value : this.status,
      calibrationSession: data.calibrationSession.present
          ? data.calibrationSession.value
          : this.calibrationSession,
      randomSeed: data.randomSeed.present
          ? data.randomSeed.value
          : this.randomSeed,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      platform: data.platform.present ? data.platform.value : this.platform,
      screenWidthLogical: data.screenWidthLogical.present
          ? data.screenWidthLogical.value
          : this.screenWidthLogical,
      screenHeightLogical: data.screenHeightLogical.present
          ? data.screenHeightLogical.value
          : this.screenHeightLogical,
      ownerSubjectiveFeedback: data.ownerSubjectiveFeedback.present
          ? data.ownerSubjectiveFeedback.value
          : this.ownerSubjectiveFeedback,
      catches: data.catches.present ? data.catches.value : this.catches,
      misses: data.misses.present ? data.misses.value : this.misses,
      timeouts: data.timeouts.present ? data.timeouts.value : this.timeouts,
      medianReactionMs: data.medianReactionMs.present
          ? data.medianReactionMs.value
          : this.medianReactionMs,
      frustrationCount: data.frustrationCount.present
          ? data.frustrationCount.value
          : this.frustrationCount,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('mode: $mode, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('plannedDurationSeconds: $plannedDurationSeconds, ')
          ..write('actualDurationMs: $actualDurationMs, ')
          ..write('status: $status, ')
          ..write('calibrationSession: $calibrationSession, ')
          ..write('randomSeed: $randomSeed, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('appVersion: $appVersion, ')
          ..write('platform: $platform, ')
          ..write('screenWidthLogical: $screenWidthLogical, ')
          ..write('screenHeightLogical: $screenHeightLogical, ')
          ..write('ownerSubjectiveFeedback: $ownerSubjectiveFeedback, ')
          ..write('catches: $catches, ')
          ..write('misses: $misses, ')
          ..write('timeouts: $timeouts, ')
          ..write('medianReactionMs: $medianReactionMs, ')
          ..write('frustrationCount: $frustrationCount, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    catId,
    mode,
    startedAtUtc,
    endedAtUtc,
    plannedDurationSeconds,
    actualDurationMs,
    status,
    calibrationSession,
    randomSeed,
    algorithmVersion,
    appVersion,
    platform,
    screenWidthLogical,
    screenHeightLogical,
    ownerSubjectiveFeedback,
    catches,
    misses,
    timeouts,
    medianReactionMs,
    frustrationCount,
    createdAtUtc,
    updatedAtUtc,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.mode == this.mode &&
          other.startedAtUtc == this.startedAtUtc &&
          other.endedAtUtc == this.endedAtUtc &&
          other.plannedDurationSeconds == this.plannedDurationSeconds &&
          other.actualDurationMs == this.actualDurationMs &&
          other.status == this.status &&
          other.calibrationSession == this.calibrationSession &&
          other.randomSeed == this.randomSeed &&
          other.algorithmVersion == this.algorithmVersion &&
          other.appVersion == this.appVersion &&
          other.platform == this.platform &&
          other.screenWidthLogical == this.screenWidthLogical &&
          other.screenHeightLogical == this.screenHeightLogical &&
          other.ownerSubjectiveFeedback == this.ownerSubjectiveFeedback &&
          other.catches == this.catches &&
          other.misses == this.misses &&
          other.timeouts == this.timeouts &&
          other.medianReactionMs == this.medianReactionMs &&
          other.frustrationCount == this.frustrationCount &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String?> catId;
  final Value<SessionMode> mode;
  final Value<DateTime> startedAtUtc;
  final Value<DateTime?> endedAtUtc;
  final Value<int> plannedDurationSeconds;
  final Value<int?> actualDurationMs;
  final Value<SessionStatus> status;
  final Value<bool> calibrationSession;
  final Value<int> randomSeed;
  final Value<String> algorithmVersion;
  final Value<String> appVersion;
  final Value<String> platform;
  final Value<double> screenWidthLogical;
  final Value<double> screenHeightLogical;
  final Value<OwnerFeedback?> ownerSubjectiveFeedback;
  final Value<int> catches;
  final Value<int> misses;
  final Value<int> timeouts;
  final Value<int?> medianReactionMs;
  final Value<int> frustrationCount;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.mode = const Value.absent(),
    this.startedAtUtc = const Value.absent(),
    this.endedAtUtc = const Value.absent(),
    this.plannedDurationSeconds = const Value.absent(),
    this.actualDurationMs = const Value.absent(),
    this.status = const Value.absent(),
    this.calibrationSession = const Value.absent(),
    this.randomSeed = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.platform = const Value.absent(),
    this.screenWidthLogical = const Value.absent(),
    this.screenHeightLogical = const Value.absent(),
    this.ownerSubjectiveFeedback = const Value.absent(),
    this.catches = const Value.absent(),
    this.misses = const Value.absent(),
    this.timeouts = const Value.absent(),
    this.medianReactionMs = const Value.absent(),
    this.frustrationCount = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    this.catId = const Value.absent(),
    required SessionMode mode,
    required DateTime startedAtUtc,
    this.endedAtUtc = const Value.absent(),
    required int plannedDurationSeconds,
    this.actualDurationMs = const Value.absent(),
    required SessionStatus status,
    required bool calibrationSession,
    required int randomSeed,
    required String algorithmVersion,
    required String appVersion,
    required String platform,
    required double screenWidthLogical,
    required double screenHeightLogical,
    this.ownerSubjectiveFeedback = const Value.absent(),
    required int catches,
    required int misses,
    required int timeouts,
    this.medianReactionMs = const Value.absent(),
    required int frustrationCount,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       startedAtUtc = Value(startedAtUtc),
       plannedDurationSeconds = Value(plannedDurationSeconds),
       status = Value(status),
       calibrationSession = Value(calibrationSession),
       randomSeed = Value(randomSeed),
       algorithmVersion = Value(algorithmVersion),
       appVersion = Value(appVersion),
       platform = Value(platform),
       screenWidthLogical = Value(screenWidthLogical),
       screenHeightLogical = Value(screenHeightLogical),
       catches = Value(catches),
       misses = Value(misses),
       timeouts = Value(timeouts),
       frustrationCount = Value(frustrationCount),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? catId,
    Expression<String>? mode,
    Expression<DateTime>? startedAtUtc,
    Expression<DateTime>? endedAtUtc,
    Expression<int>? plannedDurationSeconds,
    Expression<int>? actualDurationMs,
    Expression<String>? status,
    Expression<bool>? calibrationSession,
    Expression<int>? randomSeed,
    Expression<String>? algorithmVersion,
    Expression<String>? appVersion,
    Expression<String>? platform,
    Expression<double>? screenWidthLogical,
    Expression<double>? screenHeightLogical,
    Expression<String>? ownerSubjectiveFeedback,
    Expression<int>? catches,
    Expression<int>? misses,
    Expression<int>? timeouts,
    Expression<int>? medianReactionMs,
    Expression<int>? frustrationCount,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (mode != null) 'mode': mode,
      if (startedAtUtc != null) 'started_at_utc': startedAtUtc,
      if (endedAtUtc != null) 'ended_at_utc': endedAtUtc,
      if (plannedDurationSeconds != null)
        'planned_duration_seconds': plannedDurationSeconds,
      if (actualDurationMs != null) 'actual_duration_ms': actualDurationMs,
      if (status != null) 'status': status,
      if (calibrationSession != null) 'calibration_session': calibrationSession,
      if (randomSeed != null) 'random_seed': randomSeed,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (appVersion != null) 'app_version': appVersion,
      if (platform != null) 'platform': platform,
      if (screenWidthLogical != null)
        'screen_width_logical': screenWidthLogical,
      if (screenHeightLogical != null)
        'screen_height_logical': screenHeightLogical,
      if (ownerSubjectiveFeedback != null)
        'owner_subjective_feedback': ownerSubjectiveFeedback,
      if (catches != null) 'catches': catches,
      if (misses != null) 'misses': misses,
      if (timeouts != null) 'timeouts': timeouts,
      if (medianReactionMs != null) 'median_reaction_ms': medianReactionMs,
      if (frustrationCount != null) 'frustration_count': frustrationCount,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? catId,
    Value<SessionMode>? mode,
    Value<DateTime>? startedAtUtc,
    Value<DateTime?>? endedAtUtc,
    Value<int>? plannedDurationSeconds,
    Value<int?>? actualDurationMs,
    Value<SessionStatus>? status,
    Value<bool>? calibrationSession,
    Value<int>? randomSeed,
    Value<String>? algorithmVersion,
    Value<String>? appVersion,
    Value<String>? platform,
    Value<double>? screenWidthLogical,
    Value<double>? screenHeightLogical,
    Value<OwnerFeedback?>? ownerSubjectiveFeedback,
    Value<int>? catches,
    Value<int>? misses,
    Value<int>? timeouts,
    Value<int?>? medianReactionMs,
    Value<int>? frustrationCount,
    Value<DateTime>? createdAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      mode: mode ?? this.mode,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      endedAtUtc: endedAtUtc ?? this.endedAtUtc,
      plannedDurationSeconds:
          plannedDurationSeconds ?? this.plannedDurationSeconds,
      actualDurationMs: actualDurationMs ?? this.actualDurationMs,
      status: status ?? this.status,
      calibrationSession: calibrationSession ?? this.calibrationSession,
      randomSeed: randomSeed ?? this.randomSeed,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      appVersion: appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      screenWidthLogical: screenWidthLogical ?? this.screenWidthLogical,
      screenHeightLogical: screenHeightLogical ?? this.screenHeightLogical,
      ownerSubjectiveFeedback:
          ownerSubjectiveFeedback ?? this.ownerSubjectiveFeedback,
      catches: catches ?? this.catches,
      misses: misses ?? this.misses,
      timeouts: timeouts ?? this.timeouts,
      medianReactionMs: medianReactionMs ?? this.medianReactionMs,
      frustrationCount: frustrationCount ?? this.frustrationCount,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $SessionsTable.$convertermode.toSql(mode.value),
      );
    }
    if (startedAtUtc.present) {
      map['started_at_utc'] = Variable<DateTime>(startedAtUtc.value);
    }
    if (endedAtUtc.present) {
      map['ended_at_utc'] = Variable<DateTime>(endedAtUtc.value);
    }
    if (plannedDurationSeconds.present) {
      map['planned_duration_seconds'] = Variable<int>(
        plannedDurationSeconds.value,
      );
    }
    if (actualDurationMs.present) {
      map['actual_duration_ms'] = Variable<int>(actualDurationMs.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (calibrationSession.present) {
      map['calibration_session'] = Variable<bool>(calibrationSession.value);
    }
    if (randomSeed.present) {
      map['random_seed'] = Variable<int>(randomSeed.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (screenWidthLogical.present) {
      map['screen_width_logical'] = Variable<double>(screenWidthLogical.value);
    }
    if (screenHeightLogical.present) {
      map['screen_height_logical'] = Variable<double>(
        screenHeightLogical.value,
      );
    }
    if (ownerSubjectiveFeedback.present) {
      map['owner_subjective_feedback'] = Variable<String>(
        $SessionsTable.$converterownerSubjectiveFeedbackn.toSql(
          ownerSubjectiveFeedback.value,
        ),
      );
    }
    if (catches.present) {
      map['catches'] = Variable<int>(catches.value);
    }
    if (misses.present) {
      map['misses'] = Variable<int>(misses.value);
    }
    if (timeouts.present) {
      map['timeouts'] = Variable<int>(timeouts.value);
    }
    if (medianReactionMs.present) {
      map['median_reaction_ms'] = Variable<int>(medianReactionMs.value);
    }
    if (frustrationCount.present) {
      map['frustration_count'] = Variable<int>(frustrationCount.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('mode: $mode, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('plannedDurationSeconds: $plannedDurationSeconds, ')
          ..write('actualDurationMs: $actualDurationMs, ')
          ..write('status: $status, ')
          ..write('calibrationSession: $calibrationSession, ')
          ..write('randomSeed: $randomSeed, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('appVersion: $appVersion, ')
          ..write('platform: $platform, ')
          ..write('screenWidthLogical: $screenWidthLogical, ')
          ..write('screenHeightLogical: $screenHeightLogical, ')
          ..write('ownerSubjectiveFeedback: $ownerSubjectiveFeedback, ')
          ..write('catches: $catches, ')
          ..write('misses: $misses, ')
          ..write('timeouts: $timeouts, ')
          ..write('medianReactionMs: $medianReactionMs, ')
          ..write('frustrationCount: $frustrationCount, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TargetTrialsTable extends TargetTrials
    with TableInfo<$TargetTrialsTable, TargetTrial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetTrialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trialIndexMeta = const VerificationMeta(
    'trialIndex',
  );
  @override
  late final GeneratedColumn<int> trialIndex = GeneratedColumn<int>(
    'trial_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PreyType, String> targetType =
      GeneratedColumn<String>(
        'target_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PreyType>($TargetTrialsTable.$convertertargetType);
  @override
  late final GeneratedColumnWithTypeConverter<MovementStyle, String>
  movementStyle = GeneratedColumn<String>(
    'movement_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MovementStyle>($TargetTrialsTable.$convertermovementStyle);
  @override
  late final GeneratedColumnWithTypeConverter<SpeedLevel, String> speedLevel =
      GeneratedColumn<String>(
        'speed_level',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpeedLevel>($TargetTrialsTable.$converterspeedLevel);
  @override
  late final GeneratedColumnWithTypeConverter<SizeLevel, String> sizeLevel =
      GeneratedColumn<String>(
        'size_level',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SizeLevel>($TargetTrialsTable.$convertersizeLevel);
  @override
  late final GeneratedColumnWithTypeConverter<SoundMode, String> soundMode =
      GeneratedColumn<String>(
        'sound_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SoundMode>($TargetTrialsTable.$convertersoundMode);
  @override
  late final GeneratedColumnWithTypeConverter<SpawnZone, String> spawnZone =
      GeneratedColumn<String>(
        'spawn_zone',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpawnZone>($TargetTrialsTable.$converterspawnZone);
  static const VerificationMeta _spawnedAtUtcMeta = const VerificationMeta(
    'spawnedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> spawnedAtUtc = GeneratedColumn<DateTime>(
    'spawned_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _becameTouchableAtUtcMeta =
      const VerificationMeta('becameTouchableAtUtc');
  @override
  late final GeneratedColumn<DateTime> becameTouchableAtUtc =
      GeneratedColumn<DateTime>(
        'became_touchable_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _endedAtUtcMeta = const VerificationMeta(
    'endedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> endedAtUtc = GeneratedColumn<DateTime>(
    'ended_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spawnXNormalisedMeta = const VerificationMeta(
    'spawnXNormalised',
  );
  @override
  late final GeneratedColumn<double> spawnXNormalised = GeneratedColumn<double>(
    'spawn_x_normalised',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spawnYNormalisedMeta = const VerificationMeta(
    'spawnYNormalised',
  );
  @override
  late final GeneratedColumn<double> spawnYNormalised = GeneratedColumn<double>(
    'spawn_y_normalised',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPathSeedMeta = const VerificationMeta(
    'targetPathSeed',
  );
  @override
  late final GeneratedColumn<int> targetPathSeed = GeneratedColumn<int>(
    'target_path_seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  static const VerificationMeta _firstSuccessfulTouchAtUtcMeta =
      const VerificationMeta('firstSuccessfulTouchAtUtc');
  @override
  late final GeneratedColumn<DateTime> firstSuccessfulTouchAtUtc =
      GeneratedColumn<DateTime>(
        'first_successful_touch_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reactionTimeMsMeta = const VerificationMeta(
    'reactionTimeMs',
  );
  @override
  late final GeneratedColumn<int> reactionTimeMs = GeneratedColumn<int>(
    'reaction_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missCountMeta = const VerificationMeta(
    'missCount',
  );
  @override
  late final GeneratedColumn<int> missCount = GeneratedColumn<int>(
    'miss_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeoutMeta = const VerificationMeta(
    'timeout',
  );
  @override
  late final GeneratedColumn<bool> timeout = GeneratedColumn<bool>(
    'timeout',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("timeout" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CueType?, String> cueType =
      GeneratedColumn<String>(
        'cue_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<CueType?>($TargetTrialsTable.$convertercueTypen);
  @override
  late final GeneratedColumnWithTypeConverter<CueType?, String> praiseCueType =
      GeneratedColumn<String>(
        'praise_cue_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<CueType?>($TargetTrialsTable.$converterpraiseCueTypen);
  static const VerificationMeta _rewardReminderShownMeta =
      const VerificationMeta('rewardReminderShown');
  @override
  late final GeneratedColumn<bool> rewardReminderShown = GeneratedColumn<bool>(
    'reward_reminder_shown',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reward_reminder_shown" IN (0, 1))',
    ),
  );
  static const VerificationMeta _frustrationSeverityMeta =
      const VerificationMeta('frustrationSeverity');
  @override
  late final GeneratedColumn<int> frustrationSeverity = GeneratedColumn<int>(
    'frustration_severity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Set<FrustrationFlag>, String>
  frustrationFlags =
      GeneratedColumn<String>(
        'frustration_flags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Set<FrustrationFlag>>(
        $TargetTrialsTable.$converterfrustrationFlags,
      );
  static const VerificationMeta _trialRewardMeta = const VerificationMeta(
    'trialReward',
  );
  @override
  late final GeneratedColumn<double> trialReward = GeneratedColumn<double>(
    'trial_reward',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _algorithmVersionMeta = const VerificationMeta(
    'algorithmVersion',
  );
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
    'algorithm_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    trialIndex,
    targetType,
    movementStyle,
    speedLevel,
    sizeLevel,
    soundMode,
    spawnZone,
    spawnedAtUtc,
    becameTouchableAtUtc,
    endedAtUtc,
    spawnXNormalised,
    spawnYNormalised,
    targetPathSeed,
    success,
    firstSuccessfulTouchAtUtc,
    reactionTimeMs,
    missCount,
    timeout,
    cueType,
    praiseCueType,
    rewardReminderShown,
    frustrationSeverity,
    frustrationFlags,
    trialReward,
    algorithmVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'target_trials';
  @override
  VerificationContext validateIntegrity(
    Insertable<TargetTrial> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('trial_index')) {
      context.handle(
        _trialIndexMeta,
        trialIndex.isAcceptableOrUnknown(data['trial_index']!, _trialIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_trialIndexMeta);
    }
    if (data.containsKey('spawned_at_utc')) {
      context.handle(
        _spawnedAtUtcMeta,
        spawnedAtUtc.isAcceptableOrUnknown(
          data['spawned_at_utc']!,
          _spawnedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spawnedAtUtcMeta);
    }
    if (data.containsKey('became_touchable_at_utc')) {
      context.handle(
        _becameTouchableAtUtcMeta,
        becameTouchableAtUtc.isAcceptableOrUnknown(
          data['became_touchable_at_utc']!,
          _becameTouchableAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_becameTouchableAtUtcMeta);
    }
    if (data.containsKey('ended_at_utc')) {
      context.handle(
        _endedAtUtcMeta,
        endedAtUtc.isAcceptableOrUnknown(
          data['ended_at_utc']!,
          _endedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('spawn_x_normalised')) {
      context.handle(
        _spawnXNormalisedMeta,
        spawnXNormalised.isAcceptableOrUnknown(
          data['spawn_x_normalised']!,
          _spawnXNormalisedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spawnXNormalisedMeta);
    }
    if (data.containsKey('spawn_y_normalised')) {
      context.handle(
        _spawnYNormalisedMeta,
        spawnYNormalised.isAcceptableOrUnknown(
          data['spawn_y_normalised']!,
          _spawnYNormalisedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spawnYNormalisedMeta);
    }
    if (data.containsKey('target_path_seed')) {
      context.handle(
        _targetPathSeedMeta,
        targetPathSeed.isAcceptableOrUnknown(
          data['target_path_seed']!,
          _targetPathSeedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPathSeedMeta);
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('first_successful_touch_at_utc')) {
      context.handle(
        _firstSuccessfulTouchAtUtcMeta,
        firstSuccessfulTouchAtUtc.isAcceptableOrUnknown(
          data['first_successful_touch_at_utc']!,
          _firstSuccessfulTouchAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('reaction_time_ms')) {
      context.handle(
        _reactionTimeMsMeta,
        reactionTimeMs.isAcceptableOrUnknown(
          data['reaction_time_ms']!,
          _reactionTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('miss_count')) {
      context.handle(
        _missCountMeta,
        missCount.isAcceptableOrUnknown(data['miss_count']!, _missCountMeta),
      );
    } else if (isInserting) {
      context.missing(_missCountMeta);
    }
    if (data.containsKey('timeout')) {
      context.handle(
        _timeoutMeta,
        timeout.isAcceptableOrUnknown(data['timeout']!, _timeoutMeta),
      );
    } else if (isInserting) {
      context.missing(_timeoutMeta);
    }
    if (data.containsKey('reward_reminder_shown')) {
      context.handle(
        _rewardReminderShownMeta,
        rewardReminderShown.isAcceptableOrUnknown(
          data['reward_reminder_shown']!,
          _rewardReminderShownMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardReminderShownMeta);
    }
    if (data.containsKey('frustration_severity')) {
      context.handle(
        _frustrationSeverityMeta,
        frustrationSeverity.isAcceptableOrUnknown(
          data['frustration_severity']!,
          _frustrationSeverityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frustrationSeverityMeta);
    }
    if (data.containsKey('trial_reward')) {
      context.handle(
        _trialRewardMeta,
        trialReward.isAcceptableOrUnknown(
          data['trial_reward']!,
          _trialRewardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trialRewardMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
        _algorithmVersionMeta,
        algorithmVersion.isAcceptableOrUnknown(
          data['algorithm_version']!,
          _algorithmVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TargetTrial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TargetTrial(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      trialIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trial_index'],
      )!,
      targetType: $TargetTrialsTable.$convertertargetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_type'],
        )!,
      ),
      movementStyle: $TargetTrialsTable.$convertermovementStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}movement_style'],
        )!,
      ),
      speedLevel: $TargetTrialsTable.$converterspeedLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}speed_level'],
        )!,
      ),
      sizeLevel: $TargetTrialsTable.$convertersizeLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}size_level'],
        )!,
      ),
      soundMode: $TargetTrialsTable.$convertersoundMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sound_mode'],
        )!,
      ),
      spawnZone: $TargetTrialsTable.$converterspawnZone.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}spawn_zone'],
        )!,
      ),
      spawnedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spawned_at_utc'],
      )!,
      becameTouchableAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}became_touchable_at_utc'],
      )!,
      endedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at_utc'],
      ),
      spawnXNormalised: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spawn_x_normalised'],
      )!,
      spawnYNormalised: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spawn_y_normalised'],
      )!,
      targetPathSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_path_seed'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      firstSuccessfulTouchAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_successful_touch_at_utc'],
      ),
      reactionTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reaction_time_ms'],
      ),
      missCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}miss_count'],
      )!,
      timeout: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}timeout'],
      )!,
      cueType: $TargetTrialsTable.$convertercueTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cue_type'],
        ),
      ),
      praiseCueType: $TargetTrialsTable.$converterpraiseCueTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}praise_cue_type'],
        ),
      ),
      rewardReminderShown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reward_reminder_shown'],
      )!,
      frustrationSeverity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frustration_severity'],
      )!,
      frustrationFlags: $TargetTrialsTable.$converterfrustrationFlags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frustration_flags'],
        )!,
      ),
      trialReward: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}trial_reward'],
      )!,
      algorithmVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm_version'],
      )!,
    );
  }

  @override
  $TargetTrialsTable createAlias(String alias) {
    return $TargetTrialsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PreyType, String, String> $convertertargetType =
      const EnumNameConverter<PreyType>(PreyType.values);
  static JsonTypeConverter2<MovementStyle, String, String>
  $convertermovementStyle = const EnumNameConverter<MovementStyle>(
    MovementStyle.values,
  );
  static JsonTypeConverter2<SpeedLevel, String, String> $converterspeedLevel =
      const EnumNameConverter<SpeedLevel>(SpeedLevel.values);
  static JsonTypeConverter2<SizeLevel, String, String> $convertersizeLevel =
      const EnumNameConverter<SizeLevel>(SizeLevel.values);
  static JsonTypeConverter2<SoundMode, String, String> $convertersoundMode =
      const EnumNameConverter<SoundMode>(SoundMode.values);
  static JsonTypeConverter2<SpawnZone, String, String> $converterspawnZone =
      const EnumNameConverter<SpawnZone>(SpawnZone.values);
  static JsonTypeConverter2<CueType, String, String> $convertercueType =
      const EnumNameConverter<CueType>(CueType.values);
  static JsonTypeConverter2<CueType?, String?, String?> $convertercueTypen =
      JsonTypeConverter2.asNullable($convertercueType);
  static JsonTypeConverter2<CueType, String, String> $converterpraiseCueType =
      const EnumNameConverter<CueType>(CueType.values);
  static JsonTypeConverter2<CueType?, String?, String?>
  $converterpraiseCueTypen = JsonTypeConverter2.asNullable(
    $converterpraiseCueType,
  );
  static TypeConverter<Set<FrustrationFlag>, String>
  $converterfrustrationFlags = const FrustrationFlagSetConverter();
}

class TargetTrial extends DataClass implements Insertable<TargetTrial> {
  final String id;
  final String sessionId;
  final int trialIndex;
  final PreyType targetType;
  final MovementStyle movementStyle;
  final SpeedLevel speedLevel;
  final SizeLevel sizeLevel;
  final SoundMode soundMode;
  final SpawnZone spawnZone;
  final DateTime spawnedAtUtc;
  final DateTime becameTouchableAtUtc;
  final DateTime? endedAtUtc;
  final double spawnXNormalised;
  final double spawnYNormalised;
  final int targetPathSeed;
  final bool success;
  final DateTime? firstSuccessfulTouchAtUtc;
  final int? reactionTimeMs;
  final int missCount;
  final bool timeout;
  final CueType? cueType;
  final CueType? praiseCueType;
  final bool rewardReminderShown;

  /// 0 none, 1 mild, 2 repeated, 3 high.
  final int frustrationSeverity;
  final Set<FrustrationFlag> frustrationFlags;
  final double trialReward;
  final String algorithmVersion;
  const TargetTrial({
    required this.id,
    required this.sessionId,
    required this.trialIndex,
    required this.targetType,
    required this.movementStyle,
    required this.speedLevel,
    required this.sizeLevel,
    required this.soundMode,
    required this.spawnZone,
    required this.spawnedAtUtc,
    required this.becameTouchableAtUtc,
    this.endedAtUtc,
    required this.spawnXNormalised,
    required this.spawnYNormalised,
    required this.targetPathSeed,
    required this.success,
    this.firstSuccessfulTouchAtUtc,
    this.reactionTimeMs,
    required this.missCount,
    required this.timeout,
    this.cueType,
    this.praiseCueType,
    required this.rewardReminderShown,
    required this.frustrationSeverity,
    required this.frustrationFlags,
    required this.trialReward,
    required this.algorithmVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['trial_index'] = Variable<int>(trialIndex);
    {
      map['target_type'] = Variable<String>(
        $TargetTrialsTable.$convertertargetType.toSql(targetType),
      );
    }
    {
      map['movement_style'] = Variable<String>(
        $TargetTrialsTable.$convertermovementStyle.toSql(movementStyle),
      );
    }
    {
      map['speed_level'] = Variable<String>(
        $TargetTrialsTable.$converterspeedLevel.toSql(speedLevel),
      );
    }
    {
      map['size_level'] = Variable<String>(
        $TargetTrialsTable.$convertersizeLevel.toSql(sizeLevel),
      );
    }
    {
      map['sound_mode'] = Variable<String>(
        $TargetTrialsTable.$convertersoundMode.toSql(soundMode),
      );
    }
    {
      map['spawn_zone'] = Variable<String>(
        $TargetTrialsTable.$converterspawnZone.toSql(spawnZone),
      );
    }
    map['spawned_at_utc'] = Variable<DateTime>(spawnedAtUtc);
    map['became_touchable_at_utc'] = Variable<DateTime>(becameTouchableAtUtc);
    if (!nullToAbsent || endedAtUtc != null) {
      map['ended_at_utc'] = Variable<DateTime>(endedAtUtc);
    }
    map['spawn_x_normalised'] = Variable<double>(spawnXNormalised);
    map['spawn_y_normalised'] = Variable<double>(spawnYNormalised);
    map['target_path_seed'] = Variable<int>(targetPathSeed);
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || firstSuccessfulTouchAtUtc != null) {
      map['first_successful_touch_at_utc'] = Variable<DateTime>(
        firstSuccessfulTouchAtUtc,
      );
    }
    if (!nullToAbsent || reactionTimeMs != null) {
      map['reaction_time_ms'] = Variable<int>(reactionTimeMs);
    }
    map['miss_count'] = Variable<int>(missCount);
    map['timeout'] = Variable<bool>(timeout);
    if (!nullToAbsent || cueType != null) {
      map['cue_type'] = Variable<String>(
        $TargetTrialsTable.$convertercueTypen.toSql(cueType),
      );
    }
    if (!nullToAbsent || praiseCueType != null) {
      map['praise_cue_type'] = Variable<String>(
        $TargetTrialsTable.$converterpraiseCueTypen.toSql(praiseCueType),
      );
    }
    map['reward_reminder_shown'] = Variable<bool>(rewardReminderShown);
    map['frustration_severity'] = Variable<int>(frustrationSeverity);
    {
      map['frustration_flags'] = Variable<String>(
        $TargetTrialsTable.$converterfrustrationFlags.toSql(frustrationFlags),
      );
    }
    map['trial_reward'] = Variable<double>(trialReward);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    return map;
  }

  TargetTrialsCompanion toCompanion(bool nullToAbsent) {
    return TargetTrialsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      trialIndex: Value(trialIndex),
      targetType: Value(targetType),
      movementStyle: Value(movementStyle),
      speedLevel: Value(speedLevel),
      sizeLevel: Value(sizeLevel),
      soundMode: Value(soundMode),
      spawnZone: Value(spawnZone),
      spawnedAtUtc: Value(spawnedAtUtc),
      becameTouchableAtUtc: Value(becameTouchableAtUtc),
      endedAtUtc: endedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtc),
      spawnXNormalised: Value(spawnXNormalised),
      spawnYNormalised: Value(spawnYNormalised),
      targetPathSeed: Value(targetPathSeed),
      success: Value(success),
      firstSuccessfulTouchAtUtc:
          firstSuccessfulTouchAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(firstSuccessfulTouchAtUtc),
      reactionTimeMs: reactionTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionTimeMs),
      missCount: Value(missCount),
      timeout: Value(timeout),
      cueType: cueType == null && nullToAbsent
          ? const Value.absent()
          : Value(cueType),
      praiseCueType: praiseCueType == null && nullToAbsent
          ? const Value.absent()
          : Value(praiseCueType),
      rewardReminderShown: Value(rewardReminderShown),
      frustrationSeverity: Value(frustrationSeverity),
      frustrationFlags: Value(frustrationFlags),
      trialReward: Value(trialReward),
      algorithmVersion: Value(algorithmVersion),
    );
  }

  factory TargetTrial.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TargetTrial(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      trialIndex: serializer.fromJson<int>(json['trialIndex']),
      targetType: $TargetTrialsTable.$convertertargetType.fromJson(
        serializer.fromJson<String>(json['targetType']),
      ),
      movementStyle: $TargetTrialsTable.$convertermovementStyle.fromJson(
        serializer.fromJson<String>(json['movementStyle']),
      ),
      speedLevel: $TargetTrialsTable.$converterspeedLevel.fromJson(
        serializer.fromJson<String>(json['speedLevel']),
      ),
      sizeLevel: $TargetTrialsTable.$convertersizeLevel.fromJson(
        serializer.fromJson<String>(json['sizeLevel']),
      ),
      soundMode: $TargetTrialsTable.$convertersoundMode.fromJson(
        serializer.fromJson<String>(json['soundMode']),
      ),
      spawnZone: $TargetTrialsTable.$converterspawnZone.fromJson(
        serializer.fromJson<String>(json['spawnZone']),
      ),
      spawnedAtUtc: serializer.fromJson<DateTime>(json['spawnedAtUtc']),
      becameTouchableAtUtc: serializer.fromJson<DateTime>(
        json['becameTouchableAtUtc'],
      ),
      endedAtUtc: serializer.fromJson<DateTime?>(json['endedAtUtc']),
      spawnXNormalised: serializer.fromJson<double>(json['spawnXNormalised']),
      spawnYNormalised: serializer.fromJson<double>(json['spawnYNormalised']),
      targetPathSeed: serializer.fromJson<int>(json['targetPathSeed']),
      success: serializer.fromJson<bool>(json['success']),
      firstSuccessfulTouchAtUtc: serializer.fromJson<DateTime?>(
        json['firstSuccessfulTouchAtUtc'],
      ),
      reactionTimeMs: serializer.fromJson<int?>(json['reactionTimeMs']),
      missCount: serializer.fromJson<int>(json['missCount']),
      timeout: serializer.fromJson<bool>(json['timeout']),
      cueType: $TargetTrialsTable.$convertercueTypen.fromJson(
        serializer.fromJson<String?>(json['cueType']),
      ),
      praiseCueType: $TargetTrialsTable.$converterpraiseCueTypen.fromJson(
        serializer.fromJson<String?>(json['praiseCueType']),
      ),
      rewardReminderShown: serializer.fromJson<bool>(
        json['rewardReminderShown'],
      ),
      frustrationSeverity: serializer.fromJson<int>(
        json['frustrationSeverity'],
      ),
      frustrationFlags: serializer.fromJson<Set<FrustrationFlag>>(
        json['frustrationFlags'],
      ),
      trialReward: serializer.fromJson<double>(json['trialReward']),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'trialIndex': serializer.toJson<int>(trialIndex),
      'targetType': serializer.toJson<String>(
        $TargetTrialsTable.$convertertargetType.toJson(targetType),
      ),
      'movementStyle': serializer.toJson<String>(
        $TargetTrialsTable.$convertermovementStyle.toJson(movementStyle),
      ),
      'speedLevel': serializer.toJson<String>(
        $TargetTrialsTable.$converterspeedLevel.toJson(speedLevel),
      ),
      'sizeLevel': serializer.toJson<String>(
        $TargetTrialsTable.$convertersizeLevel.toJson(sizeLevel),
      ),
      'soundMode': serializer.toJson<String>(
        $TargetTrialsTable.$convertersoundMode.toJson(soundMode),
      ),
      'spawnZone': serializer.toJson<String>(
        $TargetTrialsTable.$converterspawnZone.toJson(spawnZone),
      ),
      'spawnedAtUtc': serializer.toJson<DateTime>(spawnedAtUtc),
      'becameTouchableAtUtc': serializer.toJson<DateTime>(becameTouchableAtUtc),
      'endedAtUtc': serializer.toJson<DateTime?>(endedAtUtc),
      'spawnXNormalised': serializer.toJson<double>(spawnXNormalised),
      'spawnYNormalised': serializer.toJson<double>(spawnYNormalised),
      'targetPathSeed': serializer.toJson<int>(targetPathSeed),
      'success': serializer.toJson<bool>(success),
      'firstSuccessfulTouchAtUtc': serializer.toJson<DateTime?>(
        firstSuccessfulTouchAtUtc,
      ),
      'reactionTimeMs': serializer.toJson<int?>(reactionTimeMs),
      'missCount': serializer.toJson<int>(missCount),
      'timeout': serializer.toJson<bool>(timeout),
      'cueType': serializer.toJson<String?>(
        $TargetTrialsTable.$convertercueTypen.toJson(cueType),
      ),
      'praiseCueType': serializer.toJson<String?>(
        $TargetTrialsTable.$converterpraiseCueTypen.toJson(praiseCueType),
      ),
      'rewardReminderShown': serializer.toJson<bool>(rewardReminderShown),
      'frustrationSeverity': serializer.toJson<int>(frustrationSeverity),
      'frustrationFlags': serializer.toJson<Set<FrustrationFlag>>(
        frustrationFlags,
      ),
      'trialReward': serializer.toJson<double>(trialReward),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
    };
  }

  TargetTrial copyWith({
    String? id,
    String? sessionId,
    int? trialIndex,
    PreyType? targetType,
    MovementStyle? movementStyle,
    SpeedLevel? speedLevel,
    SizeLevel? sizeLevel,
    SoundMode? soundMode,
    SpawnZone? spawnZone,
    DateTime? spawnedAtUtc,
    DateTime? becameTouchableAtUtc,
    Value<DateTime?> endedAtUtc = const Value.absent(),
    double? spawnXNormalised,
    double? spawnYNormalised,
    int? targetPathSeed,
    bool? success,
    Value<DateTime?> firstSuccessfulTouchAtUtc = const Value.absent(),
    Value<int?> reactionTimeMs = const Value.absent(),
    int? missCount,
    bool? timeout,
    Value<CueType?> cueType = const Value.absent(),
    Value<CueType?> praiseCueType = const Value.absent(),
    bool? rewardReminderShown,
    int? frustrationSeverity,
    Set<FrustrationFlag>? frustrationFlags,
    double? trialReward,
    String? algorithmVersion,
  }) => TargetTrial(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    trialIndex: trialIndex ?? this.trialIndex,
    targetType: targetType ?? this.targetType,
    movementStyle: movementStyle ?? this.movementStyle,
    speedLevel: speedLevel ?? this.speedLevel,
    sizeLevel: sizeLevel ?? this.sizeLevel,
    soundMode: soundMode ?? this.soundMode,
    spawnZone: spawnZone ?? this.spawnZone,
    spawnedAtUtc: spawnedAtUtc ?? this.spawnedAtUtc,
    becameTouchableAtUtc: becameTouchableAtUtc ?? this.becameTouchableAtUtc,
    endedAtUtc: endedAtUtc.present ? endedAtUtc.value : this.endedAtUtc,
    spawnXNormalised: spawnXNormalised ?? this.spawnXNormalised,
    spawnYNormalised: spawnYNormalised ?? this.spawnYNormalised,
    targetPathSeed: targetPathSeed ?? this.targetPathSeed,
    success: success ?? this.success,
    firstSuccessfulTouchAtUtc: firstSuccessfulTouchAtUtc.present
        ? firstSuccessfulTouchAtUtc.value
        : this.firstSuccessfulTouchAtUtc,
    reactionTimeMs: reactionTimeMs.present
        ? reactionTimeMs.value
        : this.reactionTimeMs,
    missCount: missCount ?? this.missCount,
    timeout: timeout ?? this.timeout,
    cueType: cueType.present ? cueType.value : this.cueType,
    praiseCueType: praiseCueType.present
        ? praiseCueType.value
        : this.praiseCueType,
    rewardReminderShown: rewardReminderShown ?? this.rewardReminderShown,
    frustrationSeverity: frustrationSeverity ?? this.frustrationSeverity,
    frustrationFlags: frustrationFlags ?? this.frustrationFlags,
    trialReward: trialReward ?? this.trialReward,
    algorithmVersion: algorithmVersion ?? this.algorithmVersion,
  );
  TargetTrial copyWithCompanion(TargetTrialsCompanion data) {
    return TargetTrial(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      trialIndex: data.trialIndex.present
          ? data.trialIndex.value
          : this.trialIndex,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      movementStyle: data.movementStyle.present
          ? data.movementStyle.value
          : this.movementStyle,
      speedLevel: data.speedLevel.present
          ? data.speedLevel.value
          : this.speedLevel,
      sizeLevel: data.sizeLevel.present ? data.sizeLevel.value : this.sizeLevel,
      soundMode: data.soundMode.present ? data.soundMode.value : this.soundMode,
      spawnZone: data.spawnZone.present ? data.spawnZone.value : this.spawnZone,
      spawnedAtUtc: data.spawnedAtUtc.present
          ? data.spawnedAtUtc.value
          : this.spawnedAtUtc,
      becameTouchableAtUtc: data.becameTouchableAtUtc.present
          ? data.becameTouchableAtUtc.value
          : this.becameTouchableAtUtc,
      endedAtUtc: data.endedAtUtc.present
          ? data.endedAtUtc.value
          : this.endedAtUtc,
      spawnXNormalised: data.spawnXNormalised.present
          ? data.spawnXNormalised.value
          : this.spawnXNormalised,
      spawnYNormalised: data.spawnYNormalised.present
          ? data.spawnYNormalised.value
          : this.spawnYNormalised,
      targetPathSeed: data.targetPathSeed.present
          ? data.targetPathSeed.value
          : this.targetPathSeed,
      success: data.success.present ? data.success.value : this.success,
      firstSuccessfulTouchAtUtc: data.firstSuccessfulTouchAtUtc.present
          ? data.firstSuccessfulTouchAtUtc.value
          : this.firstSuccessfulTouchAtUtc,
      reactionTimeMs: data.reactionTimeMs.present
          ? data.reactionTimeMs.value
          : this.reactionTimeMs,
      missCount: data.missCount.present ? data.missCount.value : this.missCount,
      timeout: data.timeout.present ? data.timeout.value : this.timeout,
      cueType: data.cueType.present ? data.cueType.value : this.cueType,
      praiseCueType: data.praiseCueType.present
          ? data.praiseCueType.value
          : this.praiseCueType,
      rewardReminderShown: data.rewardReminderShown.present
          ? data.rewardReminderShown.value
          : this.rewardReminderShown,
      frustrationSeverity: data.frustrationSeverity.present
          ? data.frustrationSeverity.value
          : this.frustrationSeverity,
      frustrationFlags: data.frustrationFlags.present
          ? data.frustrationFlags.value
          : this.frustrationFlags,
      trialReward: data.trialReward.present
          ? data.trialReward.value
          : this.trialReward,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TargetTrial(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('trialIndex: $trialIndex, ')
          ..write('targetType: $targetType, ')
          ..write('movementStyle: $movementStyle, ')
          ..write('speedLevel: $speedLevel, ')
          ..write('sizeLevel: $sizeLevel, ')
          ..write('soundMode: $soundMode, ')
          ..write('spawnZone: $spawnZone, ')
          ..write('spawnedAtUtc: $spawnedAtUtc, ')
          ..write('becameTouchableAtUtc: $becameTouchableAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('spawnXNormalised: $spawnXNormalised, ')
          ..write('spawnYNormalised: $spawnYNormalised, ')
          ..write('targetPathSeed: $targetPathSeed, ')
          ..write('success: $success, ')
          ..write('firstSuccessfulTouchAtUtc: $firstSuccessfulTouchAtUtc, ')
          ..write('reactionTimeMs: $reactionTimeMs, ')
          ..write('missCount: $missCount, ')
          ..write('timeout: $timeout, ')
          ..write('cueType: $cueType, ')
          ..write('praiseCueType: $praiseCueType, ')
          ..write('rewardReminderShown: $rewardReminderShown, ')
          ..write('frustrationSeverity: $frustrationSeverity, ')
          ..write('frustrationFlags: $frustrationFlags, ')
          ..write('trialReward: $trialReward, ')
          ..write('algorithmVersion: $algorithmVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    sessionId,
    trialIndex,
    targetType,
    movementStyle,
    speedLevel,
    sizeLevel,
    soundMode,
    spawnZone,
    spawnedAtUtc,
    becameTouchableAtUtc,
    endedAtUtc,
    spawnXNormalised,
    spawnYNormalised,
    targetPathSeed,
    success,
    firstSuccessfulTouchAtUtc,
    reactionTimeMs,
    missCount,
    timeout,
    cueType,
    praiseCueType,
    rewardReminderShown,
    frustrationSeverity,
    frustrationFlags,
    trialReward,
    algorithmVersion,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetTrial &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.trialIndex == this.trialIndex &&
          other.targetType == this.targetType &&
          other.movementStyle == this.movementStyle &&
          other.speedLevel == this.speedLevel &&
          other.sizeLevel == this.sizeLevel &&
          other.soundMode == this.soundMode &&
          other.spawnZone == this.spawnZone &&
          other.spawnedAtUtc == this.spawnedAtUtc &&
          other.becameTouchableAtUtc == this.becameTouchableAtUtc &&
          other.endedAtUtc == this.endedAtUtc &&
          other.spawnXNormalised == this.spawnXNormalised &&
          other.spawnYNormalised == this.spawnYNormalised &&
          other.targetPathSeed == this.targetPathSeed &&
          other.success == this.success &&
          other.firstSuccessfulTouchAtUtc == this.firstSuccessfulTouchAtUtc &&
          other.reactionTimeMs == this.reactionTimeMs &&
          other.missCount == this.missCount &&
          other.timeout == this.timeout &&
          other.cueType == this.cueType &&
          other.praiseCueType == this.praiseCueType &&
          other.rewardReminderShown == this.rewardReminderShown &&
          other.frustrationSeverity == this.frustrationSeverity &&
          other.frustrationFlags == this.frustrationFlags &&
          other.trialReward == this.trialReward &&
          other.algorithmVersion == this.algorithmVersion);
}

class TargetTrialsCompanion extends UpdateCompanion<TargetTrial> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> trialIndex;
  final Value<PreyType> targetType;
  final Value<MovementStyle> movementStyle;
  final Value<SpeedLevel> speedLevel;
  final Value<SizeLevel> sizeLevel;
  final Value<SoundMode> soundMode;
  final Value<SpawnZone> spawnZone;
  final Value<DateTime> spawnedAtUtc;
  final Value<DateTime> becameTouchableAtUtc;
  final Value<DateTime?> endedAtUtc;
  final Value<double> spawnXNormalised;
  final Value<double> spawnYNormalised;
  final Value<int> targetPathSeed;
  final Value<bool> success;
  final Value<DateTime?> firstSuccessfulTouchAtUtc;
  final Value<int?> reactionTimeMs;
  final Value<int> missCount;
  final Value<bool> timeout;
  final Value<CueType?> cueType;
  final Value<CueType?> praiseCueType;
  final Value<bool> rewardReminderShown;
  final Value<int> frustrationSeverity;
  final Value<Set<FrustrationFlag>> frustrationFlags;
  final Value<double> trialReward;
  final Value<String> algorithmVersion;
  final Value<int> rowid;
  const TargetTrialsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.trialIndex = const Value.absent(),
    this.targetType = const Value.absent(),
    this.movementStyle = const Value.absent(),
    this.speedLevel = const Value.absent(),
    this.sizeLevel = const Value.absent(),
    this.soundMode = const Value.absent(),
    this.spawnZone = const Value.absent(),
    this.spawnedAtUtc = const Value.absent(),
    this.becameTouchableAtUtc = const Value.absent(),
    this.endedAtUtc = const Value.absent(),
    this.spawnXNormalised = const Value.absent(),
    this.spawnYNormalised = const Value.absent(),
    this.targetPathSeed = const Value.absent(),
    this.success = const Value.absent(),
    this.firstSuccessfulTouchAtUtc = const Value.absent(),
    this.reactionTimeMs = const Value.absent(),
    this.missCount = const Value.absent(),
    this.timeout = const Value.absent(),
    this.cueType = const Value.absent(),
    this.praiseCueType = const Value.absent(),
    this.rewardReminderShown = const Value.absent(),
    this.frustrationSeverity = const Value.absent(),
    this.frustrationFlags = const Value.absent(),
    this.trialReward = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TargetTrialsCompanion.insert({
    required String id,
    required String sessionId,
    required int trialIndex,
    required PreyType targetType,
    required MovementStyle movementStyle,
    required SpeedLevel speedLevel,
    required SizeLevel sizeLevel,
    required SoundMode soundMode,
    required SpawnZone spawnZone,
    required DateTime spawnedAtUtc,
    required DateTime becameTouchableAtUtc,
    this.endedAtUtc = const Value.absent(),
    required double spawnXNormalised,
    required double spawnYNormalised,
    required int targetPathSeed,
    required bool success,
    this.firstSuccessfulTouchAtUtc = const Value.absent(),
    this.reactionTimeMs = const Value.absent(),
    required int missCount,
    required bool timeout,
    this.cueType = const Value.absent(),
    this.praiseCueType = const Value.absent(),
    required bool rewardReminderShown,
    required int frustrationSeverity,
    required Set<FrustrationFlag> frustrationFlags,
    required double trialReward,
    required String algorithmVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       trialIndex = Value(trialIndex),
       targetType = Value(targetType),
       movementStyle = Value(movementStyle),
       speedLevel = Value(speedLevel),
       sizeLevel = Value(sizeLevel),
       soundMode = Value(soundMode),
       spawnZone = Value(spawnZone),
       spawnedAtUtc = Value(spawnedAtUtc),
       becameTouchableAtUtc = Value(becameTouchableAtUtc),
       spawnXNormalised = Value(spawnXNormalised),
       spawnYNormalised = Value(spawnYNormalised),
       targetPathSeed = Value(targetPathSeed),
       success = Value(success),
       missCount = Value(missCount),
       timeout = Value(timeout),
       rewardReminderShown = Value(rewardReminderShown),
       frustrationSeverity = Value(frustrationSeverity),
       frustrationFlags = Value(frustrationFlags),
       trialReward = Value(trialReward),
       algorithmVersion = Value(algorithmVersion);
  static Insertable<TargetTrial> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? trialIndex,
    Expression<String>? targetType,
    Expression<String>? movementStyle,
    Expression<String>? speedLevel,
    Expression<String>? sizeLevel,
    Expression<String>? soundMode,
    Expression<String>? spawnZone,
    Expression<DateTime>? spawnedAtUtc,
    Expression<DateTime>? becameTouchableAtUtc,
    Expression<DateTime>? endedAtUtc,
    Expression<double>? spawnXNormalised,
    Expression<double>? spawnYNormalised,
    Expression<int>? targetPathSeed,
    Expression<bool>? success,
    Expression<DateTime>? firstSuccessfulTouchAtUtc,
    Expression<int>? reactionTimeMs,
    Expression<int>? missCount,
    Expression<bool>? timeout,
    Expression<String>? cueType,
    Expression<String>? praiseCueType,
    Expression<bool>? rewardReminderShown,
    Expression<int>? frustrationSeverity,
    Expression<String>? frustrationFlags,
    Expression<double>? trialReward,
    Expression<String>? algorithmVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (trialIndex != null) 'trial_index': trialIndex,
      if (targetType != null) 'target_type': targetType,
      if (movementStyle != null) 'movement_style': movementStyle,
      if (speedLevel != null) 'speed_level': speedLevel,
      if (sizeLevel != null) 'size_level': sizeLevel,
      if (soundMode != null) 'sound_mode': soundMode,
      if (spawnZone != null) 'spawn_zone': spawnZone,
      if (spawnedAtUtc != null) 'spawned_at_utc': spawnedAtUtc,
      if (becameTouchableAtUtc != null)
        'became_touchable_at_utc': becameTouchableAtUtc,
      if (endedAtUtc != null) 'ended_at_utc': endedAtUtc,
      if (spawnXNormalised != null) 'spawn_x_normalised': spawnXNormalised,
      if (spawnYNormalised != null) 'spawn_y_normalised': spawnYNormalised,
      if (targetPathSeed != null) 'target_path_seed': targetPathSeed,
      if (success != null) 'success': success,
      if (firstSuccessfulTouchAtUtc != null)
        'first_successful_touch_at_utc': firstSuccessfulTouchAtUtc,
      if (reactionTimeMs != null) 'reaction_time_ms': reactionTimeMs,
      if (missCount != null) 'miss_count': missCount,
      if (timeout != null) 'timeout': timeout,
      if (cueType != null) 'cue_type': cueType,
      if (praiseCueType != null) 'praise_cue_type': praiseCueType,
      if (rewardReminderShown != null)
        'reward_reminder_shown': rewardReminderShown,
      if (frustrationSeverity != null)
        'frustration_severity': frustrationSeverity,
      if (frustrationFlags != null) 'frustration_flags': frustrationFlags,
      if (trialReward != null) 'trial_reward': trialReward,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TargetTrialsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? trialIndex,
    Value<PreyType>? targetType,
    Value<MovementStyle>? movementStyle,
    Value<SpeedLevel>? speedLevel,
    Value<SizeLevel>? sizeLevel,
    Value<SoundMode>? soundMode,
    Value<SpawnZone>? spawnZone,
    Value<DateTime>? spawnedAtUtc,
    Value<DateTime>? becameTouchableAtUtc,
    Value<DateTime?>? endedAtUtc,
    Value<double>? spawnXNormalised,
    Value<double>? spawnYNormalised,
    Value<int>? targetPathSeed,
    Value<bool>? success,
    Value<DateTime?>? firstSuccessfulTouchAtUtc,
    Value<int?>? reactionTimeMs,
    Value<int>? missCount,
    Value<bool>? timeout,
    Value<CueType?>? cueType,
    Value<CueType?>? praiseCueType,
    Value<bool>? rewardReminderShown,
    Value<int>? frustrationSeverity,
    Value<Set<FrustrationFlag>>? frustrationFlags,
    Value<double>? trialReward,
    Value<String>? algorithmVersion,
    Value<int>? rowid,
  }) {
    return TargetTrialsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      trialIndex: trialIndex ?? this.trialIndex,
      targetType: targetType ?? this.targetType,
      movementStyle: movementStyle ?? this.movementStyle,
      speedLevel: speedLevel ?? this.speedLevel,
      sizeLevel: sizeLevel ?? this.sizeLevel,
      soundMode: soundMode ?? this.soundMode,
      spawnZone: spawnZone ?? this.spawnZone,
      spawnedAtUtc: spawnedAtUtc ?? this.spawnedAtUtc,
      becameTouchableAtUtc: becameTouchableAtUtc ?? this.becameTouchableAtUtc,
      endedAtUtc: endedAtUtc ?? this.endedAtUtc,
      spawnXNormalised: spawnXNormalised ?? this.spawnXNormalised,
      spawnYNormalised: spawnYNormalised ?? this.spawnYNormalised,
      targetPathSeed: targetPathSeed ?? this.targetPathSeed,
      success: success ?? this.success,
      firstSuccessfulTouchAtUtc:
          firstSuccessfulTouchAtUtc ?? this.firstSuccessfulTouchAtUtc,
      reactionTimeMs: reactionTimeMs ?? this.reactionTimeMs,
      missCount: missCount ?? this.missCount,
      timeout: timeout ?? this.timeout,
      cueType: cueType ?? this.cueType,
      praiseCueType: praiseCueType ?? this.praiseCueType,
      rewardReminderShown: rewardReminderShown ?? this.rewardReminderShown,
      frustrationSeverity: frustrationSeverity ?? this.frustrationSeverity,
      frustrationFlags: frustrationFlags ?? this.frustrationFlags,
      trialReward: trialReward ?? this.trialReward,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (trialIndex.present) {
      map['trial_index'] = Variable<int>(trialIndex.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(
        $TargetTrialsTable.$convertertargetType.toSql(targetType.value),
      );
    }
    if (movementStyle.present) {
      map['movement_style'] = Variable<String>(
        $TargetTrialsTable.$convertermovementStyle.toSql(movementStyle.value),
      );
    }
    if (speedLevel.present) {
      map['speed_level'] = Variable<String>(
        $TargetTrialsTable.$converterspeedLevel.toSql(speedLevel.value),
      );
    }
    if (sizeLevel.present) {
      map['size_level'] = Variable<String>(
        $TargetTrialsTable.$convertersizeLevel.toSql(sizeLevel.value),
      );
    }
    if (soundMode.present) {
      map['sound_mode'] = Variable<String>(
        $TargetTrialsTable.$convertersoundMode.toSql(soundMode.value),
      );
    }
    if (spawnZone.present) {
      map['spawn_zone'] = Variable<String>(
        $TargetTrialsTable.$converterspawnZone.toSql(spawnZone.value),
      );
    }
    if (spawnedAtUtc.present) {
      map['spawned_at_utc'] = Variable<DateTime>(spawnedAtUtc.value);
    }
    if (becameTouchableAtUtc.present) {
      map['became_touchable_at_utc'] = Variable<DateTime>(
        becameTouchableAtUtc.value,
      );
    }
    if (endedAtUtc.present) {
      map['ended_at_utc'] = Variable<DateTime>(endedAtUtc.value);
    }
    if (spawnXNormalised.present) {
      map['spawn_x_normalised'] = Variable<double>(spawnXNormalised.value);
    }
    if (spawnYNormalised.present) {
      map['spawn_y_normalised'] = Variable<double>(spawnYNormalised.value);
    }
    if (targetPathSeed.present) {
      map['target_path_seed'] = Variable<int>(targetPathSeed.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (firstSuccessfulTouchAtUtc.present) {
      map['first_successful_touch_at_utc'] = Variable<DateTime>(
        firstSuccessfulTouchAtUtc.value,
      );
    }
    if (reactionTimeMs.present) {
      map['reaction_time_ms'] = Variable<int>(reactionTimeMs.value);
    }
    if (missCount.present) {
      map['miss_count'] = Variable<int>(missCount.value);
    }
    if (timeout.present) {
      map['timeout'] = Variable<bool>(timeout.value);
    }
    if (cueType.present) {
      map['cue_type'] = Variable<String>(
        $TargetTrialsTable.$convertercueTypen.toSql(cueType.value),
      );
    }
    if (praiseCueType.present) {
      map['praise_cue_type'] = Variable<String>(
        $TargetTrialsTable.$converterpraiseCueTypen.toSql(praiseCueType.value),
      );
    }
    if (rewardReminderShown.present) {
      map['reward_reminder_shown'] = Variable<bool>(rewardReminderShown.value);
    }
    if (frustrationSeverity.present) {
      map['frustration_severity'] = Variable<int>(frustrationSeverity.value);
    }
    if (frustrationFlags.present) {
      map['frustration_flags'] = Variable<String>(
        $TargetTrialsTable.$converterfrustrationFlags.toSql(
          frustrationFlags.value,
        ),
      );
    }
    if (trialReward.present) {
      map['trial_reward'] = Variable<double>(trialReward.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetTrialsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('trialIndex: $trialIndex, ')
          ..write('targetType: $targetType, ')
          ..write('movementStyle: $movementStyle, ')
          ..write('speedLevel: $speedLevel, ')
          ..write('sizeLevel: $sizeLevel, ')
          ..write('soundMode: $soundMode, ')
          ..write('spawnZone: $spawnZone, ')
          ..write('spawnedAtUtc: $spawnedAtUtc, ')
          ..write('becameTouchableAtUtc: $becameTouchableAtUtc, ')
          ..write('endedAtUtc: $endedAtUtc, ')
          ..write('spawnXNormalised: $spawnXNormalised, ')
          ..write('spawnYNormalised: $spawnYNormalised, ')
          ..write('targetPathSeed: $targetPathSeed, ')
          ..write('success: $success, ')
          ..write('firstSuccessfulTouchAtUtc: $firstSuccessfulTouchAtUtc, ')
          ..write('reactionTimeMs: $reactionTimeMs, ')
          ..write('missCount: $missCount, ')
          ..write('timeout: $timeout, ')
          ..write('cueType: $cueType, ')
          ..write('praiseCueType: $praiseCueType, ')
          ..write('rewardReminderShown: $rewardReminderShown, ')
          ..write('frustrationSeverity: $frustrationSeverity, ')
          ..write('frustrationFlags: $frustrationFlags, ')
          ..write('trialReward: $trialReward, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TouchEventsTable extends TouchEvents
    with TableInfo<$TouchEventsTable, TouchEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TouchEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trialIdMeta = const VerificationMeta(
    'trialId',
  );
  @override
  late final GeneratedColumn<String> trialId = GeneratedColumn<String>(
    'trial_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES target_trials (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pointerIdMeta = const VerificationMeta(
    'pointerId',
  );
  @override
  late final GeneratedColumn<int> pointerId = GeneratedColumn<int>(
    'pointer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logicalInteractionIdMeta =
      const VerificationMeta('logicalInteractionId');
  @override
  late final GeneratedColumn<int> logicalInteractionId = GeneratedColumn<int>(
    'logical_interaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtUtcMeta = const VerificationMeta(
    'occurredAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAtUtc =
      GeneratedColumn<DateTime>(
        'occurred_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _xNormalisedMeta = const VerificationMeta(
    'xNormalised',
  );
  @override
  late final GeneratedColumn<double> xNormalised = GeneratedColumn<double>(
    'x_normalised',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yNormalisedMeta = const VerificationMeta(
    'yNormalised',
  );
  @override
  late final GeneratedColumn<double> yNormalised = GeneratedColumn<double>(
    'y_normalised',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TouchClassification, String>
  classification =
      GeneratedColumn<String>(
        'classification',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TouchClassification>(
        $TouchEventsTable.$converterclassification,
      );
  static const VerificationMeta _deduplicatedMeta = const VerificationMeta(
    'deduplicated',
  );
  @override
  late final GeneratedColumn<bool> deduplicated = GeneratedColumn<bool>(
    'deduplicated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deduplicated" IN (0, 1))',
    ),
  );
  static const VerificationMeta _distanceFromTargetMeta =
      const VerificationMeta('distanceFromTarget');
  @override
  late final GeneratedColumn<double> distanceFromTarget =
      GeneratedColumn<double>(
        'distance_from_target',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    trialId,
    pointerId,
    logicalInteractionId,
    occurredAtUtc,
    xNormalised,
    yNormalised,
    classification,
    deduplicated,
    distanceFromTarget,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'touch_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TouchEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('trial_id')) {
      context.handle(
        _trialIdMeta,
        trialId.isAcceptableOrUnknown(data['trial_id']!, _trialIdMeta),
      );
    }
    if (data.containsKey('pointer_id')) {
      context.handle(
        _pointerIdMeta,
        pointerId.isAcceptableOrUnknown(data['pointer_id']!, _pointerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pointerIdMeta);
    }
    if (data.containsKey('logical_interaction_id')) {
      context.handle(
        _logicalInteractionIdMeta,
        logicalInteractionId.isAcceptableOrUnknown(
          data['logical_interaction_id']!,
          _logicalInteractionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_logicalInteractionIdMeta);
    }
    if (data.containsKey('occurred_at_utc')) {
      context.handle(
        _occurredAtUtcMeta,
        occurredAtUtc.isAcceptableOrUnknown(
          data['occurred_at_utc']!,
          _occurredAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtUtcMeta);
    }
    if (data.containsKey('x_normalised')) {
      context.handle(
        _xNormalisedMeta,
        xNormalised.isAcceptableOrUnknown(
          data['x_normalised']!,
          _xNormalisedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_xNormalisedMeta);
    }
    if (data.containsKey('y_normalised')) {
      context.handle(
        _yNormalisedMeta,
        yNormalised.isAcceptableOrUnknown(
          data['y_normalised']!,
          _yNormalisedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yNormalisedMeta);
    }
    if (data.containsKey('deduplicated')) {
      context.handle(
        _deduplicatedMeta,
        deduplicated.isAcceptableOrUnknown(
          data['deduplicated']!,
          _deduplicatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deduplicatedMeta);
    }
    if (data.containsKey('distance_from_target')) {
      context.handle(
        _distanceFromTargetMeta,
        distanceFromTarget.isAcceptableOrUnknown(
          data['distance_from_target']!,
          _distanceFromTargetMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TouchEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TouchEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      trialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trial_id'],
      ),
      pointerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pointer_id'],
      )!,
      logicalInteractionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logical_interaction_id'],
      )!,
      occurredAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at_utc'],
      )!,
      xNormalised: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x_normalised'],
      )!,
      yNormalised: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y_normalised'],
      )!,
      classification: $TouchEventsTable.$converterclassification.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}classification'],
        )!,
      ),
      deduplicated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deduplicated'],
      )!,
      distanceFromTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_from_target'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $TouchEventsTable createAlias(String alias) {
    return $TouchEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TouchClassification, String, String>
  $converterclassification = const EnumNameConverter<TouchClassification>(
    TouchClassification.values,
  );
}

class TouchEvent extends DataClass implements Insertable<TouchEvent> {
  final String id;
  final String sessionId;
  final String? trialId;
  final int pointerId;

  /// Groups raw contacts that were clustered into one paw interaction.
  final int logicalInteractionId;
  final DateTime occurredAtUtc;
  final double xNormalised;
  final double yNormalised;
  final TouchClassification classification;
  final bool deduplicated;

  /// Distance from the active target centre in shortest-dimension units,
  /// null when no target was active.
  final double? distanceFromTarget;
  final DateTime createdAtUtc;
  const TouchEvent({
    required this.id,
    required this.sessionId,
    this.trialId,
    required this.pointerId,
    required this.logicalInteractionId,
    required this.occurredAtUtc,
    required this.xNormalised,
    required this.yNormalised,
    required this.classification,
    required this.deduplicated,
    this.distanceFromTarget,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || trialId != null) {
      map['trial_id'] = Variable<String>(trialId);
    }
    map['pointer_id'] = Variable<int>(pointerId);
    map['logical_interaction_id'] = Variable<int>(logicalInteractionId);
    map['occurred_at_utc'] = Variable<DateTime>(occurredAtUtc);
    map['x_normalised'] = Variable<double>(xNormalised);
    map['y_normalised'] = Variable<double>(yNormalised);
    {
      map['classification'] = Variable<String>(
        $TouchEventsTable.$converterclassification.toSql(classification),
      );
    }
    map['deduplicated'] = Variable<bool>(deduplicated);
    if (!nullToAbsent || distanceFromTarget != null) {
      map['distance_from_target'] = Variable<double>(distanceFromTarget);
    }
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  TouchEventsCompanion toCompanion(bool nullToAbsent) {
    return TouchEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      trialId: trialId == null && nullToAbsent
          ? const Value.absent()
          : Value(trialId),
      pointerId: Value(pointerId),
      logicalInteractionId: Value(logicalInteractionId),
      occurredAtUtc: Value(occurredAtUtc),
      xNormalised: Value(xNormalised),
      yNormalised: Value(yNormalised),
      classification: Value(classification),
      deduplicated: Value(deduplicated),
      distanceFromTarget: distanceFromTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceFromTarget),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory TouchEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TouchEvent(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      trialId: serializer.fromJson<String?>(json['trialId']),
      pointerId: serializer.fromJson<int>(json['pointerId']),
      logicalInteractionId: serializer.fromJson<int>(
        json['logicalInteractionId'],
      ),
      occurredAtUtc: serializer.fromJson<DateTime>(json['occurredAtUtc']),
      xNormalised: serializer.fromJson<double>(json['xNormalised']),
      yNormalised: serializer.fromJson<double>(json['yNormalised']),
      classification: $TouchEventsTable.$converterclassification.fromJson(
        serializer.fromJson<String>(json['classification']),
      ),
      deduplicated: serializer.fromJson<bool>(json['deduplicated']),
      distanceFromTarget: serializer.fromJson<double?>(
        json['distanceFromTarget'],
      ),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'trialId': serializer.toJson<String?>(trialId),
      'pointerId': serializer.toJson<int>(pointerId),
      'logicalInteractionId': serializer.toJson<int>(logicalInteractionId),
      'occurredAtUtc': serializer.toJson<DateTime>(occurredAtUtc),
      'xNormalised': serializer.toJson<double>(xNormalised),
      'yNormalised': serializer.toJson<double>(yNormalised),
      'classification': serializer.toJson<String>(
        $TouchEventsTable.$converterclassification.toJson(classification),
      ),
      'deduplicated': serializer.toJson<bool>(deduplicated),
      'distanceFromTarget': serializer.toJson<double?>(distanceFromTarget),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  TouchEvent copyWith({
    String? id,
    String? sessionId,
    Value<String?> trialId = const Value.absent(),
    int? pointerId,
    int? logicalInteractionId,
    DateTime? occurredAtUtc,
    double? xNormalised,
    double? yNormalised,
    TouchClassification? classification,
    bool? deduplicated,
    Value<double?> distanceFromTarget = const Value.absent(),
    DateTime? createdAtUtc,
  }) => TouchEvent(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    trialId: trialId.present ? trialId.value : this.trialId,
    pointerId: pointerId ?? this.pointerId,
    logicalInteractionId: logicalInteractionId ?? this.logicalInteractionId,
    occurredAtUtc: occurredAtUtc ?? this.occurredAtUtc,
    xNormalised: xNormalised ?? this.xNormalised,
    yNormalised: yNormalised ?? this.yNormalised,
    classification: classification ?? this.classification,
    deduplicated: deduplicated ?? this.deduplicated,
    distanceFromTarget: distanceFromTarget.present
        ? distanceFromTarget.value
        : this.distanceFromTarget,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  TouchEvent copyWithCompanion(TouchEventsCompanion data) {
    return TouchEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      trialId: data.trialId.present ? data.trialId.value : this.trialId,
      pointerId: data.pointerId.present ? data.pointerId.value : this.pointerId,
      logicalInteractionId: data.logicalInteractionId.present
          ? data.logicalInteractionId.value
          : this.logicalInteractionId,
      occurredAtUtc: data.occurredAtUtc.present
          ? data.occurredAtUtc.value
          : this.occurredAtUtc,
      xNormalised: data.xNormalised.present
          ? data.xNormalised.value
          : this.xNormalised,
      yNormalised: data.yNormalised.present
          ? data.yNormalised.value
          : this.yNormalised,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      deduplicated: data.deduplicated.present
          ? data.deduplicated.value
          : this.deduplicated,
      distanceFromTarget: data.distanceFromTarget.present
          ? data.distanceFromTarget.value
          : this.distanceFromTarget,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TouchEvent(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('trialId: $trialId, ')
          ..write('pointerId: $pointerId, ')
          ..write('logicalInteractionId: $logicalInteractionId, ')
          ..write('occurredAtUtc: $occurredAtUtc, ')
          ..write('xNormalised: $xNormalised, ')
          ..write('yNormalised: $yNormalised, ')
          ..write('classification: $classification, ')
          ..write('deduplicated: $deduplicated, ')
          ..write('distanceFromTarget: $distanceFromTarget, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    trialId,
    pointerId,
    logicalInteractionId,
    occurredAtUtc,
    xNormalised,
    yNormalised,
    classification,
    deduplicated,
    distanceFromTarget,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TouchEvent &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.trialId == this.trialId &&
          other.pointerId == this.pointerId &&
          other.logicalInteractionId == this.logicalInteractionId &&
          other.occurredAtUtc == this.occurredAtUtc &&
          other.xNormalised == this.xNormalised &&
          other.yNormalised == this.yNormalised &&
          other.classification == this.classification &&
          other.deduplicated == this.deduplicated &&
          other.distanceFromTarget == this.distanceFromTarget &&
          other.createdAtUtc == this.createdAtUtc);
}

class TouchEventsCompanion extends UpdateCompanion<TouchEvent> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String?> trialId;
  final Value<int> pointerId;
  final Value<int> logicalInteractionId;
  final Value<DateTime> occurredAtUtc;
  final Value<double> xNormalised;
  final Value<double> yNormalised;
  final Value<TouchClassification> classification;
  final Value<bool> deduplicated;
  final Value<double?> distanceFromTarget;
  final Value<DateTime> createdAtUtc;
  final Value<int> rowid;
  const TouchEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.trialId = const Value.absent(),
    this.pointerId = const Value.absent(),
    this.logicalInteractionId = const Value.absent(),
    this.occurredAtUtc = const Value.absent(),
    this.xNormalised = const Value.absent(),
    this.yNormalised = const Value.absent(),
    this.classification = const Value.absent(),
    this.deduplicated = const Value.absent(),
    this.distanceFromTarget = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TouchEventsCompanion.insert({
    required String id,
    required String sessionId,
    this.trialId = const Value.absent(),
    required int pointerId,
    required int logicalInteractionId,
    required DateTime occurredAtUtc,
    required double xNormalised,
    required double yNormalised,
    required TouchClassification classification,
    required bool deduplicated,
    this.distanceFromTarget = const Value.absent(),
    required DateTime createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       pointerId = Value(pointerId),
       logicalInteractionId = Value(logicalInteractionId),
       occurredAtUtc = Value(occurredAtUtc),
       xNormalised = Value(xNormalised),
       yNormalised = Value(yNormalised),
       classification = Value(classification),
       deduplicated = Value(deduplicated),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<TouchEvent> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? trialId,
    Expression<int>? pointerId,
    Expression<int>? logicalInteractionId,
    Expression<DateTime>? occurredAtUtc,
    Expression<double>? xNormalised,
    Expression<double>? yNormalised,
    Expression<String>? classification,
    Expression<bool>? deduplicated,
    Expression<double>? distanceFromTarget,
    Expression<DateTime>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (trialId != null) 'trial_id': trialId,
      if (pointerId != null) 'pointer_id': pointerId,
      if (logicalInteractionId != null)
        'logical_interaction_id': logicalInteractionId,
      if (occurredAtUtc != null) 'occurred_at_utc': occurredAtUtc,
      if (xNormalised != null) 'x_normalised': xNormalised,
      if (yNormalised != null) 'y_normalised': yNormalised,
      if (classification != null) 'classification': classification,
      if (deduplicated != null) 'deduplicated': deduplicated,
      if (distanceFromTarget != null)
        'distance_from_target': distanceFromTarget,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TouchEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String?>? trialId,
    Value<int>? pointerId,
    Value<int>? logicalInteractionId,
    Value<DateTime>? occurredAtUtc,
    Value<double>? xNormalised,
    Value<double>? yNormalised,
    Value<TouchClassification>? classification,
    Value<bool>? deduplicated,
    Value<double?>? distanceFromTarget,
    Value<DateTime>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return TouchEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      trialId: trialId ?? this.trialId,
      pointerId: pointerId ?? this.pointerId,
      logicalInteractionId: logicalInteractionId ?? this.logicalInteractionId,
      occurredAtUtc: occurredAtUtc ?? this.occurredAtUtc,
      xNormalised: xNormalised ?? this.xNormalised,
      yNormalised: yNormalised ?? this.yNormalised,
      classification: classification ?? this.classification,
      deduplicated: deduplicated ?? this.deduplicated,
      distanceFromTarget: distanceFromTarget ?? this.distanceFromTarget,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (trialId.present) {
      map['trial_id'] = Variable<String>(trialId.value);
    }
    if (pointerId.present) {
      map['pointer_id'] = Variable<int>(pointerId.value);
    }
    if (logicalInteractionId.present) {
      map['logical_interaction_id'] = Variable<int>(logicalInteractionId.value);
    }
    if (occurredAtUtc.present) {
      map['occurred_at_utc'] = Variable<DateTime>(occurredAtUtc.value);
    }
    if (xNormalised.present) {
      map['x_normalised'] = Variable<double>(xNormalised.value);
    }
    if (yNormalised.present) {
      map['y_normalised'] = Variable<double>(yNormalised.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(
        $TouchEventsTable.$converterclassification.toSql(classification.value),
      );
    }
    if (deduplicated.present) {
      map['deduplicated'] = Variable<bool>(deduplicated.value);
    }
    if (distanceFromTarget.present) {
      map['distance_from_target'] = Variable<double>(distanceFromTarget.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TouchEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('trialId: $trialId, ')
          ..write('pointerId: $pointerId, ')
          ..write('logicalInteractionId: $logicalInteractionId, ')
          ..write('occurredAtUtc: $occurredAtUtc, ')
          ..write('xNormalised: $xNormalised, ')
          ..write('yNormalised: $yNormalised, ')
          ..write('classification: $classification, ')
          ..write('deduplicated: $deduplicated, ')
          ..write('distanceFromTarget: $distanceFromTarget, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferenceStatsTable extends PreferenceStats
    with TableInfo<$PreferenceStatsTable, PreferenceStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cat_profiles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<FactorType, String> factorType =
      GeneratedColumn<String>(
        'factor_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FactorType>($PreferenceStatsTable.$converterfactorType);
  static const VerificationMeta _factorValueMeta = const VerificationMeta(
    'factorValue',
  );
  @override
  late final GeneratedColumn<String> factorValue = GeneratedColumn<String>(
    'factor_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _impressionsMeta = const VerificationMeta(
    'impressions',
  );
  @override
  late final GeneratedColumn<double> impressions = GeneratedColumn<double>(
    'impressions',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successesMeta = const VerificationMeta(
    'successes',
  );
  @override
  late final GeneratedColumn<double> successes = GeneratedColumn<double>(
    'successes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeoutsMeta = const VerificationMeta(
    'timeouts',
  );
  @override
  late final GeneratedColumn<double> timeouts = GeneratedColumn<double>(
    'timeouts',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMissesMeta = const VerificationMeta(
    'totalMisses',
  );
  @override
  late final GeneratedColumn<double> totalMisses = GeneratedColumn<double>(
    'total_misses',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frustrationCountMeta = const VerificationMeta(
    'frustrationCount',
  );
  @override
  late final GeneratedColumn<double> frustrationCount = GeneratedColumn<double>(
    'frustration_count',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactionTimeEwmaMsMeta =
      const VerificationMeta('reactionTimeEwmaMs');
  @override
  late final GeneratedColumn<double> reactionTimeEwmaMs =
      GeneratedColumn<double>(
        'reaction_time_ewma_ms',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cumulativeRewardMeta = const VerificationMeta(
    'cumulativeReward',
  );
  @override
  late final GeneratedColumn<double> cumulativeReward = GeneratedColumn<double>(
    'cumulative_reward',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedAtUtcMeta = const VerificationMeta(
    'lastUsedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAtUtc =
      GeneratedColumn<DateTime>(
        'last_used_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _algorithmVersionMeta = const VerificationMeta(
    'algorithmVersion',
  );
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
    'algorithm_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    factorType,
    factorValue,
    impressions,
    successes,
    timeouts,
    totalMisses,
    frustrationCount,
    reactionTimeEwmaMs,
    cumulativeReward,
    lastUsedAtUtc,
    updatedAtUtc,
    algorithmVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('factor_value')) {
      context.handle(
        _factorValueMeta,
        factorValue.isAcceptableOrUnknown(
          data['factor_value']!,
          _factorValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_factorValueMeta);
    }
    if (data.containsKey('impressions')) {
      context.handle(
        _impressionsMeta,
        impressions.isAcceptableOrUnknown(
          data['impressions']!,
          _impressionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_impressionsMeta);
    }
    if (data.containsKey('successes')) {
      context.handle(
        _successesMeta,
        successes.isAcceptableOrUnknown(data['successes']!, _successesMeta),
      );
    } else if (isInserting) {
      context.missing(_successesMeta);
    }
    if (data.containsKey('timeouts')) {
      context.handle(
        _timeoutsMeta,
        timeouts.isAcceptableOrUnknown(data['timeouts']!, _timeoutsMeta),
      );
    } else if (isInserting) {
      context.missing(_timeoutsMeta);
    }
    if (data.containsKey('total_misses')) {
      context.handle(
        _totalMissesMeta,
        totalMisses.isAcceptableOrUnknown(
          data['total_misses']!,
          _totalMissesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalMissesMeta);
    }
    if (data.containsKey('frustration_count')) {
      context.handle(
        _frustrationCountMeta,
        frustrationCount.isAcceptableOrUnknown(
          data['frustration_count']!,
          _frustrationCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frustrationCountMeta);
    }
    if (data.containsKey('reaction_time_ewma_ms')) {
      context.handle(
        _reactionTimeEwmaMsMeta,
        reactionTimeEwmaMs.isAcceptableOrUnknown(
          data['reaction_time_ewma_ms']!,
          _reactionTimeEwmaMsMeta,
        ),
      );
    }
    if (data.containsKey('cumulative_reward')) {
      context.handle(
        _cumulativeRewardMeta,
        cumulativeReward.isAcceptableOrUnknown(
          data['cumulative_reward']!,
          _cumulativeRewardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cumulativeRewardMeta);
    }
    if (data.containsKey('last_used_at_utc')) {
      context.handle(
        _lastUsedAtUtcMeta,
        lastUsedAtUtc.isAcceptableOrUnknown(
          data['last_used_at_utc']!,
          _lastUsedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
        _algorithmVersionMeta,
        algorithmVersion.isAcceptableOrUnknown(
          data['algorithm_version']!,
          _algorithmVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {catId, factorType, factorValue, algorithmVersion},
  ];
  @override
  PreferenceStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_id'],
      )!,
      factorType: $PreferenceStatsTable.$converterfactorType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}factor_type'],
        )!,
      ),
      factorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}factor_value'],
      )!,
      impressions: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}impressions'],
      )!,
      successes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}successes'],
      )!,
      timeouts: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}timeouts'],
      )!,
      totalMisses: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_misses'],
      )!,
      frustrationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frustration_count'],
      )!,
      reactionTimeEwmaMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reaction_time_ewma_ms'],
      ),
      cumulativeReward: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cumulative_reward'],
      )!,
      lastUsedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at_utc'],
      ),
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      algorithmVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm_version'],
      )!,
    );
  }

  @override
  $PreferenceStatsTable createAlias(String alias) {
    return $PreferenceStatsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FactorType, String, String> $converterfactorType =
      const EnumNameConverter<FactorType>(FactorType.values);
}

class PreferenceStat extends DataClass implements Insertable<PreferenceStat> {
  final String id;
  final String catId;
  final FactorType factorType;
  final String factorValue;
  final double impressions;
  final double successes;
  final double timeouts;
  final double totalMisses;
  final double frustrationCount;
  final double? reactionTimeEwmaMs;
  final double cumulativeReward;
  final DateTime? lastUsedAtUtc;
  final DateTime updatedAtUtc;
  final String algorithmVersion;
  const PreferenceStat({
    required this.id,
    required this.catId,
    required this.factorType,
    required this.factorValue,
    required this.impressions,
    required this.successes,
    required this.timeouts,
    required this.totalMisses,
    required this.frustrationCount,
    this.reactionTimeEwmaMs,
    required this.cumulativeReward,
    this.lastUsedAtUtc,
    required this.updatedAtUtc,
    required this.algorithmVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cat_id'] = Variable<String>(catId);
    {
      map['factor_type'] = Variable<String>(
        $PreferenceStatsTable.$converterfactorType.toSql(factorType),
      );
    }
    map['factor_value'] = Variable<String>(factorValue);
    map['impressions'] = Variable<double>(impressions);
    map['successes'] = Variable<double>(successes);
    map['timeouts'] = Variable<double>(timeouts);
    map['total_misses'] = Variable<double>(totalMisses);
    map['frustration_count'] = Variable<double>(frustrationCount);
    if (!nullToAbsent || reactionTimeEwmaMs != null) {
      map['reaction_time_ewma_ms'] = Variable<double>(reactionTimeEwmaMs);
    }
    map['cumulative_reward'] = Variable<double>(cumulativeReward);
    if (!nullToAbsent || lastUsedAtUtc != null) {
      map['last_used_at_utc'] = Variable<DateTime>(lastUsedAtUtc);
    }
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    return map;
  }

  PreferenceStatsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceStatsCompanion(
      id: Value(id),
      catId: Value(catId),
      factorType: Value(factorType),
      factorValue: Value(factorValue),
      impressions: Value(impressions),
      successes: Value(successes),
      timeouts: Value(timeouts),
      totalMisses: Value(totalMisses),
      frustrationCount: Value(frustrationCount),
      reactionTimeEwmaMs: reactionTimeEwmaMs == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionTimeEwmaMs),
      cumulativeReward: Value(cumulativeReward),
      lastUsedAtUtc: lastUsedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      algorithmVersion: Value(algorithmVersion),
    );
  }

  factory PreferenceStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceStat(
      id: serializer.fromJson<String>(json['id']),
      catId: serializer.fromJson<String>(json['catId']),
      factorType: $PreferenceStatsTable.$converterfactorType.fromJson(
        serializer.fromJson<String>(json['factorType']),
      ),
      factorValue: serializer.fromJson<String>(json['factorValue']),
      impressions: serializer.fromJson<double>(json['impressions']),
      successes: serializer.fromJson<double>(json['successes']),
      timeouts: serializer.fromJson<double>(json['timeouts']),
      totalMisses: serializer.fromJson<double>(json['totalMisses']),
      frustrationCount: serializer.fromJson<double>(json['frustrationCount']),
      reactionTimeEwmaMs: serializer.fromJson<double?>(
        json['reactionTimeEwmaMs'],
      ),
      cumulativeReward: serializer.fromJson<double>(json['cumulativeReward']),
      lastUsedAtUtc: serializer.fromJson<DateTime?>(json['lastUsedAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catId': serializer.toJson<String>(catId),
      'factorType': serializer.toJson<String>(
        $PreferenceStatsTable.$converterfactorType.toJson(factorType),
      ),
      'factorValue': serializer.toJson<String>(factorValue),
      'impressions': serializer.toJson<double>(impressions),
      'successes': serializer.toJson<double>(successes),
      'timeouts': serializer.toJson<double>(timeouts),
      'totalMisses': serializer.toJson<double>(totalMisses),
      'frustrationCount': serializer.toJson<double>(frustrationCount),
      'reactionTimeEwmaMs': serializer.toJson<double?>(reactionTimeEwmaMs),
      'cumulativeReward': serializer.toJson<double>(cumulativeReward),
      'lastUsedAtUtc': serializer.toJson<DateTime?>(lastUsedAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
    };
  }

  PreferenceStat copyWith({
    String? id,
    String? catId,
    FactorType? factorType,
    String? factorValue,
    double? impressions,
    double? successes,
    double? timeouts,
    double? totalMisses,
    double? frustrationCount,
    Value<double?> reactionTimeEwmaMs = const Value.absent(),
    double? cumulativeReward,
    Value<DateTime?> lastUsedAtUtc = const Value.absent(),
    DateTime? updatedAtUtc,
    String? algorithmVersion,
  }) => PreferenceStat(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    factorType: factorType ?? this.factorType,
    factorValue: factorValue ?? this.factorValue,
    impressions: impressions ?? this.impressions,
    successes: successes ?? this.successes,
    timeouts: timeouts ?? this.timeouts,
    totalMisses: totalMisses ?? this.totalMisses,
    frustrationCount: frustrationCount ?? this.frustrationCount,
    reactionTimeEwmaMs: reactionTimeEwmaMs.present
        ? reactionTimeEwmaMs.value
        : this.reactionTimeEwmaMs,
    cumulativeReward: cumulativeReward ?? this.cumulativeReward,
    lastUsedAtUtc: lastUsedAtUtc.present
        ? lastUsedAtUtc.value
        : this.lastUsedAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    algorithmVersion: algorithmVersion ?? this.algorithmVersion,
  );
  PreferenceStat copyWithCompanion(PreferenceStatsCompanion data) {
    return PreferenceStat(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      factorType: data.factorType.present
          ? data.factorType.value
          : this.factorType,
      factorValue: data.factorValue.present
          ? data.factorValue.value
          : this.factorValue,
      impressions: data.impressions.present
          ? data.impressions.value
          : this.impressions,
      successes: data.successes.present ? data.successes.value : this.successes,
      timeouts: data.timeouts.present ? data.timeouts.value : this.timeouts,
      totalMisses: data.totalMisses.present
          ? data.totalMisses.value
          : this.totalMisses,
      frustrationCount: data.frustrationCount.present
          ? data.frustrationCount.value
          : this.frustrationCount,
      reactionTimeEwmaMs: data.reactionTimeEwmaMs.present
          ? data.reactionTimeEwmaMs.value
          : this.reactionTimeEwmaMs,
      cumulativeReward: data.cumulativeReward.present
          ? data.cumulativeReward.value
          : this.cumulativeReward,
      lastUsedAtUtc: data.lastUsedAtUtc.present
          ? data.lastUsedAtUtc.value
          : this.lastUsedAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceStat(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('factorType: $factorType, ')
          ..write('factorValue: $factorValue, ')
          ..write('impressions: $impressions, ')
          ..write('successes: $successes, ')
          ..write('timeouts: $timeouts, ')
          ..write('totalMisses: $totalMisses, ')
          ..write('frustrationCount: $frustrationCount, ')
          ..write('reactionTimeEwmaMs: $reactionTimeEwmaMs, ')
          ..write('cumulativeReward: $cumulativeReward, ')
          ..write('lastUsedAtUtc: $lastUsedAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('algorithmVersion: $algorithmVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    factorType,
    factorValue,
    impressions,
    successes,
    timeouts,
    totalMisses,
    frustrationCount,
    reactionTimeEwmaMs,
    cumulativeReward,
    lastUsedAtUtc,
    updatedAtUtc,
    algorithmVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceStat &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.factorType == this.factorType &&
          other.factorValue == this.factorValue &&
          other.impressions == this.impressions &&
          other.successes == this.successes &&
          other.timeouts == this.timeouts &&
          other.totalMisses == this.totalMisses &&
          other.frustrationCount == this.frustrationCount &&
          other.reactionTimeEwmaMs == this.reactionTimeEwmaMs &&
          other.cumulativeReward == this.cumulativeReward &&
          other.lastUsedAtUtc == this.lastUsedAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.algorithmVersion == this.algorithmVersion);
}

class PreferenceStatsCompanion extends UpdateCompanion<PreferenceStat> {
  final Value<String> id;
  final Value<String> catId;
  final Value<FactorType> factorType;
  final Value<String> factorValue;
  final Value<double> impressions;
  final Value<double> successes;
  final Value<double> timeouts;
  final Value<double> totalMisses;
  final Value<double> frustrationCount;
  final Value<double?> reactionTimeEwmaMs;
  final Value<double> cumulativeReward;
  final Value<DateTime?> lastUsedAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<String> algorithmVersion;
  final Value<int> rowid;
  const PreferenceStatsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.factorType = const Value.absent(),
    this.factorValue = const Value.absent(),
    this.impressions = const Value.absent(),
    this.successes = const Value.absent(),
    this.timeouts = const Value.absent(),
    this.totalMisses = const Value.absent(),
    this.frustrationCount = const Value.absent(),
    this.reactionTimeEwmaMs = const Value.absent(),
    this.cumulativeReward = const Value.absent(),
    this.lastUsedAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferenceStatsCompanion.insert({
    required String id,
    required String catId,
    required FactorType factorType,
    required String factorValue,
    required double impressions,
    required double successes,
    required double timeouts,
    required double totalMisses,
    required double frustrationCount,
    this.reactionTimeEwmaMs = const Value.absent(),
    required double cumulativeReward,
    this.lastUsedAtUtc = const Value.absent(),
    required DateTime updatedAtUtc,
    required String algorithmVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       catId = Value(catId),
       factorType = Value(factorType),
       factorValue = Value(factorValue),
       impressions = Value(impressions),
       successes = Value(successes),
       timeouts = Value(timeouts),
       totalMisses = Value(totalMisses),
       frustrationCount = Value(frustrationCount),
       cumulativeReward = Value(cumulativeReward),
       updatedAtUtc = Value(updatedAtUtc),
       algorithmVersion = Value(algorithmVersion);
  static Insertable<PreferenceStat> custom({
    Expression<String>? id,
    Expression<String>? catId,
    Expression<String>? factorType,
    Expression<String>? factorValue,
    Expression<double>? impressions,
    Expression<double>? successes,
    Expression<double>? timeouts,
    Expression<double>? totalMisses,
    Expression<double>? frustrationCount,
    Expression<double>? reactionTimeEwmaMs,
    Expression<double>? cumulativeReward,
    Expression<DateTime>? lastUsedAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<String>? algorithmVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (factorType != null) 'factor_type': factorType,
      if (factorValue != null) 'factor_value': factorValue,
      if (impressions != null) 'impressions': impressions,
      if (successes != null) 'successes': successes,
      if (timeouts != null) 'timeouts': timeouts,
      if (totalMisses != null) 'total_misses': totalMisses,
      if (frustrationCount != null) 'frustration_count': frustrationCount,
      if (reactionTimeEwmaMs != null)
        'reaction_time_ewma_ms': reactionTimeEwmaMs,
      if (cumulativeReward != null) 'cumulative_reward': cumulativeReward,
      if (lastUsedAtUtc != null) 'last_used_at_utc': lastUsedAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferenceStatsCompanion copyWith({
    Value<String>? id,
    Value<String>? catId,
    Value<FactorType>? factorType,
    Value<String>? factorValue,
    Value<double>? impressions,
    Value<double>? successes,
    Value<double>? timeouts,
    Value<double>? totalMisses,
    Value<double>? frustrationCount,
    Value<double?>? reactionTimeEwmaMs,
    Value<double>? cumulativeReward,
    Value<DateTime?>? lastUsedAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<String>? algorithmVersion,
    Value<int>? rowid,
  }) {
    return PreferenceStatsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      factorType: factorType ?? this.factorType,
      factorValue: factorValue ?? this.factorValue,
      impressions: impressions ?? this.impressions,
      successes: successes ?? this.successes,
      timeouts: timeouts ?? this.timeouts,
      totalMisses: totalMisses ?? this.totalMisses,
      frustrationCount: frustrationCount ?? this.frustrationCount,
      reactionTimeEwmaMs: reactionTimeEwmaMs ?? this.reactionTimeEwmaMs,
      cumulativeReward: cumulativeReward ?? this.cumulativeReward,
      lastUsedAtUtc: lastUsedAtUtc ?? this.lastUsedAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (factorType.present) {
      map['factor_type'] = Variable<String>(
        $PreferenceStatsTable.$converterfactorType.toSql(factorType.value),
      );
    }
    if (factorValue.present) {
      map['factor_value'] = Variable<String>(factorValue.value);
    }
    if (impressions.present) {
      map['impressions'] = Variable<double>(impressions.value);
    }
    if (successes.present) {
      map['successes'] = Variable<double>(successes.value);
    }
    if (timeouts.present) {
      map['timeouts'] = Variable<double>(timeouts.value);
    }
    if (totalMisses.present) {
      map['total_misses'] = Variable<double>(totalMisses.value);
    }
    if (frustrationCount.present) {
      map['frustration_count'] = Variable<double>(frustrationCount.value);
    }
    if (reactionTimeEwmaMs.present) {
      map['reaction_time_ewma_ms'] = Variable<double>(reactionTimeEwmaMs.value);
    }
    if (cumulativeReward.present) {
      map['cumulative_reward'] = Variable<double>(cumulativeReward.value);
    }
    if (lastUsedAtUtc.present) {
      map['last_used_at_utc'] = Variable<DateTime>(lastUsedAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceStatsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('factorType: $factorType, ')
          ..write('factorValue: $factorValue, ')
          ..write('impressions: $impressions, ')
          ..write('successes: $successes, ')
          ..write('timeouts: $timeouts, ')
          ..write('totalMisses: $totalMisses, ')
          ..write('frustrationCount: $frustrationCount, ')
          ..write('reactionTimeEwmaMs: $reactionTimeEwmaMs, ')
          ..write('cumulativeReward: $cumulativeReward, ')
          ..write('lastUsedAtUtc: $lastUsedAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CueProgressTable extends CueProgress
    with TableInfo<$CueProgressTable, CueProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CueProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cat_profiles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CueType, String> cueType =
      GeneratedColumn<String>(
        'cue_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CueType>($CueProgressTable.$convertercueType);
  static const VerificationMeta _exposuresMeta = const VerificationMeta(
    'exposures',
  );
  @override
  late final GeneratedColumn<int> exposures = GeneratedColumn<int>(
    'exposures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successfulResponsesMeta =
      const VerificationMeta('successfulResponses');
  @override
  late final GeneratedColumn<int> successfulResponses = GeneratedColumn<int>(
    'successful_responses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactionTimeEwmaMsMeta =
      const VerificationMeta('reactionTimeEwmaMs');
  @override
  late final GeneratedColumn<double> reactionTimeEwmaMs =
      GeneratedColumn<double>(
        'reaction_time_ewma_ms',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastUsedAtUtcMeta = const VerificationMeta(
    'lastUsedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAtUtc =
      GeneratedColumn<DateTime>(
        'last_used_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    cueType,
    exposures,
    successfulResponses,
    reactionTimeEwmaMs,
    lastUsedAtUtc,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cue_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<CueProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('exposures')) {
      context.handle(
        _exposuresMeta,
        exposures.isAcceptableOrUnknown(data['exposures']!, _exposuresMeta),
      );
    } else if (isInserting) {
      context.missing(_exposuresMeta);
    }
    if (data.containsKey('successful_responses')) {
      context.handle(
        _successfulResponsesMeta,
        successfulResponses.isAcceptableOrUnknown(
          data['successful_responses']!,
          _successfulResponsesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_successfulResponsesMeta);
    }
    if (data.containsKey('reaction_time_ewma_ms')) {
      context.handle(
        _reactionTimeEwmaMsMeta,
        reactionTimeEwmaMs.isAcceptableOrUnknown(
          data['reaction_time_ewma_ms']!,
          _reactionTimeEwmaMsMeta,
        ),
      );
    }
    if (data.containsKey('last_used_at_utc')) {
      context.handle(
        _lastUsedAtUtcMeta,
        lastUsedAtUtc.isAcceptableOrUnknown(
          data['last_used_at_utc']!,
          _lastUsedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {catId, cueType},
  ];
  @override
  CueProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CueProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_id'],
      )!,
      cueType: $CueProgressTable.$convertercueType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cue_type'],
        )!,
      ),
      exposures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exposures'],
      )!,
      successfulResponses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}successful_responses'],
      )!,
      reactionTimeEwmaMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reaction_time_ewma_ms'],
      ),
      lastUsedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at_utc'],
      ),
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $CueProgressTable createAlias(String alias) {
    return $CueProgressTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CueType, String, String> $convertercueType =
      const EnumNameConverter<CueType>(CueType.values);
}

class CueProgressData extends DataClass implements Insertable<CueProgressData> {
  final String id;
  final String catId;
  final CueType cueType;
  final int exposures;
  final int successfulResponses;
  final double? reactionTimeEwmaMs;
  final DateTime? lastUsedAtUtc;
  final DateTime updatedAtUtc;
  const CueProgressData({
    required this.id,
    required this.catId,
    required this.cueType,
    required this.exposures,
    required this.successfulResponses,
    this.reactionTimeEwmaMs,
    this.lastUsedAtUtc,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cat_id'] = Variable<String>(catId);
    {
      map['cue_type'] = Variable<String>(
        $CueProgressTable.$convertercueType.toSql(cueType),
      );
    }
    map['exposures'] = Variable<int>(exposures);
    map['successful_responses'] = Variable<int>(successfulResponses);
    if (!nullToAbsent || reactionTimeEwmaMs != null) {
      map['reaction_time_ewma_ms'] = Variable<double>(reactionTimeEwmaMs);
    }
    if (!nullToAbsent || lastUsedAtUtc != null) {
      map['last_used_at_utc'] = Variable<DateTime>(lastUsedAtUtc);
    }
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  CueProgressCompanion toCompanion(bool nullToAbsent) {
    return CueProgressCompanion(
      id: Value(id),
      catId: Value(catId),
      cueType: Value(cueType),
      exposures: Value(exposures),
      successfulResponses: Value(successfulResponses),
      reactionTimeEwmaMs: reactionTimeEwmaMs == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionTimeEwmaMs),
      lastUsedAtUtc: lastUsedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory CueProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CueProgressData(
      id: serializer.fromJson<String>(json['id']),
      catId: serializer.fromJson<String>(json['catId']),
      cueType: $CueProgressTable.$convertercueType.fromJson(
        serializer.fromJson<String>(json['cueType']),
      ),
      exposures: serializer.fromJson<int>(json['exposures']),
      successfulResponses: serializer.fromJson<int>(
        json['successfulResponses'],
      ),
      reactionTimeEwmaMs: serializer.fromJson<double?>(
        json['reactionTimeEwmaMs'],
      ),
      lastUsedAtUtc: serializer.fromJson<DateTime?>(json['lastUsedAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catId': serializer.toJson<String>(catId),
      'cueType': serializer.toJson<String>(
        $CueProgressTable.$convertercueType.toJson(cueType),
      ),
      'exposures': serializer.toJson<int>(exposures),
      'successfulResponses': serializer.toJson<int>(successfulResponses),
      'reactionTimeEwmaMs': serializer.toJson<double?>(reactionTimeEwmaMs),
      'lastUsedAtUtc': serializer.toJson<DateTime?>(lastUsedAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  CueProgressData copyWith({
    String? id,
    String? catId,
    CueType? cueType,
    int? exposures,
    int? successfulResponses,
    Value<double?> reactionTimeEwmaMs = const Value.absent(),
    Value<DateTime?> lastUsedAtUtc = const Value.absent(),
    DateTime? updatedAtUtc,
  }) => CueProgressData(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    cueType: cueType ?? this.cueType,
    exposures: exposures ?? this.exposures,
    successfulResponses: successfulResponses ?? this.successfulResponses,
    reactionTimeEwmaMs: reactionTimeEwmaMs.present
        ? reactionTimeEwmaMs.value
        : this.reactionTimeEwmaMs,
    lastUsedAtUtc: lastUsedAtUtc.present
        ? lastUsedAtUtc.value
        : this.lastUsedAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  CueProgressData copyWithCompanion(CueProgressCompanion data) {
    return CueProgressData(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      cueType: data.cueType.present ? data.cueType.value : this.cueType,
      exposures: data.exposures.present ? data.exposures.value : this.exposures,
      successfulResponses: data.successfulResponses.present
          ? data.successfulResponses.value
          : this.successfulResponses,
      reactionTimeEwmaMs: data.reactionTimeEwmaMs.present
          ? data.reactionTimeEwmaMs.value
          : this.reactionTimeEwmaMs,
      lastUsedAtUtc: data.lastUsedAtUtc.present
          ? data.lastUsedAtUtc.value
          : this.lastUsedAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CueProgressData(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('cueType: $cueType, ')
          ..write('exposures: $exposures, ')
          ..write('successfulResponses: $successfulResponses, ')
          ..write('reactionTimeEwmaMs: $reactionTimeEwmaMs, ')
          ..write('lastUsedAtUtc: $lastUsedAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    cueType,
    exposures,
    successfulResponses,
    reactionTimeEwmaMs,
    lastUsedAtUtc,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CueProgressData &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.cueType == this.cueType &&
          other.exposures == this.exposures &&
          other.successfulResponses == this.successfulResponses &&
          other.reactionTimeEwmaMs == this.reactionTimeEwmaMs &&
          other.lastUsedAtUtc == this.lastUsedAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class CueProgressCompanion extends UpdateCompanion<CueProgressData> {
  final Value<String> id;
  final Value<String> catId;
  final Value<CueType> cueType;
  final Value<int> exposures;
  final Value<int> successfulResponses;
  final Value<double?> reactionTimeEwmaMs;
  final Value<DateTime?> lastUsedAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const CueProgressCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.cueType = const Value.absent(),
    this.exposures = const Value.absent(),
    this.successfulResponses = const Value.absent(),
    this.reactionTimeEwmaMs = const Value.absent(),
    this.lastUsedAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CueProgressCompanion.insert({
    required String id,
    required String catId,
    required CueType cueType,
    required int exposures,
    required int successfulResponses,
    this.reactionTimeEwmaMs = const Value.absent(),
    this.lastUsedAtUtc = const Value.absent(),
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       catId = Value(catId),
       cueType = Value(cueType),
       exposures = Value(exposures),
       successfulResponses = Value(successfulResponses),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<CueProgressData> custom({
    Expression<String>? id,
    Expression<String>? catId,
    Expression<String>? cueType,
    Expression<int>? exposures,
    Expression<int>? successfulResponses,
    Expression<double>? reactionTimeEwmaMs,
    Expression<DateTime>? lastUsedAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (cueType != null) 'cue_type': cueType,
      if (exposures != null) 'exposures': exposures,
      if (successfulResponses != null)
        'successful_responses': successfulResponses,
      if (reactionTimeEwmaMs != null)
        'reaction_time_ewma_ms': reactionTimeEwmaMs,
      if (lastUsedAtUtc != null) 'last_used_at_utc': lastUsedAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CueProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? catId,
    Value<CueType>? cueType,
    Value<int>? exposures,
    Value<int>? successfulResponses,
    Value<double?>? reactionTimeEwmaMs,
    Value<DateTime?>? lastUsedAtUtc,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return CueProgressCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      cueType: cueType ?? this.cueType,
      exposures: exposures ?? this.exposures,
      successfulResponses: successfulResponses ?? this.successfulResponses,
      reactionTimeEwmaMs: reactionTimeEwmaMs ?? this.reactionTimeEwmaMs,
      lastUsedAtUtc: lastUsedAtUtc ?? this.lastUsedAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (cueType.present) {
      map['cue_type'] = Variable<String>(
        $CueProgressTable.$convertercueType.toSql(cueType.value),
      );
    }
    if (exposures.present) {
      map['exposures'] = Variable<int>(exposures.value);
    }
    if (successfulResponses.present) {
      map['successful_responses'] = Variable<int>(successfulResponses.value);
    }
    if (reactionTimeEwmaMs.present) {
      map['reaction_time_ewma_ms'] = Variable<double>(reactionTimeEwmaMs.value);
    }
    if (lastUsedAtUtc.present) {
      map['last_used_at_utc'] = Variable<DateTime>(lastUsedAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CueProgressCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('cueType: $cueType, ')
          ..write('exposures: $exposures, ')
          ..write('successfulResponses: $successfulResponses, ')
          ..write('reactionTimeEwmaMs: $reactionTimeEwmaMs, ')
          ..write('lastUsedAtUtc: $lastUsedAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultSessionDurationSecondsMeta =
      const VerificationMeta('defaultSessionDurationSeconds');
  @override
  late final GeneratedColumn<int> defaultSessionDurationSeconds =
      GeneratedColumn<int>(
        'default_session_duration_seconds',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(180),
      );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RewardSchedule, String>
  rewardSchedule = GeneratedColumn<String>(
    'reward_schedule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(RewardSchedule.none.name),
  ).withConverter<RewardSchedule>($AppSettingsTable.$converterrewardSchedule);
  static const VerificationMeta _maxRewardRemindersMeta =
      const VerificationMeta('maxRewardReminders');
  @override
  late final GeneratedColumn<int> maxRewardReminders = GeneratedColumn<int>(
    'max_reward_reminders',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _ownerPinHashMeta = const VerificationMeta(
    'ownerPinHash',
  );
  @override
  late final GeneratedColumn<String> ownerPinHash = GeneratedColumn<String>(
    'owner_pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerPinSaltMeta = const VerificationMeta(
    'ownerPinSalt',
  );
  @override
  late final GeneratedColumn<String> ownerPinSalt = GeneratedColumn<String>(
    'owner_pin_salt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _privacyVersionAcceptedMeta =
      const VerificationMeta('privacyVersionAccepted');
  @override
  late final GeneratedColumn<int> privacyVersionAccepted = GeneratedColumn<int>(
    'privacy_version_accepted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _preferredLocaleMeta = const VerificationMeta(
    'preferredLocale',
  );
  @override
  late final GeneratedColumn<String> preferredLocale = GeneratedColumn<String>(
    'preferred_locale',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reduceMotionMeta = const VerificationMeta(
    'reduceMotion',
  );
  @override
  late final GeneratedColumn<bool> reduceMotion = GeneratedColumn<bool>(
    'reduce_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _highContrastModeMeta = const VerificationMeta(
    'highContrastMode',
  );
  @override
  late final GeneratedColumn<bool> highContrastMode = GeneratedColumn<bool>(
    'high_contrast_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("high_contrast_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultSessionDurationSeconds,
    soundEnabled,
    rewardSchedule,
    maxRewardReminders,
    ownerPinHash,
    ownerPinSalt,
    onboardingComplete,
    privacyVersionAccepted,
    preferredLocale,
    reduceMotion,
    highContrastMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('default_session_duration_seconds')) {
      context.handle(
        _defaultSessionDurationSecondsMeta,
        defaultSessionDurationSeconds.isAcceptableOrUnknown(
          data['default_session_duration_seconds']!,
          _defaultSessionDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('max_reward_reminders')) {
      context.handle(
        _maxRewardRemindersMeta,
        maxRewardReminders.isAcceptableOrUnknown(
          data['max_reward_reminders']!,
          _maxRewardRemindersMeta,
        ),
      );
    }
    if (data.containsKey('owner_pin_hash')) {
      context.handle(
        _ownerPinHashMeta,
        ownerPinHash.isAcceptableOrUnknown(
          data['owner_pin_hash']!,
          _ownerPinHashMeta,
        ),
      );
    }
    if (data.containsKey('owner_pin_salt')) {
      context.handle(
        _ownerPinSaltMeta,
        ownerPinSalt.isAcceptableOrUnknown(
          data['owner_pin_salt']!,
          _ownerPinSaltMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('privacy_version_accepted')) {
      context.handle(
        _privacyVersionAcceptedMeta,
        privacyVersionAccepted.isAcceptableOrUnknown(
          data['privacy_version_accepted']!,
          _privacyVersionAcceptedMeta,
        ),
      );
    }
    if (data.containsKey('preferred_locale')) {
      context.handle(
        _preferredLocaleMeta,
        preferredLocale.isAcceptableOrUnknown(
          data['preferred_locale']!,
          _preferredLocaleMeta,
        ),
      );
    }
    if (data.containsKey('reduce_motion')) {
      context.handle(
        _reduceMotionMeta,
        reduceMotion.isAcceptableOrUnknown(
          data['reduce_motion']!,
          _reduceMotionMeta,
        ),
      );
    }
    if (data.containsKey('high_contrast_mode')) {
      context.handle(
        _highContrastModeMeta,
        highContrastMode.isAcceptableOrUnknown(
          data['high_contrast_mode']!,
          _highContrastModeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      defaultSessionDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_session_duration_seconds'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      rewardSchedule: $AppSettingsTable.$converterrewardSchedule.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reward_schedule'],
        )!,
      ),
      maxRewardReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_reward_reminders'],
      )!,
      ownerPinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_pin_hash'],
      ),
      ownerPinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_pin_salt'],
      ),
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      privacyVersionAccepted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}privacy_version_accepted'],
      )!,
      preferredLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_locale'],
      ),
      reduceMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion'],
      )!,
      highContrastMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}high_contrast_mode'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RewardSchedule, String, String>
  $converterrewardSchedule = const EnumNameConverter<RewardSchedule>(
    RewardSchedule.values,
  );
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final int defaultSessionDurationSeconds;
  final bool soundEnabled;
  final RewardSchedule rewardSchedule;
  final int maxRewardReminders;
  final String? ownerPinHash;
  final String? ownerPinSalt;
  final bool onboardingComplete;
  final int privacyVersionAccepted;
  final String? preferredLocale;
  final bool reduceMotion;
  final bool highContrastMode;
  const AppSetting({
    required this.id,
    required this.defaultSessionDurationSeconds,
    required this.soundEnabled,
    required this.rewardSchedule,
    required this.maxRewardReminders,
    this.ownerPinHash,
    this.ownerPinSalt,
    required this.onboardingComplete,
    required this.privacyVersionAccepted,
    this.preferredLocale,
    required this.reduceMotion,
    required this.highContrastMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['default_session_duration_seconds'] = Variable<int>(
      defaultSessionDurationSeconds,
    );
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    {
      map['reward_schedule'] = Variable<String>(
        $AppSettingsTable.$converterrewardSchedule.toSql(rewardSchedule),
      );
    }
    map['max_reward_reminders'] = Variable<int>(maxRewardReminders);
    if (!nullToAbsent || ownerPinHash != null) {
      map['owner_pin_hash'] = Variable<String>(ownerPinHash);
    }
    if (!nullToAbsent || ownerPinSalt != null) {
      map['owner_pin_salt'] = Variable<String>(ownerPinSalt);
    }
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['privacy_version_accepted'] = Variable<int>(privacyVersionAccepted);
    if (!nullToAbsent || preferredLocale != null) {
      map['preferred_locale'] = Variable<String>(preferredLocale);
    }
    map['reduce_motion'] = Variable<bool>(reduceMotion);
    map['high_contrast_mode'] = Variable<bool>(highContrastMode);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      defaultSessionDurationSeconds: Value(defaultSessionDurationSeconds),
      soundEnabled: Value(soundEnabled),
      rewardSchedule: Value(rewardSchedule),
      maxRewardReminders: Value(maxRewardReminders),
      ownerPinHash: ownerPinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPinHash),
      ownerPinSalt: ownerPinSalt == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPinSalt),
      onboardingComplete: Value(onboardingComplete),
      privacyVersionAccepted: Value(privacyVersionAccepted),
      preferredLocale: preferredLocale == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredLocale),
      reduceMotion: Value(reduceMotion),
      highContrastMode: Value(highContrastMode),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      defaultSessionDurationSeconds: serializer.fromJson<int>(
        json['defaultSessionDurationSeconds'],
      ),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      rewardSchedule: $AppSettingsTable.$converterrewardSchedule.fromJson(
        serializer.fromJson<String>(json['rewardSchedule']),
      ),
      maxRewardReminders: serializer.fromJson<int>(json['maxRewardReminders']),
      ownerPinHash: serializer.fromJson<String?>(json['ownerPinHash']),
      ownerPinSalt: serializer.fromJson<String?>(json['ownerPinSalt']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      privacyVersionAccepted: serializer.fromJson<int>(
        json['privacyVersionAccepted'],
      ),
      preferredLocale: serializer.fromJson<String?>(json['preferredLocale']),
      reduceMotion: serializer.fromJson<bool>(json['reduceMotion']),
      highContrastMode: serializer.fromJson<bool>(json['highContrastMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'defaultSessionDurationSeconds': serializer.toJson<int>(
        defaultSessionDurationSeconds,
      ),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'rewardSchedule': serializer.toJson<String>(
        $AppSettingsTable.$converterrewardSchedule.toJson(rewardSchedule),
      ),
      'maxRewardReminders': serializer.toJson<int>(maxRewardReminders),
      'ownerPinHash': serializer.toJson<String?>(ownerPinHash),
      'ownerPinSalt': serializer.toJson<String?>(ownerPinSalt),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'privacyVersionAccepted': serializer.toJson<int>(privacyVersionAccepted),
      'preferredLocale': serializer.toJson<String?>(preferredLocale),
      'reduceMotion': serializer.toJson<bool>(reduceMotion),
      'highContrastMode': serializer.toJson<bool>(highContrastMode),
    };
  }

  AppSetting copyWith({
    int? id,
    int? defaultSessionDurationSeconds,
    bool? soundEnabled,
    RewardSchedule? rewardSchedule,
    int? maxRewardReminders,
    Value<String?> ownerPinHash = const Value.absent(),
    Value<String?> ownerPinSalt = const Value.absent(),
    bool? onboardingComplete,
    int? privacyVersionAccepted,
    Value<String?> preferredLocale = const Value.absent(),
    bool? reduceMotion,
    bool? highContrastMode,
  }) => AppSetting(
    id: id ?? this.id,
    defaultSessionDurationSeconds:
        defaultSessionDurationSeconds ?? this.defaultSessionDurationSeconds,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    rewardSchedule: rewardSchedule ?? this.rewardSchedule,
    maxRewardReminders: maxRewardReminders ?? this.maxRewardReminders,
    ownerPinHash: ownerPinHash.present ? ownerPinHash.value : this.ownerPinHash,
    ownerPinSalt: ownerPinSalt.present ? ownerPinSalt.value : this.ownerPinSalt,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    privacyVersionAccepted:
        privacyVersionAccepted ?? this.privacyVersionAccepted,
    preferredLocale: preferredLocale.present
        ? preferredLocale.value
        : this.preferredLocale,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    highContrastMode: highContrastMode ?? this.highContrastMode,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      defaultSessionDurationSeconds: data.defaultSessionDurationSeconds.present
          ? data.defaultSessionDurationSeconds.value
          : this.defaultSessionDurationSeconds,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      rewardSchedule: data.rewardSchedule.present
          ? data.rewardSchedule.value
          : this.rewardSchedule,
      maxRewardReminders: data.maxRewardReminders.present
          ? data.maxRewardReminders.value
          : this.maxRewardReminders,
      ownerPinHash: data.ownerPinHash.present
          ? data.ownerPinHash.value
          : this.ownerPinHash,
      ownerPinSalt: data.ownerPinSalt.present
          ? data.ownerPinSalt.value
          : this.ownerPinSalt,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      privacyVersionAccepted: data.privacyVersionAccepted.present
          ? data.privacyVersionAccepted.value
          : this.privacyVersionAccepted,
      preferredLocale: data.preferredLocale.present
          ? data.preferredLocale.value
          : this.preferredLocale,
      reduceMotion: data.reduceMotion.present
          ? data.reduceMotion.value
          : this.reduceMotion,
      highContrastMode: data.highContrastMode.present
          ? data.highContrastMode.value
          : this.highContrastMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write(
            'defaultSessionDurationSeconds: $defaultSessionDurationSeconds, ',
          )
          ..write('soundEnabled: $soundEnabled, ')
          ..write('rewardSchedule: $rewardSchedule, ')
          ..write('maxRewardReminders: $maxRewardReminders, ')
          ..write('ownerPinHash: $ownerPinHash, ')
          ..write('ownerPinSalt: $ownerPinSalt, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('privacyVersionAccepted: $privacyVersionAccepted, ')
          ..write('preferredLocale: $preferredLocale, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('highContrastMode: $highContrastMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultSessionDurationSeconds,
    soundEnabled,
    rewardSchedule,
    maxRewardReminders,
    ownerPinHash,
    ownerPinSalt,
    onboardingComplete,
    privacyVersionAccepted,
    preferredLocale,
    reduceMotion,
    highContrastMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.defaultSessionDurationSeconds ==
              this.defaultSessionDurationSeconds &&
          other.soundEnabled == this.soundEnabled &&
          other.rewardSchedule == this.rewardSchedule &&
          other.maxRewardReminders == this.maxRewardReminders &&
          other.ownerPinHash == this.ownerPinHash &&
          other.ownerPinSalt == this.ownerPinSalt &&
          other.onboardingComplete == this.onboardingComplete &&
          other.privacyVersionAccepted == this.privacyVersionAccepted &&
          other.preferredLocale == this.preferredLocale &&
          other.reduceMotion == this.reduceMotion &&
          other.highContrastMode == this.highContrastMode);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<int> defaultSessionDurationSeconds;
  final Value<bool> soundEnabled;
  final Value<RewardSchedule> rewardSchedule;
  final Value<int> maxRewardReminders;
  final Value<String?> ownerPinHash;
  final Value<String?> ownerPinSalt;
  final Value<bool> onboardingComplete;
  final Value<int> privacyVersionAccepted;
  final Value<String?> preferredLocale;
  final Value<bool> reduceMotion;
  final Value<bool> highContrastMode;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.defaultSessionDurationSeconds = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.rewardSchedule = const Value.absent(),
    this.maxRewardReminders = const Value.absent(),
    this.ownerPinHash = const Value.absent(),
    this.ownerPinSalt = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.privacyVersionAccepted = const Value.absent(),
    this.preferredLocale = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.highContrastMode = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.defaultSessionDurationSeconds = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.rewardSchedule = const Value.absent(),
    this.maxRewardReminders = const Value.absent(),
    this.ownerPinHash = const Value.absent(),
    this.ownerPinSalt = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.privacyVersionAccepted = const Value.absent(),
    this.preferredLocale = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.highContrastMode = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? defaultSessionDurationSeconds,
    Expression<bool>? soundEnabled,
    Expression<String>? rewardSchedule,
    Expression<int>? maxRewardReminders,
    Expression<String>? ownerPinHash,
    Expression<String>? ownerPinSalt,
    Expression<bool>? onboardingComplete,
    Expression<int>? privacyVersionAccepted,
    Expression<String>? preferredLocale,
    Expression<bool>? reduceMotion,
    Expression<bool>? highContrastMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultSessionDurationSeconds != null)
        'default_session_duration_seconds': defaultSessionDurationSeconds,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (rewardSchedule != null) 'reward_schedule': rewardSchedule,
      if (maxRewardReminders != null)
        'max_reward_reminders': maxRewardReminders,
      if (ownerPinHash != null) 'owner_pin_hash': ownerPinHash,
      if (ownerPinSalt != null) 'owner_pin_salt': ownerPinSalt,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (privacyVersionAccepted != null)
        'privacy_version_accepted': privacyVersionAccepted,
      if (preferredLocale != null) 'preferred_locale': preferredLocale,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (highContrastMode != null) 'high_contrast_mode': highContrastMode,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? defaultSessionDurationSeconds,
    Value<bool>? soundEnabled,
    Value<RewardSchedule>? rewardSchedule,
    Value<int>? maxRewardReminders,
    Value<String?>? ownerPinHash,
    Value<String?>? ownerPinSalt,
    Value<bool>? onboardingComplete,
    Value<int>? privacyVersionAccepted,
    Value<String?>? preferredLocale,
    Value<bool>? reduceMotion,
    Value<bool>? highContrastMode,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      defaultSessionDurationSeconds:
          defaultSessionDurationSeconds ?? this.defaultSessionDurationSeconds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      rewardSchedule: rewardSchedule ?? this.rewardSchedule,
      maxRewardReminders: maxRewardReminders ?? this.maxRewardReminders,
      ownerPinHash: ownerPinHash ?? this.ownerPinHash,
      ownerPinSalt: ownerPinSalt ?? this.ownerPinSalt,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      privacyVersionAccepted:
          privacyVersionAccepted ?? this.privacyVersionAccepted,
      preferredLocale: preferredLocale ?? this.preferredLocale,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      highContrastMode: highContrastMode ?? this.highContrastMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (defaultSessionDurationSeconds.present) {
      map['default_session_duration_seconds'] = Variable<int>(
        defaultSessionDurationSeconds.value,
      );
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (rewardSchedule.present) {
      map['reward_schedule'] = Variable<String>(
        $AppSettingsTable.$converterrewardSchedule.toSql(rewardSchedule.value),
      );
    }
    if (maxRewardReminders.present) {
      map['max_reward_reminders'] = Variable<int>(maxRewardReminders.value);
    }
    if (ownerPinHash.present) {
      map['owner_pin_hash'] = Variable<String>(ownerPinHash.value);
    }
    if (ownerPinSalt.present) {
      map['owner_pin_salt'] = Variable<String>(ownerPinSalt.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (privacyVersionAccepted.present) {
      map['privacy_version_accepted'] = Variable<int>(
        privacyVersionAccepted.value,
      );
    }
    if (preferredLocale.present) {
      map['preferred_locale'] = Variable<String>(preferredLocale.value);
    }
    if (reduceMotion.present) {
      map['reduce_motion'] = Variable<bool>(reduceMotion.value);
    }
    if (highContrastMode.present) {
      map['high_contrast_mode'] = Variable<bool>(highContrastMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write(
            'defaultSessionDurationSeconds: $defaultSessionDurationSeconds, ',
          )
          ..write('soundEnabled: $soundEnabled, ')
          ..write('rewardSchedule: $rewardSchedule, ')
          ..write('maxRewardReminders: $maxRewardReminders, ')
          ..write('ownerPinHash: $ownerPinHash, ')
          ..write('ownerPinSalt: $ownerPinSalt, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('privacyVersionAccepted: $privacyVersionAccepted, ')
          ..write('preferredLocale: $preferredLocale, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('highContrastMode: $highContrastMode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatProfilesTable catProfiles = $CatProfilesTable(this);
  late final $VoiceCuesTable voiceCues = $VoiceCuesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $TargetTrialsTable targetTrials = $TargetTrialsTable(this);
  late final $TouchEventsTable touchEvents = $TouchEventsTable(this);
  late final $PreferenceStatsTable preferenceStats = $PreferenceStatsTable(
    this,
  );
  late final $CueProgressTable cueProgress = $CueProgressTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catProfiles,
    voiceCues,
    sessions,
    targetTrials,
    touchEvents,
    preferenceStats,
    cueProgress,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cat_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('voice_cues', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cat_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('target_trials', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('touch_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'target_trials',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('touch_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cat_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('preference_stats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cat_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cue_progress', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CatProfilesTableCreateCompanionBuilder =
    CatProfilesCompanion Function({
      required String id,
      required String name,
      Value<String?> photoPath,
      required DateTime createdAtUtc,
      required DateTime updatedAtUtc,
      Value<DateTime?> archivedAtUtc,
      required AgeGroup ageGroup,
      required BodySize bodySize,
      required EnergyLevel energyLevel,
      required ScreenExperience screenExperience,
      Value<FavouritePrey?> favouritePrey,
      required SoundSensitivity soundSensitivity,
      required TreatMotivation treatMotivation,
      required MobilityConsideration mobilityConsideration,
      required VisionConsideration visionConsideration,
      required HearingConsideration hearingConsideration,
      required PrimaryGoal primaryGoal,
      Value<String?> notes,
      required int onboardingVersion,
      required CalibrationState calibrationState,
      required int currentDifficulty,
      required String algorithmVersion,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$CatProfilesTableUpdateCompanionBuilder =
    CatProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> photoPath,
      Value<DateTime> createdAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<DateTime?> archivedAtUtc,
      Value<AgeGroup> ageGroup,
      Value<BodySize> bodySize,
      Value<EnergyLevel> energyLevel,
      Value<ScreenExperience> screenExperience,
      Value<FavouritePrey?> favouritePrey,
      Value<SoundSensitivity> soundSensitivity,
      Value<TreatMotivation> treatMotivation,
      Value<MobilityConsideration> mobilityConsideration,
      Value<VisionConsideration> visionConsideration,
      Value<HearingConsideration> hearingConsideration,
      Value<PrimaryGoal> primaryGoal,
      Value<String?> notes,
      Value<int> onboardingVersion,
      Value<CalibrationState> calibrationState,
      Value<int> currentDifficulty,
      Value<String> algorithmVersion,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$CatProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $CatProfilesTable, CatProfile> {
  $$CatProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VoiceCuesTable, List<VoiceCue>>
  _voiceCuesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.voiceCues,
    aliasName: 'cat_profiles__id__voice_cues__cat_id',
  );

  $$VoiceCuesTableProcessedTableManager get voiceCuesRefs {
    final manager = $$VoiceCuesTableTableManager(
      $_db,
      $_db.voiceCues,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_voiceCuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'cat_profiles__id__sessions__cat_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PreferenceStatsTable, List<PreferenceStat>>
  _preferenceStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.preferenceStats,
    aliasName: 'cat_profiles__id__preference_stats__cat_id',
  );

  $$PreferenceStatsTableProcessedTableManager get preferenceStatsRefs {
    final manager = $$PreferenceStatsTableTableManager(
      $_db,
      $_db.preferenceStats,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _preferenceStatsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CueProgressTable, List<CueProgressData>>
  _cueProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cueProgress,
    aliasName: 'cat_profiles__id__cue_progress__cat_id',
  );

  $$CueProgressTableProcessedTableManager get cueProgressRefs {
    final manager = $$CueProgressTableTableManager(
      $_db,
      $_db.cueProgress,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cueProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CatProfilesTable> {
  $$CatProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AgeGroup, AgeGroup, String> get ageGroup =>
      $composableBuilder(
        column: $table.ageGroup,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<BodySize, BodySize, String> get bodySize =>
      $composableBuilder(
        column: $table.bodySize,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<EnergyLevel, EnergyLevel, String>
  get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ScreenExperience, ScreenExperience, String>
  get screenExperience => $composableBuilder(
    column: $table.screenExperience,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FavouritePrey?, FavouritePrey, String>
  get favouritePrey => $composableBuilder(
    column: $table.favouritePrey,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SoundSensitivity, SoundSensitivity, String>
  get soundSensitivity => $composableBuilder(
    column: $table.soundSensitivity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TreatMotivation, TreatMotivation, String>
  get treatMotivation => $composableBuilder(
    column: $table.treatMotivation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    MobilityConsideration,
    MobilityConsideration,
    String
  >
  get mobilityConsideration => $composableBuilder(
    column: $table.mobilityConsideration,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    VisionConsideration,
    VisionConsideration,
    String
  >
  get visionConsideration => $composableBuilder(
    column: $table.visionConsideration,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    HearingConsideration,
    HearingConsideration,
    String
  >
  get hearingConsideration => $composableBuilder(
    column: $table.hearingConsideration,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PrimaryGoal, PrimaryGoal, String>
  get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onboardingVersion => $composableBuilder(
    column: $table.onboardingVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CalibrationState, CalibrationState, String>
  get calibrationState => $composableBuilder(
    column: $table.calibrationState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get currentDifficulty => $composableBuilder(
    column: $table.currentDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> voiceCuesRefs(
    Expression<bool> Function($$VoiceCuesTableFilterComposer f) f,
  ) {
    final $$VoiceCuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.voiceCues,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoiceCuesTableFilterComposer(
            $db: $db,
            $table: $db.voiceCues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> preferenceStatsRefs(
    Expression<bool> Function($$PreferenceStatsTableFilterComposer f) f,
  ) {
    final $$PreferenceStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preferenceStats,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreferenceStatsTableFilterComposer(
            $db: $db,
            $table: $db.preferenceStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cueProgressRefs(
    Expression<bool> Function($$CueProgressTableFilterComposer f) f,
  ) {
    final $$CueProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cueProgress,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CueProgressTableFilterComposer(
            $db: $db,
            $table: $db.cueProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatProfilesTable> {
  $$CatProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageGroup => $composableBuilder(
    column: $table.ageGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodySize => $composableBuilder(
    column: $table.bodySize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screenExperience => $composableBuilder(
    column: $table.screenExperience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favouritePrey => $composableBuilder(
    column: $table.favouritePrey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundSensitivity => $composableBuilder(
    column: $table.soundSensitivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get treatMotivation => $composableBuilder(
    column: $table.treatMotivation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobilityConsideration => $composableBuilder(
    column: $table.mobilityConsideration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visionConsideration => $composableBuilder(
    column: $table.visionConsideration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hearingConsideration => $composableBuilder(
    column: $table.hearingConsideration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onboardingVersion => $composableBuilder(
    column: $table.onboardingVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calibrationState => $composableBuilder(
    column: $table.calibrationState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDifficulty => $composableBuilder(
    column: $table.currentDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatProfilesTable> {
  $$CatProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AgeGroup, String> get ageGroup =>
      $composableBuilder(column: $table.ageGroup, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BodySize, String> get bodySize =>
      $composableBuilder(column: $table.bodySize, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EnergyLevel, String> get energyLevel =>
      $composableBuilder(
        column: $table.energyLevel,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ScreenExperience, String>
  get screenExperience => $composableBuilder(
    column: $table.screenExperience,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FavouritePrey?, String> get favouritePrey =>
      $composableBuilder(
        column: $table.favouritePrey,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SoundSensitivity, String>
  get soundSensitivity => $composableBuilder(
    column: $table.soundSensitivity,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TreatMotivation, String>
  get treatMotivation => $composableBuilder(
    column: $table.treatMotivation,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MobilityConsideration, String>
  get mobilityConsideration => $composableBuilder(
    column: $table.mobilityConsideration,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<VisionConsideration, String>
  get visionConsideration => $composableBuilder(
    column: $table.visionConsideration,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HearingConsideration, String>
  get hearingConsideration => $composableBuilder(
    column: $table.hearingConsideration,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PrimaryGoal, String> get primaryGoal =>
      $composableBuilder(
        column: $table.primaryGoal,
        builder: (column) => column,
      );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get onboardingVersion => $composableBuilder(
    column: $table.onboardingVersion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CalibrationState, String>
  get calibrationState => $composableBuilder(
    column: $table.calibrationState,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentDifficulty => $composableBuilder(
    column: $table.currentDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> voiceCuesRefs<T extends Object>(
    Expression<T> Function($$VoiceCuesTableAnnotationComposer a) f,
  ) {
    final $$VoiceCuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.voiceCues,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VoiceCuesTableAnnotationComposer(
            $db: $db,
            $table: $db.voiceCues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> preferenceStatsRefs<T extends Object>(
    Expression<T> Function($$PreferenceStatsTableAnnotationComposer a) f,
  ) {
    final $$PreferenceStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preferenceStats,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreferenceStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.preferenceStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cueProgressRefs<T extends Object>(
    Expression<T> Function($$CueProgressTableAnnotationComposer a) f,
  ) {
    final $$CueProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cueProgress,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CueProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.cueProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatProfilesTable,
          CatProfile,
          $$CatProfilesTableFilterComposer,
          $$CatProfilesTableOrderingComposer,
          $$CatProfilesTableAnnotationComposer,
          $$CatProfilesTableCreateCompanionBuilder,
          $$CatProfilesTableUpdateCompanionBuilder,
          (CatProfile, $$CatProfilesTableReferences),
          CatProfile,
          PrefetchHooks Function({
            bool voiceCuesRefs,
            bool sessionsRefs,
            bool preferenceStatsRefs,
            bool cueProgressRefs,
          })
        > {
  $$CatProfilesTableTableManager(_$AppDatabase db, $CatProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<DateTime?> archivedAtUtc = const Value.absent(),
                Value<AgeGroup> ageGroup = const Value.absent(),
                Value<BodySize> bodySize = const Value.absent(),
                Value<EnergyLevel> energyLevel = const Value.absent(),
                Value<ScreenExperience> screenExperience = const Value.absent(),
                Value<FavouritePrey?> favouritePrey = const Value.absent(),
                Value<SoundSensitivity> soundSensitivity = const Value.absent(),
                Value<TreatMotivation> treatMotivation = const Value.absent(),
                Value<MobilityConsideration> mobilityConsideration =
                    const Value.absent(),
                Value<VisionConsideration> visionConsideration =
                    const Value.absent(),
                Value<HearingConsideration> hearingConsideration =
                    const Value.absent(),
                Value<PrimaryGoal> primaryGoal = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> onboardingVersion = const Value.absent(),
                Value<CalibrationState> calibrationState = const Value.absent(),
                Value<int> currentDifficulty = const Value.absent(),
                Value<String> algorithmVersion = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatProfilesCompanion(
                id: id,
                name: name,
                photoPath: photoPath,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                archivedAtUtc: archivedAtUtc,
                ageGroup: ageGroup,
                bodySize: bodySize,
                energyLevel: energyLevel,
                screenExperience: screenExperience,
                favouritePrey: favouritePrey,
                soundSensitivity: soundSensitivity,
                treatMotivation: treatMotivation,
                mobilityConsideration: mobilityConsideration,
                visionConsideration: visionConsideration,
                hearingConsideration: hearingConsideration,
                primaryGoal: primaryGoal,
                notes: notes,
                onboardingVersion: onboardingVersion,
                calibrationState: calibrationState,
                currentDifficulty: currentDifficulty,
                algorithmVersion: algorithmVersion,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> photoPath = const Value.absent(),
                required DateTime createdAtUtc,
                required DateTime updatedAtUtc,
                Value<DateTime?> archivedAtUtc = const Value.absent(),
                required AgeGroup ageGroup,
                required BodySize bodySize,
                required EnergyLevel energyLevel,
                required ScreenExperience screenExperience,
                Value<FavouritePrey?> favouritePrey = const Value.absent(),
                required SoundSensitivity soundSensitivity,
                required TreatMotivation treatMotivation,
                required MobilityConsideration mobilityConsideration,
                required VisionConsideration visionConsideration,
                required HearingConsideration hearingConsideration,
                required PrimaryGoal primaryGoal,
                Value<String?> notes = const Value.absent(),
                required int onboardingVersion,
                required CalibrationState calibrationState,
                required int currentDifficulty,
                required String algorithmVersion,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => CatProfilesCompanion.insert(
                id: id,
                name: name,
                photoPath: photoPath,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                archivedAtUtc: archivedAtUtc,
                ageGroup: ageGroup,
                bodySize: bodySize,
                energyLevel: energyLevel,
                screenExperience: screenExperience,
                favouritePrey: favouritePrey,
                soundSensitivity: soundSensitivity,
                treatMotivation: treatMotivation,
                mobilityConsideration: mobilityConsideration,
                visionConsideration: visionConsideration,
                hearingConsideration: hearingConsideration,
                primaryGoal: primaryGoal,
                notes: notes,
                onboardingVersion: onboardingVersion,
                calibrationState: calibrationState,
                currentDifficulty: currentDifficulty,
                algorithmVersion: algorithmVersion,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                voiceCuesRefs = false,
                sessionsRefs = false,
                preferenceStatsRefs = false,
                cueProgressRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (voiceCuesRefs) db.voiceCues,
                    if (sessionsRefs) db.sessions,
                    if (preferenceStatsRefs) db.preferenceStats,
                    if (cueProgressRefs) db.cueProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (voiceCuesRefs)
                        await $_getPrefetchedData<
                          CatProfile,
                          $CatProfilesTable,
                          VoiceCue
                        >(
                          currentTable: table,
                          referencedTable: $$CatProfilesTableReferences
                              ._voiceCuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CatProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).voiceCuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          CatProfile,
                          $CatProfilesTable,
                          Session
                        >(
                          currentTable: table,
                          referencedTable: $$CatProfilesTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CatProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (preferenceStatsRefs)
                        await $_getPrefetchedData<
                          CatProfile,
                          $CatProfilesTable,
                          PreferenceStat
                        >(
                          currentTable: table,
                          referencedTable: $$CatProfilesTableReferences
                              ._preferenceStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CatProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).preferenceStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cueProgressRefs)
                        await $_getPrefetchedData<
                          CatProfile,
                          $CatProfilesTable,
                          CueProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$CatProfilesTableReferences
                              ._cueProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CatProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).cueProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CatProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatProfilesTable,
      CatProfile,
      $$CatProfilesTableFilterComposer,
      $$CatProfilesTableOrderingComposer,
      $$CatProfilesTableAnnotationComposer,
      $$CatProfilesTableCreateCompanionBuilder,
      $$CatProfilesTableUpdateCompanionBuilder,
      (CatProfile, $$CatProfilesTableReferences),
      CatProfile,
      PrefetchHooks Function({
        bool voiceCuesRefs,
        bool sessionsRefs,
        bool preferenceStatsRefs,
        bool cueProgressRefs,
      })
    >;
typedef $$VoiceCuesTableCreateCompanionBuilder =
    VoiceCuesCompanion Function({
      required String id,
      required String catId,
      required CueType cueType,
      required String filePath,
      required int durationMs,
      required DateTime createdAtUtc,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$VoiceCuesTableUpdateCompanionBuilder =
    VoiceCuesCompanion Function({
      Value<String> id,
      Value<String> catId,
      Value<CueType> cueType,
      Value<String> filePath,
      Value<int> durationMs,
      Value<DateTime> createdAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

final class $$VoiceCuesTableReferences
    extends BaseReferences<_$AppDatabase, $VoiceCuesTable, VoiceCue> {
  $$VoiceCuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CatProfilesTable _catIdTable(_$AppDatabase db) =>
      db.catProfiles.createAlias('voice_cues__cat_id__cat_profiles__id');

  $$CatProfilesTableProcessedTableManager get catId {
    final $_column = $_itemColumn<String>('cat_id')!;

    final manager = $$CatProfilesTableTableManager(
      $_db,
      $_db.catProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VoiceCuesTableFilterComposer
    extends Composer<_$AppDatabase, $VoiceCuesTable> {
  $$VoiceCuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CueType, CueType, String> get cueType =>
      $composableBuilder(
        column: $table.cueType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$CatProfilesTableFilterComposer get catId {
    final $$CatProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableFilterComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VoiceCuesTableOrderingComposer
    extends Composer<_$AppDatabase, $VoiceCuesTable> {
  $$VoiceCuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueType => $composableBuilder(
    column: $table.cueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatProfilesTableOrderingComposer get catId {
    final $$CatProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VoiceCuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoiceCuesTable> {
  $$VoiceCuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CueType, String> get cueType =>
      $composableBuilder(column: $table.cueType, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  $$CatProfilesTableAnnotationComposer get catId {
    final $$CatProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VoiceCuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VoiceCuesTable,
          VoiceCue,
          $$VoiceCuesTableFilterComposer,
          $$VoiceCuesTableOrderingComposer,
          $$VoiceCuesTableAnnotationComposer,
          $$VoiceCuesTableCreateCompanionBuilder,
          $$VoiceCuesTableUpdateCompanionBuilder,
          (VoiceCue, $$VoiceCuesTableReferences),
          VoiceCue,
          PrefetchHooks Function({bool catId})
        > {
  $$VoiceCuesTableTableManager(_$AppDatabase db, $VoiceCuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoiceCuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoiceCuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoiceCuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> catId = const Value.absent(),
                Value<CueType> cueType = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoiceCuesCompanion(
                id: id,
                catId: catId,
                cueType: cueType,
                filePath: filePath,
                durationMs: durationMs,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String catId,
                required CueType cueType,
                required String filePath,
                required int durationMs,
                required DateTime createdAtUtc,
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => VoiceCuesCompanion.insert(
                id: id,
                catId: catId,
                cueType: cueType,
                filePath: filePath,
                durationMs: durationMs,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VoiceCuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable: $$VoiceCuesTableReferences
                                    ._catIdTable(db),
                                referencedColumn: $$VoiceCuesTableReferences
                                    ._catIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VoiceCuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VoiceCuesTable,
      VoiceCue,
      $$VoiceCuesTableFilterComposer,
      $$VoiceCuesTableOrderingComposer,
      $$VoiceCuesTableAnnotationComposer,
      $$VoiceCuesTableCreateCompanionBuilder,
      $$VoiceCuesTableUpdateCompanionBuilder,
      (VoiceCue, $$VoiceCuesTableReferences),
      VoiceCue,
      PrefetchHooks Function({bool catId})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      Value<String?> catId,
      required SessionMode mode,
      required DateTime startedAtUtc,
      Value<DateTime?> endedAtUtc,
      required int plannedDurationSeconds,
      Value<int?> actualDurationMs,
      required SessionStatus status,
      required bool calibrationSession,
      required int randomSeed,
      required String algorithmVersion,
      required String appVersion,
      required String platform,
      required double screenWidthLogical,
      required double screenHeightLogical,
      Value<OwnerFeedback?> ownerSubjectiveFeedback,
      required int catches,
      required int misses,
      required int timeouts,
      Value<int?> medianReactionMs,
      required int frustrationCount,
      required DateTime createdAtUtc,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String?> catId,
      Value<SessionMode> mode,
      Value<DateTime> startedAtUtc,
      Value<DateTime?> endedAtUtc,
      Value<int> plannedDurationSeconds,
      Value<int?> actualDurationMs,
      Value<SessionStatus> status,
      Value<bool> calibrationSession,
      Value<int> randomSeed,
      Value<String> algorithmVersion,
      Value<String> appVersion,
      Value<String> platform,
      Value<double> screenWidthLogical,
      Value<double> screenHeightLogical,
      Value<OwnerFeedback?> ownerSubjectiveFeedback,
      Value<int> catches,
      Value<int> misses,
      Value<int> timeouts,
      Value<int?> medianReactionMs,
      Value<int> frustrationCount,
      Value<DateTime> createdAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CatProfilesTable _catIdTable(_$AppDatabase db) =>
      db.catProfiles.createAlias('sessions__cat_id__cat_profiles__id');

  $$CatProfilesTableProcessedTableManager? get catId {
    final $_column = $_itemColumn<String>('cat_id');
    if ($_column == null) return null;
    final manager = $$CatProfilesTableTableManager(
      $_db,
      $_db.catProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TargetTrialsTable, List<TargetTrial>>
  _targetTrialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.targetTrials,
    aliasName: 'sessions__id__target_trials__session_id',
  );

  $$TargetTrialsTableProcessedTableManager get targetTrialsRefs {
    final manager = $$TargetTrialsTableTableManager(
      $_db,
      $_db.targetTrials,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetTrialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TouchEventsTable, List<TouchEvent>>
  _touchEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.touchEvents,
    aliasName: 'sessions__id__touch_events__session_id',
  );

  $$TouchEventsTableProcessedTableManager get touchEventsRefs {
    final manager = $$TouchEventsTableTableManager(
      $_db,
      $_db.touchEvents,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_touchEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionMode, SessionMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationSeconds => $composableBuilder(
    column: $table.plannedDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDurationMs => $composableBuilder(
    column: $table.actualDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get calibrationSession => $composableBuilder(
    column: $table.calibrationSession,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get randomSeed => $composableBuilder(
    column: $table.randomSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get screenWidthLogical => $composableBuilder(
    column: $table.screenWidthLogical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get screenHeightLogical => $composableBuilder(
    column: $table.screenHeightLogical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OwnerFeedback?, OwnerFeedback, String>
  get ownerSubjectiveFeedback => $composableBuilder(
    column: $table.ownerSubjectiveFeedback,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get catches => $composableBuilder(
    column: $table.catches,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get misses => $composableBuilder(
    column: $table.misses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeouts => $composableBuilder(
    column: $table.timeouts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get medianReactionMs => $composableBuilder(
    column: $table.medianReactionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frustrationCount => $composableBuilder(
    column: $table.frustrationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$CatProfilesTableFilterComposer get catId {
    final $$CatProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableFilterComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> targetTrialsRefs(
    Expression<bool> Function($$TargetTrialsTableFilterComposer f) f,
  ) {
    final $$TargetTrialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetTrials,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetTrialsTableFilterComposer(
            $db: $db,
            $table: $db.targetTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> touchEventsRefs(
    Expression<bool> Function($$TouchEventsTableFilterComposer f) f,
  ) {
    final $$TouchEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.touchEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TouchEventsTableFilterComposer(
            $db: $db,
            $table: $db.touchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationSeconds => $composableBuilder(
    column: $table.plannedDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDurationMs => $composableBuilder(
    column: $table.actualDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calibrationSession => $composableBuilder(
    column: $table.calibrationSession,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get randomSeed => $composableBuilder(
    column: $table.randomSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get screenWidthLogical => $composableBuilder(
    column: $table.screenWidthLogical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get screenHeightLogical => $composableBuilder(
    column: $table.screenHeightLogical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerSubjectiveFeedback => $composableBuilder(
    column: $table.ownerSubjectiveFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get catches => $composableBuilder(
    column: $table.catches,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get misses => $composableBuilder(
    column: $table.misses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeouts => $composableBuilder(
    column: $table.timeouts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get medianReactionMs => $composableBuilder(
    column: $table.medianReactionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frustrationCount => $composableBuilder(
    column: $table.frustrationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatProfilesTableOrderingComposer get catId {
    final $$CatProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedDurationSeconds => $composableBuilder(
    column: $table.plannedDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDurationMs => $composableBuilder(
    column: $table.actualDurationMs,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SessionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get calibrationSession => $composableBuilder(
    column: $table.calibrationSession,
    builder: (column) => column,
  );

  GeneratedColumn<int> get randomSeed => $composableBuilder(
    column: $table.randomSeed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<double> get screenWidthLogical => $composableBuilder(
    column: $table.screenWidthLogical,
    builder: (column) => column,
  );

  GeneratedColumn<double> get screenHeightLogical => $composableBuilder(
    column: $table.screenHeightLogical,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<OwnerFeedback?, String>
  get ownerSubjectiveFeedback => $composableBuilder(
    column: $table.ownerSubjectiveFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<int> get catches =>
      $composableBuilder(column: $table.catches, builder: (column) => column);

  GeneratedColumn<int> get misses =>
      $composableBuilder(column: $table.misses, builder: (column) => column);

  GeneratedColumn<int> get timeouts =>
      $composableBuilder(column: $table.timeouts, builder: (column) => column);

  GeneratedColumn<int> get medianReactionMs => $composableBuilder(
    column: $table.medianReactionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frustrationCount => $composableBuilder(
    column: $table.frustrationCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  $$CatProfilesTableAnnotationComposer get catId {
    final $$CatProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> targetTrialsRefs<T extends Object>(
    Expression<T> Function($$TargetTrialsTableAnnotationComposer a) f,
  ) {
    final $$TargetTrialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetTrials,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetTrialsTableAnnotationComposer(
            $db: $db,
            $table: $db.targetTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> touchEventsRefs<T extends Object>(
    Expression<T> Function($$TouchEventsTableAnnotationComposer a) f,
  ) {
    final $$TouchEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.touchEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TouchEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.touchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool catId,
            bool targetTrialsRefs,
            bool touchEventsRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> catId = const Value.absent(),
                Value<SessionMode> mode = const Value.absent(),
                Value<DateTime> startedAtUtc = const Value.absent(),
                Value<DateTime?> endedAtUtc = const Value.absent(),
                Value<int> plannedDurationSeconds = const Value.absent(),
                Value<int?> actualDurationMs = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<bool> calibrationSession = const Value.absent(),
                Value<int> randomSeed = const Value.absent(),
                Value<String> algorithmVersion = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<double> screenWidthLogical = const Value.absent(),
                Value<double> screenHeightLogical = const Value.absent(),
                Value<OwnerFeedback?> ownerSubjectiveFeedback =
                    const Value.absent(),
                Value<int> catches = const Value.absent(),
                Value<int> misses = const Value.absent(),
                Value<int> timeouts = const Value.absent(),
                Value<int?> medianReactionMs = const Value.absent(),
                Value<int> frustrationCount = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                catId: catId,
                mode: mode,
                startedAtUtc: startedAtUtc,
                endedAtUtc: endedAtUtc,
                plannedDurationSeconds: plannedDurationSeconds,
                actualDurationMs: actualDurationMs,
                status: status,
                calibrationSession: calibrationSession,
                randomSeed: randomSeed,
                algorithmVersion: algorithmVersion,
                appVersion: appVersion,
                platform: platform,
                screenWidthLogical: screenWidthLogical,
                screenHeightLogical: screenHeightLogical,
                ownerSubjectiveFeedback: ownerSubjectiveFeedback,
                catches: catches,
                misses: misses,
                timeouts: timeouts,
                medianReactionMs: medianReactionMs,
                frustrationCount: frustrationCount,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> catId = const Value.absent(),
                required SessionMode mode,
                required DateTime startedAtUtc,
                Value<DateTime?> endedAtUtc = const Value.absent(),
                required int plannedDurationSeconds,
                Value<int?> actualDurationMs = const Value.absent(),
                required SessionStatus status,
                required bool calibrationSession,
                required int randomSeed,
                required String algorithmVersion,
                required String appVersion,
                required String platform,
                required double screenWidthLogical,
                required double screenHeightLogical,
                Value<OwnerFeedback?> ownerSubjectiveFeedback =
                    const Value.absent(),
                required int catches,
                required int misses,
                required int timeouts,
                Value<int?> medianReactionMs = const Value.absent(),
                required int frustrationCount,
                required DateTime createdAtUtc,
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                catId: catId,
                mode: mode,
                startedAtUtc: startedAtUtc,
                endedAtUtc: endedAtUtc,
                plannedDurationSeconds: plannedDurationSeconds,
                actualDurationMs: actualDurationMs,
                status: status,
                calibrationSession: calibrationSession,
                randomSeed: randomSeed,
                algorithmVersion: algorithmVersion,
                appVersion: appVersion,
                platform: platform,
                screenWidthLogical: screenWidthLogical,
                screenHeightLogical: screenHeightLogical,
                ownerSubjectiveFeedback: ownerSubjectiveFeedback,
                catches: catches,
                misses: misses,
                timeouts: timeouts,
                medianReactionMs: medianReactionMs,
                frustrationCount: frustrationCount,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                catId = false,
                targetTrialsRefs = false,
                touchEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (targetTrialsRefs) db.targetTrials,
                    if (touchEventsRefs) db.touchEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (catId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.catId,
                                    referencedTable: $$SessionsTableReferences
                                        ._catIdTable(db),
                                    referencedColumn: $$SessionsTableReferences
                                        ._catIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (targetTrialsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          TargetTrial
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._targetTrialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).targetTrialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (touchEventsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          TouchEvent
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._touchEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).touchEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool catId,
        bool targetTrialsRefs,
        bool touchEventsRefs,
      })
    >;
typedef $$TargetTrialsTableCreateCompanionBuilder =
    TargetTrialsCompanion Function({
      required String id,
      required String sessionId,
      required int trialIndex,
      required PreyType targetType,
      required MovementStyle movementStyle,
      required SpeedLevel speedLevel,
      required SizeLevel sizeLevel,
      required SoundMode soundMode,
      required SpawnZone spawnZone,
      required DateTime spawnedAtUtc,
      required DateTime becameTouchableAtUtc,
      Value<DateTime?> endedAtUtc,
      required double spawnXNormalised,
      required double spawnYNormalised,
      required int targetPathSeed,
      required bool success,
      Value<DateTime?> firstSuccessfulTouchAtUtc,
      Value<int?> reactionTimeMs,
      required int missCount,
      required bool timeout,
      Value<CueType?> cueType,
      Value<CueType?> praiseCueType,
      required bool rewardReminderShown,
      required int frustrationSeverity,
      required Set<FrustrationFlag> frustrationFlags,
      required double trialReward,
      required String algorithmVersion,
      Value<int> rowid,
    });
typedef $$TargetTrialsTableUpdateCompanionBuilder =
    TargetTrialsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> trialIndex,
      Value<PreyType> targetType,
      Value<MovementStyle> movementStyle,
      Value<SpeedLevel> speedLevel,
      Value<SizeLevel> sizeLevel,
      Value<SoundMode> soundMode,
      Value<SpawnZone> spawnZone,
      Value<DateTime> spawnedAtUtc,
      Value<DateTime> becameTouchableAtUtc,
      Value<DateTime?> endedAtUtc,
      Value<double> spawnXNormalised,
      Value<double> spawnYNormalised,
      Value<int> targetPathSeed,
      Value<bool> success,
      Value<DateTime?> firstSuccessfulTouchAtUtc,
      Value<int?> reactionTimeMs,
      Value<int> missCount,
      Value<bool> timeout,
      Value<CueType?> cueType,
      Value<CueType?> praiseCueType,
      Value<bool> rewardReminderShown,
      Value<int> frustrationSeverity,
      Value<Set<FrustrationFlag>> frustrationFlags,
      Value<double> trialReward,
      Value<String> algorithmVersion,
      Value<int> rowid,
    });

final class $$TargetTrialsTableReferences
    extends BaseReferences<_$AppDatabase, $TargetTrialsTable, TargetTrial> {
  $$TargetTrialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('target_trials__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TouchEventsTable, List<TouchEvent>>
  _touchEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.touchEvents,
    aliasName: 'target_trials__id__touch_events__trial_id',
  );

  $$TouchEventsTableProcessedTableManager get touchEventsRefs {
    final manager = $$TouchEventsTableTableManager(
      $_db,
      $_db.touchEvents,
    ).filter((f) => f.trialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_touchEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TargetTrialsTableFilterComposer
    extends Composer<_$AppDatabase, $TargetTrialsTable> {
  $$TargetTrialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trialIndex => $composableBuilder(
    column: $table.trialIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PreyType, PreyType, String> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<MovementStyle, MovementStyle, String>
  get movementStyle => $composableBuilder(
    column: $table.movementStyle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SpeedLevel, SpeedLevel, String>
  get speedLevel => $composableBuilder(
    column: $table.speedLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SizeLevel, SizeLevel, String> get sizeLevel =>
      $composableBuilder(
        column: $table.sizeLevel,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SoundMode, SoundMode, String> get soundMode =>
      $composableBuilder(
        column: $table.soundMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SpawnZone, SpawnZone, String> get spawnZone =>
      $composableBuilder(
        column: $table.spawnZone,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get spawnedAtUtc => $composableBuilder(
    column: $table.spawnedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get becameTouchableAtUtc => $composableBuilder(
    column: $table.becameTouchableAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spawnXNormalised => $composableBuilder(
    column: $table.spawnXNormalised,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spawnYNormalised => $composableBuilder(
    column: $table.spawnYNormalised,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPathSeed => $composableBuilder(
    column: $table.targetPathSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSuccessfulTouchAtUtc => $composableBuilder(
    column: $table.firstSuccessfulTouchAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reactionTimeMs => $composableBuilder(
    column: $table.reactionTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missCount => $composableBuilder(
    column: $table.missCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get timeout => $composableBuilder(
    column: $table.timeout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CueType?, CueType, String> get cueType =>
      $composableBuilder(
        column: $table.cueType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<CueType?, CueType, String> get praiseCueType =>
      $composableBuilder(
        column: $table.praiseCueType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get rewardReminderShown => $composableBuilder(
    column: $table.rewardReminderShown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frustrationSeverity => $composableBuilder(
    column: $table.frustrationSeverity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Set<FrustrationFlag>,
    Set<FrustrationFlag>,
    String
  >
  get frustrationFlags => $composableBuilder(
    column: $table.frustrationFlags,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get trialReward => $composableBuilder(
    column: $table.trialReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> touchEventsRefs(
    Expression<bool> Function($$TouchEventsTableFilterComposer f) f,
  ) {
    final $$TouchEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.touchEvents,
      getReferencedColumn: (t) => t.trialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TouchEventsTableFilterComposer(
            $db: $db,
            $table: $db.touchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TargetTrialsTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetTrialsTable> {
  $$TargetTrialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trialIndex => $composableBuilder(
    column: $table.trialIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementStyle => $composableBuilder(
    column: $table.movementStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speedLevel => $composableBuilder(
    column: $table.speedLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sizeLevel => $composableBuilder(
    column: $table.sizeLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundMode => $composableBuilder(
    column: $table.soundMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spawnZone => $composableBuilder(
    column: $table.spawnZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spawnedAtUtc => $composableBuilder(
    column: $table.spawnedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get becameTouchableAtUtc => $composableBuilder(
    column: $table.becameTouchableAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spawnXNormalised => $composableBuilder(
    column: $table.spawnXNormalised,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spawnYNormalised => $composableBuilder(
    column: $table.spawnYNormalised,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPathSeed => $composableBuilder(
    column: $table.targetPathSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSuccessfulTouchAtUtc => $composableBuilder(
    column: $table.firstSuccessfulTouchAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reactionTimeMs => $composableBuilder(
    column: $table.reactionTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missCount => $composableBuilder(
    column: $table.missCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get timeout => $composableBuilder(
    column: $table.timeout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueType => $composableBuilder(
    column: $table.cueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get praiseCueType => $composableBuilder(
    column: $table.praiseCueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rewardReminderShown => $composableBuilder(
    column: $table.rewardReminderShown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frustrationSeverity => $composableBuilder(
    column: $table.frustrationSeverity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frustrationFlags => $composableBuilder(
    column: $table.frustrationFlags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trialReward => $composableBuilder(
    column: $table.trialReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetTrialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetTrialsTable> {
  $$TargetTrialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get trialIndex => $composableBuilder(
    column: $table.trialIndex,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PreyType, String> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<MovementStyle, String> get movementStyle =>
      $composableBuilder(
        column: $table.movementStyle,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SpeedLevel, String> get speedLevel =>
      $composableBuilder(
        column: $table.speedLevel,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SizeLevel, String> get sizeLevel =>
      $composableBuilder(column: $table.sizeLevel, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SoundMode, String> get soundMode =>
      $composableBuilder(column: $table.soundMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpawnZone, String> get spawnZone =>
      $composableBuilder(column: $table.spawnZone, builder: (column) => column);

  GeneratedColumn<DateTime> get spawnedAtUtc => $composableBuilder(
    column: $table.spawnedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get becameTouchableAtUtc => $composableBuilder(
    column: $table.becameTouchableAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endedAtUtc => $composableBuilder(
    column: $table.endedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spawnXNormalised => $composableBuilder(
    column: $table.spawnXNormalised,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spawnYNormalised => $composableBuilder(
    column: $table.spawnYNormalised,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetPathSeed => $composableBuilder(
    column: $table.targetPathSeed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSuccessfulTouchAtUtc => $composableBuilder(
    column: $table.firstSuccessfulTouchAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reactionTimeMs => $composableBuilder(
    column: $table.reactionTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missCount =>
      $composableBuilder(column: $table.missCount, builder: (column) => column);

  GeneratedColumn<bool> get timeout =>
      $composableBuilder(column: $table.timeout, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CueType?, String> get cueType =>
      $composableBuilder(column: $table.cueType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CueType?, String> get praiseCueType =>
      $composableBuilder(
        column: $table.praiseCueType,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get rewardReminderShown => $composableBuilder(
    column: $table.rewardReminderShown,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frustrationSeverity => $composableBuilder(
    column: $table.frustrationSeverity,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Set<FrustrationFlag>, String>
  get frustrationFlags => $composableBuilder(
    column: $table.frustrationFlags,
    builder: (column) => column,
  );

  GeneratedColumn<double> get trialReward => $composableBuilder(
    column: $table.trialReward,
    builder: (column) => column,
  );

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> touchEventsRefs<T extends Object>(
    Expression<T> Function($$TouchEventsTableAnnotationComposer a) f,
  ) {
    final $$TouchEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.touchEvents,
      getReferencedColumn: (t) => t.trialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TouchEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.touchEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TargetTrialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetTrialsTable,
          TargetTrial,
          $$TargetTrialsTableFilterComposer,
          $$TargetTrialsTableOrderingComposer,
          $$TargetTrialsTableAnnotationComposer,
          $$TargetTrialsTableCreateCompanionBuilder,
          $$TargetTrialsTableUpdateCompanionBuilder,
          (TargetTrial, $$TargetTrialsTableReferences),
          TargetTrial,
          PrefetchHooks Function({bool sessionId, bool touchEventsRefs})
        > {
  $$TargetTrialsTableTableManager(_$AppDatabase db, $TargetTrialsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetTrialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetTrialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetTrialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> trialIndex = const Value.absent(),
                Value<PreyType> targetType = const Value.absent(),
                Value<MovementStyle> movementStyle = const Value.absent(),
                Value<SpeedLevel> speedLevel = const Value.absent(),
                Value<SizeLevel> sizeLevel = const Value.absent(),
                Value<SoundMode> soundMode = const Value.absent(),
                Value<SpawnZone> spawnZone = const Value.absent(),
                Value<DateTime> spawnedAtUtc = const Value.absent(),
                Value<DateTime> becameTouchableAtUtc = const Value.absent(),
                Value<DateTime?> endedAtUtc = const Value.absent(),
                Value<double> spawnXNormalised = const Value.absent(),
                Value<double> spawnYNormalised = const Value.absent(),
                Value<int> targetPathSeed = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<DateTime?> firstSuccessfulTouchAtUtc =
                    const Value.absent(),
                Value<int?> reactionTimeMs = const Value.absent(),
                Value<int> missCount = const Value.absent(),
                Value<bool> timeout = const Value.absent(),
                Value<CueType?> cueType = const Value.absent(),
                Value<CueType?> praiseCueType = const Value.absent(),
                Value<bool> rewardReminderShown = const Value.absent(),
                Value<int> frustrationSeverity = const Value.absent(),
                Value<Set<FrustrationFlag>> frustrationFlags =
                    const Value.absent(),
                Value<double> trialReward = const Value.absent(),
                Value<String> algorithmVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TargetTrialsCompanion(
                id: id,
                sessionId: sessionId,
                trialIndex: trialIndex,
                targetType: targetType,
                movementStyle: movementStyle,
                speedLevel: speedLevel,
                sizeLevel: sizeLevel,
                soundMode: soundMode,
                spawnZone: spawnZone,
                spawnedAtUtc: spawnedAtUtc,
                becameTouchableAtUtc: becameTouchableAtUtc,
                endedAtUtc: endedAtUtc,
                spawnXNormalised: spawnXNormalised,
                spawnYNormalised: spawnYNormalised,
                targetPathSeed: targetPathSeed,
                success: success,
                firstSuccessfulTouchAtUtc: firstSuccessfulTouchAtUtc,
                reactionTimeMs: reactionTimeMs,
                missCount: missCount,
                timeout: timeout,
                cueType: cueType,
                praiseCueType: praiseCueType,
                rewardReminderShown: rewardReminderShown,
                frustrationSeverity: frustrationSeverity,
                frustrationFlags: frustrationFlags,
                trialReward: trialReward,
                algorithmVersion: algorithmVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int trialIndex,
                required PreyType targetType,
                required MovementStyle movementStyle,
                required SpeedLevel speedLevel,
                required SizeLevel sizeLevel,
                required SoundMode soundMode,
                required SpawnZone spawnZone,
                required DateTime spawnedAtUtc,
                required DateTime becameTouchableAtUtc,
                Value<DateTime?> endedAtUtc = const Value.absent(),
                required double spawnXNormalised,
                required double spawnYNormalised,
                required int targetPathSeed,
                required bool success,
                Value<DateTime?> firstSuccessfulTouchAtUtc =
                    const Value.absent(),
                Value<int?> reactionTimeMs = const Value.absent(),
                required int missCount,
                required bool timeout,
                Value<CueType?> cueType = const Value.absent(),
                Value<CueType?> praiseCueType = const Value.absent(),
                required bool rewardReminderShown,
                required int frustrationSeverity,
                required Set<FrustrationFlag> frustrationFlags,
                required double trialReward,
                required String algorithmVersion,
                Value<int> rowid = const Value.absent(),
              }) => TargetTrialsCompanion.insert(
                id: id,
                sessionId: sessionId,
                trialIndex: trialIndex,
                targetType: targetType,
                movementStyle: movementStyle,
                speedLevel: speedLevel,
                sizeLevel: sizeLevel,
                soundMode: soundMode,
                spawnZone: spawnZone,
                spawnedAtUtc: spawnedAtUtc,
                becameTouchableAtUtc: becameTouchableAtUtc,
                endedAtUtc: endedAtUtc,
                spawnXNormalised: spawnXNormalised,
                spawnYNormalised: spawnYNormalised,
                targetPathSeed: targetPathSeed,
                success: success,
                firstSuccessfulTouchAtUtc: firstSuccessfulTouchAtUtc,
                reactionTimeMs: reactionTimeMs,
                missCount: missCount,
                timeout: timeout,
                cueType: cueType,
                praiseCueType: praiseCueType,
                rewardReminderShown: rewardReminderShown,
                frustrationSeverity: frustrationSeverity,
                frustrationFlags: frustrationFlags,
                trialReward: trialReward,
                algorithmVersion: algorithmVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TargetTrialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, touchEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (touchEventsRefs) db.touchEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$TargetTrialsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$TargetTrialsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (touchEventsRefs)
                        await $_getPrefetchedData<
                          TargetTrial,
                          $TargetTrialsTable,
                          TouchEvent
                        >(
                          currentTable: table,
                          referencedTable: $$TargetTrialsTableReferences
                              ._touchEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TargetTrialsTableReferences(
                                db,
                                table,
                                p0,
                              ).touchEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trialId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TargetTrialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetTrialsTable,
      TargetTrial,
      $$TargetTrialsTableFilterComposer,
      $$TargetTrialsTableOrderingComposer,
      $$TargetTrialsTableAnnotationComposer,
      $$TargetTrialsTableCreateCompanionBuilder,
      $$TargetTrialsTableUpdateCompanionBuilder,
      (TargetTrial, $$TargetTrialsTableReferences),
      TargetTrial,
      PrefetchHooks Function({bool sessionId, bool touchEventsRefs})
    >;
typedef $$TouchEventsTableCreateCompanionBuilder =
    TouchEventsCompanion Function({
      required String id,
      required String sessionId,
      Value<String?> trialId,
      required int pointerId,
      required int logicalInteractionId,
      required DateTime occurredAtUtc,
      required double xNormalised,
      required double yNormalised,
      required TouchClassification classification,
      required bool deduplicated,
      Value<double?> distanceFromTarget,
      required DateTime createdAtUtc,
      Value<int> rowid,
    });
typedef $$TouchEventsTableUpdateCompanionBuilder =
    TouchEventsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String?> trialId,
      Value<int> pointerId,
      Value<int> logicalInteractionId,
      Value<DateTime> occurredAtUtc,
      Value<double> xNormalised,
      Value<double> yNormalised,
      Value<TouchClassification> classification,
      Value<bool> deduplicated,
      Value<double?> distanceFromTarget,
      Value<DateTime> createdAtUtc,
      Value<int> rowid,
    });

final class $$TouchEventsTableReferences
    extends BaseReferences<_$AppDatabase, $TouchEventsTable, TouchEvent> {
  $$TouchEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('touch_events__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TargetTrialsTable _trialIdTable(_$AppDatabase db) =>
      db.targetTrials.createAlias('touch_events__trial_id__target_trials__id');

  $$TargetTrialsTableProcessedTableManager? get trialId {
    final $_column = $_itemColumn<String>('trial_id');
    if ($_column == null) return null;
    final manager = $$TargetTrialsTableTableManager(
      $_db,
      $_db.targetTrials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TouchEventsTableFilterComposer
    extends Composer<_$AppDatabase, $TouchEventsTable> {
  $$TouchEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointerId => $composableBuilder(
    column: $table.pointerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get logicalInteractionId => $composableBuilder(
    column: $table.logicalInteractionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAtUtc => $composableBuilder(
    column: $table.occurredAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get xNormalised => $composableBuilder(
    column: $table.xNormalised,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yNormalised => $composableBuilder(
    column: $table.yNormalised,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    TouchClassification,
    TouchClassification,
    String
  >
  get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get deduplicated => $composableBuilder(
    column: $table.deduplicated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceFromTarget => $composableBuilder(
    column: $table.distanceFromTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TargetTrialsTableFilterComposer get trialId {
    final $$TargetTrialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trialId,
      referencedTable: $db.targetTrials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetTrialsTableFilterComposer(
            $db: $db,
            $table: $db.targetTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TouchEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $TouchEventsTable> {
  $$TouchEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointerId => $composableBuilder(
    column: $table.pointerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get logicalInteractionId => $composableBuilder(
    column: $table.logicalInteractionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAtUtc => $composableBuilder(
    column: $table.occurredAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get xNormalised => $composableBuilder(
    column: $table.xNormalised,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yNormalised => $composableBuilder(
    column: $table.yNormalised,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deduplicated => $composableBuilder(
    column: $table.deduplicated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceFromTarget => $composableBuilder(
    column: $table.distanceFromTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TargetTrialsTableOrderingComposer get trialId {
    final $$TargetTrialsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trialId,
      referencedTable: $db.targetTrials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetTrialsTableOrderingComposer(
            $db: $db,
            $table: $db.targetTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TouchEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TouchEventsTable> {
  $$TouchEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pointerId =>
      $composableBuilder(column: $table.pointerId, builder: (column) => column);

  GeneratedColumn<int> get logicalInteractionId => $composableBuilder(
    column: $table.logicalInteractionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAtUtc => $composableBuilder(
    column: $table.occurredAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<double> get xNormalised => $composableBuilder(
    column: $table.xNormalised,
    builder: (column) => column,
  );

  GeneratedColumn<double> get yNormalised => $composableBuilder(
    column: $table.yNormalised,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TouchClassification, String>
  get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deduplicated => $composableBuilder(
    column: $table.deduplicated,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceFromTarget => $composableBuilder(
    column: $table.distanceFromTarget,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TargetTrialsTableAnnotationComposer get trialId {
    final $$TargetTrialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trialId,
      referencedTable: $db.targetTrials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetTrialsTableAnnotationComposer(
            $db: $db,
            $table: $db.targetTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TouchEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TouchEventsTable,
          TouchEvent,
          $$TouchEventsTableFilterComposer,
          $$TouchEventsTableOrderingComposer,
          $$TouchEventsTableAnnotationComposer,
          $$TouchEventsTableCreateCompanionBuilder,
          $$TouchEventsTableUpdateCompanionBuilder,
          (TouchEvent, $$TouchEventsTableReferences),
          TouchEvent,
          PrefetchHooks Function({bool sessionId, bool trialId})
        > {
  $$TouchEventsTableTableManager(_$AppDatabase db, $TouchEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TouchEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TouchEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TouchEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String?> trialId = const Value.absent(),
                Value<int> pointerId = const Value.absent(),
                Value<int> logicalInteractionId = const Value.absent(),
                Value<DateTime> occurredAtUtc = const Value.absent(),
                Value<double> xNormalised = const Value.absent(),
                Value<double> yNormalised = const Value.absent(),
                Value<TouchClassification> classification =
                    const Value.absent(),
                Value<bool> deduplicated = const Value.absent(),
                Value<double?> distanceFromTarget = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TouchEventsCompanion(
                id: id,
                sessionId: sessionId,
                trialId: trialId,
                pointerId: pointerId,
                logicalInteractionId: logicalInteractionId,
                occurredAtUtc: occurredAtUtc,
                xNormalised: xNormalised,
                yNormalised: yNormalised,
                classification: classification,
                deduplicated: deduplicated,
                distanceFromTarget: distanceFromTarget,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                Value<String?> trialId = const Value.absent(),
                required int pointerId,
                required int logicalInteractionId,
                required DateTime occurredAtUtc,
                required double xNormalised,
                required double yNormalised,
                required TouchClassification classification,
                required bool deduplicated,
                Value<double?> distanceFromTarget = const Value.absent(),
                required DateTime createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => TouchEventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                trialId: trialId,
                pointerId: pointerId,
                logicalInteractionId: logicalInteractionId,
                occurredAtUtc: occurredAtUtc,
                xNormalised: xNormalised,
                yNormalised: yNormalised,
                classification: classification,
                deduplicated: deduplicated,
                distanceFromTarget: distanceFromTarget,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TouchEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, trialId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$TouchEventsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$TouchEventsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (trialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trialId,
                                referencedTable: $$TouchEventsTableReferences
                                    ._trialIdTable(db),
                                referencedColumn: $$TouchEventsTableReferences
                                    ._trialIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TouchEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TouchEventsTable,
      TouchEvent,
      $$TouchEventsTableFilterComposer,
      $$TouchEventsTableOrderingComposer,
      $$TouchEventsTableAnnotationComposer,
      $$TouchEventsTableCreateCompanionBuilder,
      $$TouchEventsTableUpdateCompanionBuilder,
      (TouchEvent, $$TouchEventsTableReferences),
      TouchEvent,
      PrefetchHooks Function({bool sessionId, bool trialId})
    >;
typedef $$PreferenceStatsTableCreateCompanionBuilder =
    PreferenceStatsCompanion Function({
      required String id,
      required String catId,
      required FactorType factorType,
      required String factorValue,
      required double impressions,
      required double successes,
      required double timeouts,
      required double totalMisses,
      required double frustrationCount,
      Value<double?> reactionTimeEwmaMs,
      required double cumulativeReward,
      Value<DateTime?> lastUsedAtUtc,
      required DateTime updatedAtUtc,
      required String algorithmVersion,
      Value<int> rowid,
    });
typedef $$PreferenceStatsTableUpdateCompanionBuilder =
    PreferenceStatsCompanion Function({
      Value<String> id,
      Value<String> catId,
      Value<FactorType> factorType,
      Value<String> factorValue,
      Value<double> impressions,
      Value<double> successes,
      Value<double> timeouts,
      Value<double> totalMisses,
      Value<double> frustrationCount,
      Value<double?> reactionTimeEwmaMs,
      Value<double> cumulativeReward,
      Value<DateTime?> lastUsedAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<String> algorithmVersion,
      Value<int> rowid,
    });

final class $$PreferenceStatsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PreferenceStatsTable, PreferenceStat> {
  $$PreferenceStatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CatProfilesTable _catIdTable(_$AppDatabase db) =>
      db.catProfiles.createAlias('preference_stats__cat_id__cat_profiles__id');

  $$CatProfilesTableProcessedTableManager get catId {
    final $_column = $_itemColumn<String>('cat_id')!;

    final manager = $$CatProfilesTableTableManager(
      $_db,
      $_db.catProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreferenceStatsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceStatsTable> {
  $$PreferenceStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FactorType, FactorType, String>
  get factorType => $composableBuilder(
    column: $table.factorType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get factorValue => $composableBuilder(
    column: $table.factorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get successes => $composableBuilder(
    column: $table.successes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get timeouts => $composableBuilder(
    column: $table.timeouts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalMisses => $composableBuilder(
    column: $table.totalMisses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get frustrationCount => $composableBuilder(
    column: $table.frustrationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reactionTimeEwmaMs => $composableBuilder(
    column: $table.reactionTimeEwmaMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cumulativeReward => $composableBuilder(
    column: $table.cumulativeReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAtUtc => $composableBuilder(
    column: $table.lastUsedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$CatProfilesTableFilterComposer get catId {
    final $$CatProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableFilterComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreferenceStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceStatsTable> {
  $$PreferenceStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factorType => $composableBuilder(
    column: $table.factorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factorValue => $composableBuilder(
    column: $table.factorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get successes => $composableBuilder(
    column: $table.successes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get timeouts => $composableBuilder(
    column: $table.timeouts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalMisses => $composableBuilder(
    column: $table.totalMisses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get frustrationCount => $composableBuilder(
    column: $table.frustrationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reactionTimeEwmaMs => $composableBuilder(
    column: $table.reactionTimeEwmaMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cumulativeReward => $composableBuilder(
    column: $table.cumulativeReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAtUtc => $composableBuilder(
    column: $table.lastUsedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatProfilesTableOrderingComposer get catId {
    final $$CatProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreferenceStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceStatsTable> {
  $$PreferenceStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FactorType, String> get factorType =>
      $composableBuilder(
        column: $table.factorType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get factorValue => $composableBuilder(
    column: $table.factorValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get successes =>
      $composableBuilder(column: $table.successes, builder: (column) => column);

  GeneratedColumn<double> get timeouts =>
      $composableBuilder(column: $table.timeouts, builder: (column) => column);

  GeneratedColumn<double> get totalMisses => $composableBuilder(
    column: $table.totalMisses,
    builder: (column) => column,
  );

  GeneratedColumn<double> get frustrationCount => $composableBuilder(
    column: $table.frustrationCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get reactionTimeEwmaMs => $composableBuilder(
    column: $table.reactionTimeEwmaMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cumulativeReward => $composableBuilder(
    column: $table.cumulativeReward,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAtUtc => $composableBuilder(
    column: $table.lastUsedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => column,
  );

  $$CatProfilesTableAnnotationComposer get catId {
    final $$CatProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreferenceStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceStatsTable,
          PreferenceStat,
          $$PreferenceStatsTableFilterComposer,
          $$PreferenceStatsTableOrderingComposer,
          $$PreferenceStatsTableAnnotationComposer,
          $$PreferenceStatsTableCreateCompanionBuilder,
          $$PreferenceStatsTableUpdateCompanionBuilder,
          (PreferenceStat, $$PreferenceStatsTableReferences),
          PreferenceStat,
          PrefetchHooks Function({bool catId})
        > {
  $$PreferenceStatsTableTableManager(
    _$AppDatabase db,
    $PreferenceStatsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> catId = const Value.absent(),
                Value<FactorType> factorType = const Value.absent(),
                Value<String> factorValue = const Value.absent(),
                Value<double> impressions = const Value.absent(),
                Value<double> successes = const Value.absent(),
                Value<double> timeouts = const Value.absent(),
                Value<double> totalMisses = const Value.absent(),
                Value<double> frustrationCount = const Value.absent(),
                Value<double?> reactionTimeEwmaMs = const Value.absent(),
                Value<double> cumulativeReward = const Value.absent(),
                Value<DateTime?> lastUsedAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<String> algorithmVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferenceStatsCompanion(
                id: id,
                catId: catId,
                factorType: factorType,
                factorValue: factorValue,
                impressions: impressions,
                successes: successes,
                timeouts: timeouts,
                totalMisses: totalMisses,
                frustrationCount: frustrationCount,
                reactionTimeEwmaMs: reactionTimeEwmaMs,
                cumulativeReward: cumulativeReward,
                lastUsedAtUtc: lastUsedAtUtc,
                updatedAtUtc: updatedAtUtc,
                algorithmVersion: algorithmVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String catId,
                required FactorType factorType,
                required String factorValue,
                required double impressions,
                required double successes,
                required double timeouts,
                required double totalMisses,
                required double frustrationCount,
                Value<double?> reactionTimeEwmaMs = const Value.absent(),
                required double cumulativeReward,
                Value<DateTime?> lastUsedAtUtc = const Value.absent(),
                required DateTime updatedAtUtc,
                required String algorithmVersion,
                Value<int> rowid = const Value.absent(),
              }) => PreferenceStatsCompanion.insert(
                id: id,
                catId: catId,
                factorType: factorType,
                factorValue: factorValue,
                impressions: impressions,
                successes: successes,
                timeouts: timeouts,
                totalMisses: totalMisses,
                frustrationCount: frustrationCount,
                reactionTimeEwmaMs: reactionTimeEwmaMs,
                cumulativeReward: cumulativeReward,
                lastUsedAtUtc: lastUsedAtUtc,
                updatedAtUtc: updatedAtUtc,
                algorithmVersion: algorithmVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PreferenceStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable:
                                    $$PreferenceStatsTableReferences
                                        ._catIdTable(db),
                                referencedColumn:
                                    $$PreferenceStatsTableReferences
                                        ._catIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PreferenceStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceStatsTable,
      PreferenceStat,
      $$PreferenceStatsTableFilterComposer,
      $$PreferenceStatsTableOrderingComposer,
      $$PreferenceStatsTableAnnotationComposer,
      $$PreferenceStatsTableCreateCompanionBuilder,
      $$PreferenceStatsTableUpdateCompanionBuilder,
      (PreferenceStat, $$PreferenceStatsTableReferences),
      PreferenceStat,
      PrefetchHooks Function({bool catId})
    >;
typedef $$CueProgressTableCreateCompanionBuilder =
    CueProgressCompanion Function({
      required String id,
      required String catId,
      required CueType cueType,
      required int exposures,
      required int successfulResponses,
      Value<double?> reactionTimeEwmaMs,
      Value<DateTime?> lastUsedAtUtc,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$CueProgressTableUpdateCompanionBuilder =
    CueProgressCompanion Function({
      Value<String> id,
      Value<String> catId,
      Value<CueType> cueType,
      Value<int> exposures,
      Value<int> successfulResponses,
      Value<double?> reactionTimeEwmaMs,
      Value<DateTime?> lastUsedAtUtc,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

final class $$CueProgressTableReferences
    extends BaseReferences<_$AppDatabase, $CueProgressTable, CueProgressData> {
  $$CueProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CatProfilesTable _catIdTable(_$AppDatabase db) =>
      db.catProfiles.createAlias('cue_progress__cat_id__cat_profiles__id');

  $$CatProfilesTableProcessedTableManager get catId {
    final $_column = $_itemColumn<String>('cat_id')!;

    final manager = $$CatProfilesTableTableManager(
      $_db,
      $_db.catProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CueProgressTableFilterComposer
    extends Composer<_$AppDatabase, $CueProgressTable> {
  $$CueProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CueType, CueType, String> get cueType =>
      $composableBuilder(
        column: $table.cueType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get exposures => $composableBuilder(
    column: $table.exposures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successfulResponses => $composableBuilder(
    column: $table.successfulResponses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reactionTimeEwmaMs => $composableBuilder(
    column: $table.reactionTimeEwmaMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAtUtc => $composableBuilder(
    column: $table.lastUsedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$CatProfilesTableFilterComposer get catId {
    final $$CatProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableFilterComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CueProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $CueProgressTable> {
  $$CueProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueType => $composableBuilder(
    column: $table.cueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exposures => $composableBuilder(
    column: $table.exposures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successfulResponses => $composableBuilder(
    column: $table.successfulResponses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reactionTimeEwmaMs => $composableBuilder(
    column: $table.reactionTimeEwmaMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAtUtc => $composableBuilder(
    column: $table.lastUsedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatProfilesTableOrderingComposer get catId {
    final $$CatProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CueProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $CueProgressTable> {
  $$CueProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CueType, String> get cueType =>
      $composableBuilder(column: $table.cueType, builder: (column) => column);

  GeneratedColumn<int> get exposures =>
      $composableBuilder(column: $table.exposures, builder: (column) => column);

  GeneratedColumn<int> get successfulResponses => $composableBuilder(
    column: $table.successfulResponses,
    builder: (column) => column,
  );

  GeneratedColumn<double> get reactionTimeEwmaMs => $composableBuilder(
    column: $table.reactionTimeEwmaMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAtUtc => $composableBuilder(
    column: $table.lastUsedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  $$CatProfilesTableAnnotationComposer get catId {
    final $$CatProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.catProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.catProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CueProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CueProgressTable,
          CueProgressData,
          $$CueProgressTableFilterComposer,
          $$CueProgressTableOrderingComposer,
          $$CueProgressTableAnnotationComposer,
          $$CueProgressTableCreateCompanionBuilder,
          $$CueProgressTableUpdateCompanionBuilder,
          (CueProgressData, $$CueProgressTableReferences),
          CueProgressData,
          PrefetchHooks Function({bool catId})
        > {
  $$CueProgressTableTableManager(_$AppDatabase db, $CueProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CueProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CueProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CueProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> catId = const Value.absent(),
                Value<CueType> cueType = const Value.absent(),
                Value<int> exposures = const Value.absent(),
                Value<int> successfulResponses = const Value.absent(),
                Value<double?> reactionTimeEwmaMs = const Value.absent(),
                Value<DateTime?> lastUsedAtUtc = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CueProgressCompanion(
                id: id,
                catId: catId,
                cueType: cueType,
                exposures: exposures,
                successfulResponses: successfulResponses,
                reactionTimeEwmaMs: reactionTimeEwmaMs,
                lastUsedAtUtc: lastUsedAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String catId,
                required CueType cueType,
                required int exposures,
                required int successfulResponses,
                Value<double?> reactionTimeEwmaMs = const Value.absent(),
                Value<DateTime?> lastUsedAtUtc = const Value.absent(),
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => CueProgressCompanion.insert(
                id: id,
                catId: catId,
                cueType: cueType,
                exposures: exposures,
                successfulResponses: successfulResponses,
                reactionTimeEwmaMs: reactionTimeEwmaMs,
                lastUsedAtUtc: lastUsedAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CueProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable: $$CueProgressTableReferences
                                    ._catIdTable(db),
                                referencedColumn: $$CueProgressTableReferences
                                    ._catIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CueProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CueProgressTable,
      CueProgressData,
      $$CueProgressTableFilterComposer,
      $$CueProgressTableOrderingComposer,
      $$CueProgressTableAnnotationComposer,
      $$CueProgressTableCreateCompanionBuilder,
      $$CueProgressTableUpdateCompanionBuilder,
      (CueProgressData, $$CueProgressTableReferences),
      CueProgressData,
      PrefetchHooks Function({bool catId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> defaultSessionDurationSeconds,
      Value<bool> soundEnabled,
      Value<RewardSchedule> rewardSchedule,
      Value<int> maxRewardReminders,
      Value<String?> ownerPinHash,
      Value<String?> ownerPinSalt,
      Value<bool> onboardingComplete,
      Value<int> privacyVersionAccepted,
      Value<String?> preferredLocale,
      Value<bool> reduceMotion,
      Value<bool> highContrastMode,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> defaultSessionDurationSeconds,
      Value<bool> soundEnabled,
      Value<RewardSchedule> rewardSchedule,
      Value<int> maxRewardReminders,
      Value<String?> ownerPinHash,
      Value<String?> ownerPinSalt,
      Value<bool> onboardingComplete,
      Value<int> privacyVersionAccepted,
      Value<String?> preferredLocale,
      Value<bool> reduceMotion,
      Value<bool> highContrastMode,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultSessionDurationSeconds => $composableBuilder(
    column: $table.defaultSessionDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RewardSchedule, RewardSchedule, String>
  get rewardSchedule => $composableBuilder(
    column: $table.rewardSchedule,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get maxRewardReminders => $composableBuilder(
    column: $table.maxRewardReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPinHash => $composableBuilder(
    column: $table.ownerPinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPinSalt => $composableBuilder(
    column: $table.ownerPinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get privacyVersionAccepted => $composableBuilder(
    column: $table.privacyVersionAccepted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get highContrastMode => $composableBuilder(
    column: $table.highContrastMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultSessionDurationSeconds => $composableBuilder(
    column: $table.defaultSessionDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardSchedule => $composableBuilder(
    column: $table.rewardSchedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRewardReminders => $composableBuilder(
    column: $table.maxRewardReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPinHash => $composableBuilder(
    column: $table.ownerPinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPinSalt => $composableBuilder(
    column: $table.ownerPinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get privacyVersionAccepted => $composableBuilder(
    column: $table.privacyVersionAccepted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get highContrastMode => $composableBuilder(
    column: $table.highContrastMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get defaultSessionDurationSeconds => $composableBuilder(
    column: $table.defaultSessionDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RewardSchedule, String> get rewardSchedule =>
      $composableBuilder(
        column: $table.rewardSchedule,
        builder: (column) => column,
      );

  GeneratedColumn<int> get maxRewardReminders => $composableBuilder(
    column: $table.maxRewardReminders,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerPinHash => $composableBuilder(
    column: $table.ownerPinHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerPinSalt => $composableBuilder(
    column: $table.ownerPinSalt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get privacyVersionAccepted => $composableBuilder(
    column: $table.privacyVersionAccepted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get highContrastMode => $composableBuilder(
    column: $table.highContrastMode,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> defaultSessionDurationSeconds = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<RewardSchedule> rewardSchedule = const Value.absent(),
                Value<int> maxRewardReminders = const Value.absent(),
                Value<String?> ownerPinHash = const Value.absent(),
                Value<String?> ownerPinSalt = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<int> privacyVersionAccepted = const Value.absent(),
                Value<String?> preferredLocale = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> highContrastMode = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                defaultSessionDurationSeconds: defaultSessionDurationSeconds,
                soundEnabled: soundEnabled,
                rewardSchedule: rewardSchedule,
                maxRewardReminders: maxRewardReminders,
                ownerPinHash: ownerPinHash,
                ownerPinSalt: ownerPinSalt,
                onboardingComplete: onboardingComplete,
                privacyVersionAccepted: privacyVersionAccepted,
                preferredLocale: preferredLocale,
                reduceMotion: reduceMotion,
                highContrastMode: highContrastMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> defaultSessionDurationSeconds = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<RewardSchedule> rewardSchedule = const Value.absent(),
                Value<int> maxRewardReminders = const Value.absent(),
                Value<String?> ownerPinHash = const Value.absent(),
                Value<String?> ownerPinSalt = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<int> privacyVersionAccepted = const Value.absent(),
                Value<String?> preferredLocale = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> highContrastMode = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                defaultSessionDurationSeconds: defaultSessionDurationSeconds,
                soundEnabled: soundEnabled,
                rewardSchedule: rewardSchedule,
                maxRewardReminders: maxRewardReminders,
                ownerPinHash: ownerPinHash,
                ownerPinSalt: ownerPinSalt,
                onboardingComplete: onboardingComplete,
                privacyVersionAccepted: privacyVersionAccepted,
                preferredLocale: preferredLocale,
                reduceMotion: reduceMotion,
                highContrastMode: highContrastMode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatProfilesTableTableManager get catProfiles =>
      $$CatProfilesTableTableManager(_db, _db.catProfiles);
  $$VoiceCuesTableTableManager get voiceCues =>
      $$VoiceCuesTableTableManager(_db, _db.voiceCues);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$TargetTrialsTableTableManager get targetTrials =>
      $$TargetTrialsTableTableManager(_db, _db.targetTrials);
  $$TouchEventsTableTableManager get touchEvents =>
      $$TouchEventsTableTableManager(_db, _db.touchEvents);
  $$PreferenceStatsTableTableManager get preferenceStats =>
      $$PreferenceStatsTableTableManager(_db, _db.preferenceStats);
  $$CueProgressTableTableManager get cueProgress =>
      $$CueProgressTableTableManager(_db, _db.cueProgress);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
