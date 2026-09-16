import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/cat_profiles/domain/cat_profile_draft.dart';
import 'package:pawsense/features/personalisation/data/preference_repository.dart';
import 'package:pawsense/features/personalisation/domain/algorithm_version.dart';
import 'package:pawsense/features/personalisation/domain/personalisation_policy.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late Directory directory;
  late FakeClock clock;
  late PreferenceRepository repo;
  late CatProfileRepository profiles;
  late String catId;
  const historicalVersion = '$algorithmVersion-historical-test';
  const seeds = [
    PreferenceSeed(
      factorType: FactorType.targetType,
      factorValue: 'mouse',
      impressions: 2,
      successes: 1.5,
    ),
  ];

  Future<void> insertStats({
    required String version,
    required double impressions,
    String? forCat,
    String prey = 'mouse',
  }) async {
    await db
        .into(db.preferenceStats)
        .insert(
          PreferenceStatsCompanion.insert(
            id: const Uuid().v4(),
            catId: forCat ?? catId,
            factorType: FactorType.targetType,
            factorValue: prey,
            impressions: impressions,
            successes: impressions / 2,
            timeouts: 0,
            totalMisses: 0,
            frustrationCount: 0,
            cumulativeReward: 0,
            updatedAtUtc: clock.nowUtc(),
            algorithmVersion: version,
          ),
        );
  }

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    directory = Directory.systemTemp.createTempSync('pawsense_preferences_');
    clock = FakeClock(DateTime.utc(2026, 9, 16));
    repo = PreferenceRepository(db, clock, const Uuid());
    profiles = CatProfileRepository(
      db,
      clock,
      const Uuid(),
      FileService(directory),
    );
    catId = (await profiles.create(const CatProfileDraft(name: 'Miso'))).id;
  });

  tearDown(() async {
    await db.close();
    directory.deleteSync(recursive: true);
  });

  test(
    'historical model does not suppress new priors; each version is retained',
    () async {
      await insertStats(version: historicalVersion, impressions: 80);
      await repo.seedPriorsIfEmpty(catId, seeds);
      await repo.seedPriorsIfEmpty(catId, seeds);

      final rows = await db.select(db.preferenceStats).get();
      expect(rows, hasLength(2));
      final historical = rows.singleWhere(
        (row) => row.algorithmVersion == historicalVersion,
      );
      final current = rows.singleWhere(
        (row) => row.algorithmVersion == algorithmVersion,
      );
      expect(historical.impressions, 80);
      expect(historical.successes, 40);
      expect(current.impressions, 2);
      expect(current.successes, 1.5);
    },
  );

  test(
    'existing current-version learning is never reseeded or replaced',
    () async {
      await insertStats(version: historicalVersion, impressions: 80);
      await insertStats(version: algorithmVersion, impressions: 10);
      await repo.seedPriorsIfEmpty(catId, seeds);
      final current = await repo.watchStats(catId).first;
      expect(current, hasLength(1));
      expect(current.single.impressions, 10);
      expect(current.single.successes, 5);
      expect(await db.select(db.preferenceStats).get(), hasLength(2));
    },
  );

  test(
    'snapshot and watch expose only this cat and current algorithm',
    () async {
      final other = await profiles.create(const CatProfileDraft(name: 'Nori'));
      await insertStats(version: historicalVersion, impressions: 90);
      await insertStats(
        version: historicalVersion,
        impressions: 30,
        prey: 'fish',
      );
      await insertStats(version: algorithmVersion, impressions: 6);
      await insertStats(
        version: algorithmVersion,
        impressions: 70,
        forCat: other.id,
      );

      final snapshot = await repo.loadSnapshot(catId);
      expect(snapshot.totalTrials, 6);
      expect(snapshot.statsFor(FactorType.targetType, 'mouse').impressions, 6);
      expect(snapshot.statsFor(FactorType.targetType, 'fish').impressions, 0);
      final watched = await repo.watchStats(catId).first;
      expect(watched, hasLength(1));
      expect(watched.single.algorithmVersion, algorithmVersion);
      expect(watched.single.catId, catId);
      expect(watched.single.impressions, 6);
    },
  );
}
