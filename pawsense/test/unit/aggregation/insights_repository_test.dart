import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/developer_tools/data/demo_data_service.dart';
import 'package:pawsense/features/insights/data/insights_repository.dart';
import 'package:pawsense/features/personalisation/data/preference_repository.dart';
import 'package:pawsense/features/personalisation/domain/algorithm_version.dart';
import 'package:pawsense/features/play/data/session_repository.dart';
import 'package:pawsense/features/training/data/cue_progress_repository.dart';

import 'package:uuid/uuid.dart';

void main() {
  test(
    'stored trial versions reach confidence filtering without hiding history',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final directory = Directory.systemTemp.createTempSync(
        'pawsense_insights_',
      );
      final clock = FakeClock(DateTime.utc(2026, 9, 16));
      const uuid = Uuid();
      try {
        final profiles = CatProfileRepository(
          db,
          clock,
          uuid,
          FileService(directory),
        );
        final sessions = SessionRepository(
          db,
          clock,
          uuid,
          PreferenceRepository(db, clock, uuid),
          CueProgressRepository(db, clock, uuid),
        );
        final catId = await DemoDataService(
          profiles,
          sessions,
        ).seedDemoCat(seed: 17, sessionCount: 3);
        final repository = InsightsRepository(db);
        final before = await repository.computeForCat(catId);
        expect(before.lifetimeComparableTrials, greaterThan(0));
        expect(before.favourites.any((f) => f.topComparable > 0), isTrue);

        await db.customStatement(
          'UPDATE target_trials SET algorithm_version = ?',
          ['$algorithmVersion-historical-test'],
        );
        final after = await repository.computeForCat(catId);
        expect(
          after.favourites.every((f) => f.topComparable == 0 && !f.showable),
          isTrue,
        );
        expect(after.personalityTitleKey, isNull);
        expect(after.lifetimeComparableTrials, before.lifetimeComparableTrials);
        expect(after.lifetimeCatches, before.lifetimeCatches);
        expect(after.lifetimeSessions, before.lifetimeSessions);
        expect(after.medianReactionMs, before.medianReactionMs);
        expect(after.heatmap.totalTouches, before.heatmap.totalTouches);
        expect(after.catchRateTrend.length, before.catchRateTrend.length);
      } finally {
        await db.close();
        directory.deleteSync(recursive: true);
      }
    },
  );
}
