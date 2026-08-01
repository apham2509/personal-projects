import 'package:drift/drift.dart';

import 'app_database.dart';

/// Bump when the schema changes and add an explicit step in [_upgrade].
const currentSchemaVersion = 1;

MigrationStrategy createMigrationStrategy(AppDatabase db) {
  return MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Seed the single settings row so reads never race an empty table.
      await db
          .into(db.appSettings)
          .insert(const AppSettingsCompanion(id: Value(1)));
    },
    onUpgrade: (m, from, to) => _upgrade(db, m, from, to),
    beforeOpen: (details) async {
      // Cascading deletes (profile -> sessions -> trials -> events) depend on
      // SQLite enforcing foreign keys, which is off by default.
      await db.customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

Future<void> _upgrade(AppDatabase db, Migrator m, int from, int to) async {
  // Explicit stepwise migrations. Example shape for the future:
  //
  //   if (from < 2) {
  //     await m.addColumn(db.catProfiles, db.catProfiles.someNewColumn);
  //   }
  //
  // Schema v1 is the baseline; nothing to do yet.
}
