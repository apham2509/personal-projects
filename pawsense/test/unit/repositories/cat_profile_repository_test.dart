import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/cat_profiles/domain/cat_profile_draft.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FileService files;
  late FakeClock clock;
  late CatProfileRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('pawsense_test');
    files = FileService(tempDir);
    clock = FakeClock(DateTime.utc(2026, 8, 1, 12));
    repo = CatProfileRepository(db, clock, const Uuid(), files);
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  test('create stores questionnaire answers and defaults', () async {
    final cat = await repo.create(
      const CatProfileDraft(
        name: '  Tiger ',
        ageGroup: AgeGroup.senior,
        favouritePrey: FavouritePrey.mouse,
        soundSensitivity: SoundSensitivity.easilyStartled,
        screenExperience: ScreenExperience.frequent,
      ),
    );

    expect(cat.name, 'Tiger');
    expect(cat.ageGroup, AgeGroup.senior);
    expect(cat.favouritePrey, FavouritePrey.mouse);
    expect(cat.calibrationState, CalibrationState.notStarted);
    // Frequent experience would give 3, but senior caps at 2.
    expect(cat.currentDifficulty, 2);
    expect(cat.archivedAtUtc, isNull);
    expect(cat.createdAtUtc.isUtc, isTrue);
    expect(cat.sortOrder, 0);
  });

  test('sortOrder increments per profile and reorder persists', () async {
    final a = await repo.create(const CatProfileDraft(name: 'A'));
    final b = await repo.create(const CatProfileDraft(name: 'B'));
    final c = await repo.create(const CatProfileDraft(name: 'C'));
    expect([a.sortOrder, b.sortOrder, c.sortOrder], [0, 1, 2]);

    await repo.reorder([c.id, a.id, b.id]);
    final active = await repo.watchActive().first;
    expect(active.map((p) => p.name).toList(), ['C', 'A', 'B']);
  });

  test('archive hides from active, restore brings back', () async {
    final cat = await repo.create(const CatProfileDraft(name: 'Shark'));
    await repo.archive(cat.id);

    expect(await repo.watchActive().first, isEmpty);
    final archived = await repo.watchArchived().first;
    expect(archived.single.name, 'Shark');
    expect(archived.single.archivedAtUtc, clock.nowUtc());

    await repo.restore(cat.id);
    expect((await repo.watchActive().first).single.archivedAtUtc, isNull);
  });

  test('update rewrites questionnaire fields, keeps difficulty', () async {
    final cat = await repo.create(
      const CatProfileDraft(
        name: 'Tiger',
        screenExperience: ScreenExperience.none,
      ),
    );
    expect(cat.currentDifficulty, 1);

    clock.advance(const Duration(minutes: 5));
    await repo.update(
      cat.id,
      const CatProfileDraft(
        name: 'Tiger II',
        screenExperience: ScreenExperience.frequent,
        energyLevel: EnergyLevel.high,
      ),
    );

    final updated = (await repo.getById(cat.id))!;
    expect(updated.name, 'Tiger II');
    expect(updated.energyLevel, EnergyLevel.high);
    expect(updated.currentDifficulty, 1, reason: 'edits must not reset it');
    expect(updated.updatedAtUtc.isAfter(updated.createdAtUtc), isTrue);
  });

  test('deletePermanently cascades to dependent rows and files', () async {
    final cat = await repo.create(const CatProfileDraft(name: 'Tiger'));

    // Dependent rows in every cascading table.
    await db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            id: 'session-1',
            catId: Value(cat.id),
            mode: SessionMode.freePlay,
            startedAtUtc: clock.nowUtc(),
            plannedDurationSeconds: 180,
            status: SessionStatus.inProgress,
            calibrationSession: false,
            randomSeed: 42,
            algorithmVersion: cat.algorithmVersion,
            appVersion: 'test',
            platform: 'test',
            screenWidthLogical: 800,
            screenHeightLogical: 600,
            catches: 0,
            misses: 0,
            timeouts: 0,
            frustrationCount: 0,
            createdAtUtc: clock.nowUtc(),
            updatedAtUtc: clock.nowUtc(),
          ),
        );
    await db
        .into(db.preferenceStats)
        .insert(
          PreferenceStatsCompanion.insert(
            id: 'stat-1',
            catId: cat.id,
            factorType: FactorType.targetType,
            factorValue: PreyType.mouse.name,
            impressions: 4,
            successes: 3,
            timeouts: 0,
            totalMisses: 0,
            frustrationCount: 0,
            cumulativeReward: 0,
            updatedAtUtc: clock.nowUtc(),
            algorithmVersion: cat.algorithmVersion,
          ),
        );

    // A media file on disk.
    final photoSource = File('${tempDir.path}/src.jpg')
      ..writeAsBytesSync([1, 2, 3]);
    final rel = await files.savePhoto(cat.id, photoSource, 1);
    expect(files.resolve(rel).existsSync(), isTrue);

    await repo.deletePermanently(cat.id);

    expect(await repo.getById(cat.id), isNull);
    expect(await db.select(db.sessions).get(), isEmpty);
    expect(await db.select(db.preferenceStats).get(), isEmpty);
    expect(files.profileDir(cat.id).existsSync(), isFalse);
  });

  test('mixed sessions (null catId) survive profile deletion', () async {
    final cat = await repo.create(const CatProfileDraft(name: 'Tiger'));
    await db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            id: 'mixed-1',
            catId: const Value(null),
            mode: SessionMode.mixed,
            startedAtUtc: clock.nowUtc(),
            plannedDurationSeconds: 180,
            status: SessionStatus.completed,
            calibrationSession: false,
            randomSeed: 7,
            algorithmVersion: cat.algorithmVersion,
            appVersion: 'test',
            platform: 'test',
            screenWidthLogical: 800,
            screenHeightLogical: 600,
            catches: 2,
            misses: 1,
            timeouts: 0,
            frustrationCount: 0,
            createdAtUtc: clock.nowUtc(),
            updatedAtUtc: clock.nowUtc(),
          ),
        );

    await repo.deletePermanently(cat.id);
    final sessions = await db.select(db.sessions).get();
    expect(sessions.single.id, 'mixed-1');
  });
}
