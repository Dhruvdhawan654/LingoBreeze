import 'package:flutter_test/flutter_test.dart';
import 'package:lingobreeze/app.dart';

void main() {
  testWidgets('App renders vocabulary screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LingoApp());
    // Verify the app title is displayed
    expect(find.text('My Vocabulary'), findsOneWidget);
  });
}
