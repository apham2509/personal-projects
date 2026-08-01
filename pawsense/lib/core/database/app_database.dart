import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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

  /// Production database, stored as `pawsense.sqlite` in the app's data
  /// directory (managed by drift_flutter).
  AppDatabase.open()
    : super(
        driftDatabase(
          name: 'pawsense',
          native: const DriftNativeOptions(shareAcrossIsolates: true),
        ),
      );

  /// In-memory database for tests.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => createMigrationStrategy(this);
}
