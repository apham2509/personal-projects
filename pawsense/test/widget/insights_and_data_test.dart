import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/app/app.dart';
import 'package:pawsense/features/data_management/presentation/data_management_screen.dart';
import 'package:pawsense/features/developer_tools/data/demo_data_service.dart';
import 'package:pawsense/features/personalisation/data/preference_repository.dart';
import 'package:pawsense/features/play/data/session_repository.dart';
import 'package:pawsense/features/training/data/cue_progress_repository.dart';
import 'package:pawsense/shared/providers/core_providers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import 'harness.dart';

void main() {
  Future<String> seedDemo(TestApp app, WidgetTester tester) {
    return dbCall(tester, () async {
      await app.completeOnboarding();
      const uuid = Uuid();
      final demo = DemoDataService(
        app.profileRepo,
        SessionRepository(
          app.db,
          app.clock,
          uuid,
          PreferenceRepository(app.db, app.clock, uuid),
          CueProgressRepository(app.db, app.clock, uuid),
        ),
      );
      return demo.seedDemoCat(seed: 99, sessionCount: 4);
    });
  }

  testWidgets('insights empty state before any session', (tester) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
    });
    final catId = (await dbCall(
      tester,
      () => app.db.select(app.db.catProfiles).get(),
    )).single.id;

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/cats/$catId/insights');
    await pumpUntilFound(tester, find.text('Nothing to show yet'));

    await tearDownApp(tester);
  });

  testWidgets('insights populated: headline stats, favourites, heatmap', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    final catId = await seedDemo(app, tester);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/cats/$catId/insights');
    await pumpUntilFound(tester, find.text('Sessions'));

    expect(find.text('4'), findsWidgets); // session count tile
    expect(find.text('What works for this cat'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Where the paws land'), 200);
    await tester.scrollUntilVisible(find.text('How sessions ended'), 200);
    expect(find.text('Completed'), findsOneWidget);

    await tearDownApp(tester);
  });

  testWidgets('history lists sessions and deletes one with confirmation', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    final catId = await seedDemo(app, tester);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/cats/$catId/history');
    await pumpUntilFound(tester, find.text('Session history'));

    final before = await dbCall(
      tester,
      () => app.db.select(app.db.sessions).get(),
    );
    expect(before, hasLength(4));

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    expect(find.text('Delete this session?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pump(const Duration(milliseconds: 400));

    final after = await dbCall(
      tester,
      () => app.db.select(app.db.sessions).get(),
    );
    expect(after, hasLength(3));

    await tearDownApp(tester);
  });

  testWidgets('data management exports JSON through the share seam', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await seedDemo(app, tester);
    final shared = <List<XFile>>[];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          shareFilesProvider.overrideWithValue((files) async {
            shared.add(files);
          }),
        ],
        child: const PawSenseApp(),
      ),
    );
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/settings/data');
    await pumpUntilFound(tester, find.text('Export JSON'));

    await tester.tap(find.text('Export JSON'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(shared, hasLength(1));
    expect(shared.single.single.path, endsWith('.json'));

    await tester.tap(find.text('Export CSV'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(shared, hasLength(2));
    expect(shared.last.length, greaterThanOrEqualTo(4));

    // Transient export dir cleared after sharing.
    expect(app.files.exportDir().existsSync(), isFalse);

    await tearDownApp(tester);
  });
}
