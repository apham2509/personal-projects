// Pure Dart on purpose: no drift_flutter/dart:ui imports here, so headless
// tooling (tool/generate_demo_data.dart) can construct the database with an
// in-memory executor. The platform opener lives in open.dart.
import 'package:drift/drift.dart';

import '../../shared/models/enums.dart';
import 'converters.dart';
import 'migrations.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CatProfiles,
    VoiceCues,
    Sessions,
    TargetTrials,
    TouchEvents,
    PreferenceStats,
    CueProgress,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// In-memory database for tests and headless tooling.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => createMigrationStrategy(this);
}
