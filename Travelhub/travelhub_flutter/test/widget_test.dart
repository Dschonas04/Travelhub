// Basic smoke test for TravelhubApp

import 'package:flutter_test/flutter_test.dart';
import 'package:travelhub/main.dart';

void main() {
  testWidgets('App starts and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelhubApp());
    await tester.pumpAndSettle();

    // Verify login screen is shown
    expect(find.text('Willkommen zurück!'), findsOneWidget);
  });
}
