import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  testWidgets('archive requires confirmation and moves cat to archived', (
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
    await tester.tap(find.byTooltip('Manage profiles'));
    await pumpUntilFound(
      tester,
      find.text('Drag to change the order shown on the picker.'),
    );

    await tester.tap(find.byTooltip('Archive'));
    await tester.pumpAndSettle();
    expect(find.text('Archive Tiger?'), findsOneWidget);

    // Cancel keeps the cat active.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(
      (await dbCall(tester, () => app.profileRepo.watchActive().first)).length,
      1,
    );

    // Confirm archives.
    await tester.tap(find.byTooltip('Archive'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Archive'));
    await tester.pumpAndSettle();
    expect(
      await dbCall(tester, () => app.profileRepo.watchActive().first),
      isEmpty,
    );
    expect(find.text('Archived'), findsOneWidget);

    // Restore brings it back.
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();
    final active = await dbCall(
      tester,
      () => app.profileRepo.watchActive().first,
    );
    expect(active.single.name, 'Tiger');

    await tearDownApp(tester);
  });

  testWidgets('permanent delete explains scope and removes data', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Shark');
    });

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await tester.tap(find.byTooltip('Manage profiles'));
    await pumpUntilFound(
      tester,
      find.text('Drag to change the order shown on the picker.'),
    );

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Permanently delete Shark?'), findsOneWidget);
    expect(
      find.textContaining('voice recordings'),
      findsOneWidget,
      reason: 'confirmation must explain what is removed',
    );

    await tester.tap(find.text('Delete forever'));
    await tester.pumpAndSettle();
    expect(
      await dbCall(tester, () => app.db.select(app.db.catProfiles).get()),
      isEmpty,
    );

    await tearDownApp(tester);
  });
}
