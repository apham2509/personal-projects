import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/main.dart';

void main() {
  testWidgets('app shell renders localised title and tagline', (tester) async {
    await tester.pumpWidget(const PawSenseApp());
    await tester.pumpAndSettle();

    expect(find.text('PawSense'), findsOneWidget);
    expect(find.text('Play smarter. Learn your cat.'), findsOneWidget);
  });
}
