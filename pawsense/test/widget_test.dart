import 'package:flutter_test/flutter_test.dart';

import 'widget/harness.dart';

/// App-level smoke test: the shell boots, opens the in-memory database, and
/// reaches the intro flow on a fresh install.
void main() {
  testWidgets('fresh install boots to the intro flow', (tester) async {
    final app = TestApp.create();
    addTearDown(app.dispose);

    await tester.pumpWidget(app.build());
    await pumpUntilFound(tester, find.text('Welcome to PawSense'));
    expect(find.text('Play smarter. Learn your cat.'), findsOneWidget);

    await tearDownApp(tester);
  });
}
