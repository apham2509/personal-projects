import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.dart';

/// Opens the production database (`pawsense.sqlite` in the app's data
/// directory, managed by drift_flutter). Kept out of app_database.dart so
/// the database class itself stays importable from headless `dart` tooling.
AppDatabase openAppDatabase() {
  return AppDatabase(
    driftDatabase(
      name: 'pawsense',
      native: const DriftNativeOptions(shareAcrossIsolates: true),
    ),
  );
}
