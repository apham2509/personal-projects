import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  testWidgets('settings shows defaults and persists PIN + toggles', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, app.completeOnboarding);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await tester.tap(find.byTooltip('Settings'));
    await pumpUntilFound(tester, find.text('Session defaults'));

    expect(find.text('3 minutes'), findsOneWidget);

    // Lower sections are below the fold in the 800x600 test viewport.
    await tester.scrollUntilVisible(find.text('No treat reminders'), 150);
    expect(find.text('No treat reminders'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Press-and-hold gate (no PIN)'),
      150,
    );

    // Set a PIN. Bounded pumps only: the dialog's autofocused text field
    // blinks its cursor forever, so pumpAndSettle would never settle.
    await tester.scrollUntilVisible(find.text('Set a 4-digit PIN'), 150);
    await tester.tap(find.text('Set a 4-digit PIN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField).last, '4321');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('PIN is set'), findsOneWidget);

    final settings = await dbCall(
      tester,
      () => app.db.select(app.db.appSettings).getSingle(),
    );
    expect(settings.ownerPinHash, isNotNull);

    // Toggle high contrast.
    await tester.scrollUntilVisible(
      find.text('High-contrast play targets'),
      150,
    );
    await tester.tap(find.text('High-contrast play targets'));
    await tester.pump(const Duration(milliseconds: 300));
    final updated = await dbCall(
      tester,
      () => app.db.select(app.db.appSettings).getSingle(),
    );
    expect(updated.highContrastMode, isTrue);

    await tearDownApp(tester);
  });
}
