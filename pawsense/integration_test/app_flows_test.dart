// End-to-end flows on a real device or emulator:
//
//   flutter test integration_test -d <device-id>
//
// These use the real database (cleared between tests via delete-all), real
// files, and the real router. They avoid the live play screen's audio
// hardware paths where possible; full play-session verification is part of
// the physical-device QA pass (docs/QA_PLAN.md).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pawsense/app/app.dart';
import 'package:pawsense/app/router.dart';
import 'package:pawsense/core/export/export_service.dart';
import 'package:pawsense/core/files/file_service_locator.dart';
import 'package:pawsense/features/developer_tools/data/demo_data_service.dart';
import 'package:pawsense/shared/providers/core_providers.dart';

Future<ProviderContainer> pumpApp(WidgetTester tester) async {
  final files = await createFileService();
  final container = ProviderContainer(
    overrides: [fileServiceProvider.overrideWithValue(files)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PawSenseApp()),
  );
  return container;
}

Future<void> resetAllData(ProviderContainer container) async {
  await ExportService(
    container.read(databaseProvider),
    container.read(fileServiceProvider),
    container.read(clockProvider),
  ).deleteAllData();
}

Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      fail('Timed out waiting for $finder');
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('flow 1: first launch -> create cat -> calibration setup', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await resetAllData(container);
    await tester.pumpAndSettle();

    await waitFor(tester, find.text('Welcome to PawSense'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create your first cat'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Tiger');
    for (var step = 1; step < 7; step++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Create profile'));
    await waitFor(tester, find.text('Calibrate'));

    // Calibration is offered prominently; open its setup.
    await tester.tap(find.text('Calibrate'));
    await waitFor(tester, find.text('Start session'));
    expect(find.textContaining('12 small trials'), findsOneWidget);
  });

  testWidgets('flow 2: existing cat -> stored sessions -> insights', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await resetAllData(container);
    await tester.pumpAndSettle();

    // Seed play data through the real pipeline.
    final demo = DemoDataService(
      container.read(catProfileRepositoryProvider),
      container.read(sessionRepositoryProvider),
    );
    final catId = await demo.seedDemoCat(seed: 7, sessionCount: 4);
    final settings = container.read(settingsRepositoryProvider);
    await settings.completeOnboarding(1);
    await tester.pumpAndSettle();

    container.read(routerProviderForTest).go('/cats/$catId/insights');
    await waitFor(tester, find.text('Sessions'));
    expect(find.text('What works for this cat'), findsOneWidget);

    container.read(routerProviderForTest).go('/cats/$catId/history');
    await waitFor(tester, find.text('Session history'));
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('flow 3: export data produces shareable files', (tester) async {
    final container = await pumpApp(tester);
    await resetAllData(container);
    final demo = DemoDataService(
      container.read(catProfileRepositoryProvider),
      container.read(sessionRepositoryProvider),
    );
    await demo.seedDemoCat(seed: 9, sessionCount: 2);
    await container.read(settingsRepositoryProvider).completeOnboarding(1);

    final export = ExportService(
      container.read(databaseProvider),
      container.read(fileServiceProvider),
      container.read(clockProvider),
    );
    final jsonFile = await export.writeJsonFile();
    expect(jsonFile.existsSync(), isTrue);
    expect(jsonFile.lengthSync(), greaterThan(1000));
    final csvs = await export.writeCsvFiles();
    expect(csvs.length, greaterThanOrEqualTo(4));
    await container.read(fileServiceProvider).clearExportDir();
  });

  testWidgets('flow 4: delete one cat removes all dependent records/files', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await resetAllData(container);
    final demo = DemoDataService(
      container.read(catProfileRepositoryProvider),
      container.read(sessionRepositoryProvider),
    );
    final catId = await demo.seedDemoCat(seed: 11, sessionCount: 2);
    final db = container.read(databaseProvider);
    expect(await db.select(db.sessions).get(), isNotEmpty);

    await container.read(catProfileRepositoryProvider).deletePermanently(catId);

    expect(await db.select(db.catProfiles).get(), isEmpty);
    expect(await db.select(db.sessions).get(), isEmpty);
    expect(await db.select(db.targetTrials).get(), isEmpty);
    expect(await db.select(db.touchEvents).get(), isEmpty);
    expect(await db.select(db.preferenceStats).get(), isEmpty);
    expect(
      container.read(fileServiceProvider).profileDir(catId).existsSync(),
      isFalse,
    );
  });

  testWidgets('flow 5: interrupted session recovery on next launch', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await resetAllData(container);
    final db = container.read(databaseProvider);
    final demo = DemoDataService(
      container.read(catProfileRepositoryProvider),
      container.read(sessionRepositoryProvider),
    );
    await demo.seedDemoCat(seed: 13, sessionCount: 1);

    // Simulate a crash: force a session back to inProgress.
    await db.customStatement(
      "UPDATE sessions SET status = 'inProgress', ended_at_utc = NULL",
    );

    final recovered = await container
        .read(sessionRepositoryProvider)
        .recoverInterruptedSessions();
    expect(recovered, 1);
    final sessions = await db.select(db.sessions).get();
    expect(sessions.single.status.name, 'interrupted');
    expect(sessions.single.endedAtUtc, isNotNull);
  });
}

/// The app's router provider, re-exported for direct navigation in flows.
final routerProviderForTest = routerProvider;
