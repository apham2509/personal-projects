import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FileService files;
  late FakeClock clock;
  late ExportService service;
  late DemoDataService demo;
  late CatProfileRepository profiles;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('pawsense_export_test');
    files = FileService(tempDir);
    clock = FakeClock(DateTime.utc(2026, 8, 1, 9));
    const uuid = Uuid();
    profiles = CatProfileRepository(db, clock, uuid, files);
    final sessions = SessionRepository(
      db,
      clock,
      uuid,
      PreferenceRepository(db, clock, uuid),
      CueProgressRepository(db, clock, uuid),
    );
    demo = DemoDataService(profiles, sessions);
    service = ExportService(db, files, clock);
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  test('JSON export carries versioned header and full structure', () async {
    await demo.seedDemoCat(seed: 1, sessionCount: 2);
    final json = await service.buildJson();

    final header = json['export'] as Map<String, dynamic>;
    expect(header['formatVersion'], 1);
    expect(header['includesMedia'], isFalse);
    expect(header['algorithmVersion'], 'pawsense-personalisation-v1');
    expect(header['scope'], 'all');

    final cats = json['cats'] as List;
    expect(cats, hasLength(1));
    final sessions = (json['sessions'] as List).cast<Map<String, dynamic>>();
    expect(sessions, hasLength(2));
    for (final session in sessions) {
      final trials = session['trials'] as List;
      expect(trials, isNotEmpty);
      expect(session['touchEvents'], isNotEmpty);
      // Aggregates match raw trials (also enforced by validate_exports).
      expect(
        session['catches'],
        trials.where((t) => (t as Map)['success'] == true).length,
      );
    }
    expect(json['preferenceStats'], isNotEmpty);
  });

  test('single-cat scope excludes other cats and their sessions', () async {
    final firstCatId = await demo.seedDemoCat(seed: 1, sessionCount: 1);
    await demo.seedDemoCat(seed: 2, sessionCount: 1, struggling: true);

    final json = await service.buildJson(catId: firstCatId);
    expect(json['cats'] as List, hasLength(1));
    expect(((json['cats'] as List).single as Map)['id'], firstCatId);
    final sessions = (json['sessions'] as List).cast<Map<String, dynamic>>();
    expect(sessions.every((s) => s['catId'] == firstCatId), isTrue);
  });

  test('CSV export writes one well-formed file per table', () async {
    await demo.seedDemoCat(seed: 3, sessionCount: 2);
    final csvFiles = await service.writeCsvFiles();
    final names = csvFiles
        .map((f) => f.path.split(Platform.pathSeparator).last)
        .toList();
    expect(
      names,
      containsAll([
        'cat_profiles.csv',
        'sessions.csv',
        'target_trials.csv',
        'touch_events.csv',
        'preference_stats.csv',
      ]),
    );

    final sessionsCsv = csvFiles
        .firstWhere((f) => f.path.endsWith('sessions.csv'))
        .readAsStringSync();
    final lines = sessionsCsv
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    expect(lines, hasLength(3), reason: 'header + 2 sessions');
    expect(lines.first, contains('randomSeed'));

    final trialsCsv = csvFiles
        .firstWhere((f) => f.path.endsWith('target_trials.csv'))
        .readAsStringSync();
    expect(trialsCsv.split('\n').first, contains('sessionId'));
  });

  test('deleteAllData wipes rows, media, and resets settings', () async {
    final catId = await demo.seedDemoCat(seed: 4, sessionCount: 1);
    final photoSource = File('${tempDir.path}/pic.jpg')
      ..writeAsBytesSync([1, 2, 3]);
    await files.savePhoto(catId, photoSource, 1);

    await service.deleteAllData();

    expect(await db.select(db.catProfiles).get(), isEmpty);
    expect(await db.select(db.sessions).get(), isEmpty);
    expect(await db.select(db.preferenceStats).get(), isEmpty);
    expect(files.profileDir(catId).existsSync(), isFalse);
    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.onboardingComplete, isFalse);
    expect(settings.ownerPinHash, isNull);
  });
}
