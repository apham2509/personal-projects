import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/shared/models/enums.dart';

import 'harness.dart';

Future<String> seedCompletedSession(TestApp app, String catId) async {
  const id = 'session-widget-test';
  final now = app.clock.nowUtc();
  await app.db
      .into(app.db.sessions)
      .insert(
        SessionsCompanion.insert(
          id: id,
          catId: Value(catId),
          mode: SessionMode.freePlay,
          startedAtUtc: now.subtract(const Duration(minutes: 5)),
          endedAtUtc: Value(now.subtract(const Duration(minutes: 2))),
          plannedDurationSeconds: 180,
          actualDurationMs: const Value(178000),
          status: SessionStatus.completed,
          calibrationSession: false,
          randomSeed: 7,
          algorithmVersion: 'pawsense-personalisation-v1',
          appVersion: 'test',
          platform: 'test',
          screenWidthLogical: 800,
          screenHeightLogical: 600,
          catches: 9,
          misses: 4,
          timeouts: 3,
          medianReactionMs: const Value(1400),
          frustrationCount: 1,
          createdAtUtc: now,
          updatedAtUtc: now,
        ),
      );
  return id;
}

void main() {
  testWidgets('session setup shows durations, sound, and manual factors', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
    });

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await tester.tap(find.text('Tiger'));
    await pumpUntilFound(tester, find.text('Insights'));
    await tester.tap(find.text('Play'));
    await pumpUntilFound(tester, find.text('Start session'));

    expect(find.text('Play session'), findsOneWidget);
    expect(find.text('3 minutes'), findsOneWidget);
    expect(find.text('Sound for this session'), findsOneWidget);

    // Manual mode reveals the factor pickers.
    await tester.tap(find.text('Choose the target myself'));
    await tester.pumpAndSettle();
    expect(find.text('Prey'), findsOneWidget);
    expect(find.text('Stop and go'), findsOneWidget);
    expect(find.text('Unpredictable'), findsOneWidget);

    await tearDownApp(tester);
  });

  testWidgets('mixed session setup explains the no-learning rule', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, app.completeOnboarding);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await tester.tap(find.text('Mixed session'));
    await pumpUntilFound(
      tester,
      find.textContaining('never updates any individual cat'),
    );
    await tester.scrollUntilVisible(find.text('Start session'), 150);
    expect(find.text('Start session'), findsOneWidget);

    await tearDownApp(tester);
  });

  testWidgets('results screen renders stats and stores owner feedback', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    late String sessionId;
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
      final cat = (await app.db.select(app.db.catProfiles).get()).single;
      sessionId = await seedCompletedSession(app, cat.id);
    });

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/results/$sessionId');
    await pumpUntilFound(tester, find.text('Session results'));

    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('9'), findsOneWidget); // catches
    expect(find.text('75%'), findsOneWidget); // 9 of 12 concluded trials
    expect(find.text('1.4 s'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('made the session easier'),
      150,
    );

    await tester.scrollUntilVisible(find.text('Engaged'), 150);
    await tester.tap(find.text('Engaged'));
    await tester.pump(const Duration(milliseconds: 400));
    final session = await dbCall(
      tester,
      () => app.db.select(app.db.sessions).getSingle(),
    );
    expect(session.ownerSubjectiveFeedback, OwnerFeedback.engaged);

    await tearDownApp(tester);
  });
}
