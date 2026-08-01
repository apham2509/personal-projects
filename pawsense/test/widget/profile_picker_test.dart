import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  testWidgets('picker lists cats, add card, and mixed session', (tester) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
      await app.seedCat('Shark');
    });

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text("Who's playing?"));

    expect(find.text('Tiger'), findsOneWidget);
    expect(find.text('Shark'), findsOneWidget);
    expect(find.text('Add cat'), findsOneWidget);
    expect(find.text('Mixed session'), findsOneWidget);

    // Tapping a cat opens its home hub.
    await tester.tap(find.text('Shark'));
    await pumpUntilFound(tester, find.text('Insights'));
    expect(find.text('Shark'), findsOneWidget);
    expect(find.text('Voice cues'), findsOneWidget);

    await tearDownApp(tester);
  });

  testWidgets('empty picker shows call to action', (tester) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, app.completeOnboarding);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text('No cats yet'));
    expect(find.text('Add cat'), findsOneWidget);

    await tearDownApp(tester);
  });
}
