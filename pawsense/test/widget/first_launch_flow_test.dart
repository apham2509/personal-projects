import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  testWidgets('first launch: intro -> wizard -> cat home', (tester) async {
    final app = TestApp.create();
    addTearDown(app.dispose);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text('Welcome to PawSense'));

    // Intro: welcome -> privacy -> safety.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Private by design'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Calm, short, and safe'), findsOneWidget);
    await tester.tap(find.text('Create your first cat'));
    await tester.pumpAndSettle();

    // Wizard step 1: name is required.
    expect(find.text('New cat'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Please give your cat a name.'), findsOneWidget);
    expect(find.text('Step 1 of 7'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Tiger');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Step 2 of 7'), findsOneWidget);

    // Pick an answer along the way, then continue to review.
    await tester.tap(find.text('Senior'));
    await tester.pumpAndSettle();
    for (var step = 2; step < 7; step++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Step 7 of 7'), findsOneWidget);
    await tester.tap(find.text('Create profile'));
    await pumpUntilFound(tester, find.text('Calibration not started'));

    // Landed on Tiger's home.
    expect(find.text('Tiger'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);

    // Database state: profile exists, onboarding completed.
    final cats = await dbCall(
      tester,
      () => app.db.select(app.db.catProfiles).get(),
    );
    expect(cats.single.name, 'Tiger');
    expect(cats.single.ageGroup.name, 'senior');
    final settings = await dbCall(
      tester,
      () => app.db.select(app.db.appSettings).getSingle(),
    );
    expect(settings.onboardingComplete, isTrue);
    expect(settings.privacyVersionAccepted, greaterThan(0));

    await tearDownApp(tester);
  });
}
