import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'test_util/mocks.dart';

import 'package:sunrise_sunset_calculator/main.dart';
import 'package:sunrise_sunset_calculator/pages/home.dart';

void main() {
  setupMocks();

  testWidgets('Overall app widget test', (WidgetTester tester) async {
    tz.initializeTimeZones();
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
