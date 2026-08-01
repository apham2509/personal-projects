// Generates a deterministic demo database and prints its JSON export to a
// file — useful for screenshots, export-format review, and manual QA:
//
//   dart run tool/generate_demo_data.dart out/demo_export.json
//
// Uses the same DemoDataService as the in-app developer screen, so the
// output exercises the real repositories and finalisation pipeline.

import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/export/export_service.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/developer_tools/data/demo_data_service.dart';
import 'package:pawsense/features/personalisation/data/preference_repository.dart';
import 'package:pawsense/features/play/data/session_repository.dart';
import 'package:pawsense/features/training/data/cue_progress_repository.dart';
import 'package:uuid/uuid.dart';

Future<void> main(List<String> args) async {
  final outPath = args.isEmpty ? 'demo_export.json' : args[0];
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final tempDir = Directory.systemTemp.createTempSync('pawsense_demo');
  final files = FileService(tempDir);
  final clock = FakeClock(DateTime.utc(2026, 8, 1, 9));
  const uuid = Uuid();

  final profiles = CatProfileRepository(db, clock, uuid, files);
  final sessions = SessionRepository(
    db,
    clock,
    uuid,
    PreferenceRepository(db, clock, uuid),
    CueProgressRepository(db, clock, uuid),
  );
  final demo = DemoDataService(profiles, sessions);

  await demo.seedDemoCat(seed: 2026, sessionCount: 8);
  await demo.seedDemoCat(seed: 4242, sessionCount: 3, struggling: true);

  final export = ExportService(db, files, clock);
  final json = await export.buildJson();
  final out = File(outPath)..parent.createSync(recursive: true);
  out.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));
  stdout.writeln(
    'wrote $outPath '
    '(${(json['sessions'] as List).length} sessions)',
  );

  await db.close();
  tempDir.deleteSync(recursive: true);
}
