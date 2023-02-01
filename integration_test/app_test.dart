import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:sunrise_sunset_calculator/main.dart';

String sunriseText() =>
    (find.textContaining('Sunrise:', findRichText: true).evaluate().first.widget
            as RichText)
        .text
        .toPlainText();

void main() {
  testWidgets('App interface integration test', (WidgetTester tester) async {
    tz.initializeTimeZones();
    await tester.pumpWidget(const MyApp());

    String oldText;

    oldText = sunriseText();
    final latitude = find.ancestor(
        of: find.text('Latitude'), matching: find.byType(TextFormField));
    await tester.enterText(latitude, '10.00');
    await tester.pump();
    expect(sunriseText(), isNot(equals(oldText)));

    oldText = sunriseText();
    final longitude = find.ancestor(
        of: find.text('Longitude'), matching: find.byType(TextFormField));
    await tester.enterText(longitude, '20.00');
    await tester.pump();
    expect(sunriseText(), isNot(equals(oldText)));

    oldText = sunriseText();
    final timeZone = find.ancestor(
        of: find.text('Time Zone'), matching: find.byType(DropdownSearch<String>));
    expect(timeZone, findsOneWidget);
    await tester.tap(timeZone);
    await tester.pumpAndSettle();
    // Click the first item in the list.
    await tester.tap(find.text('Africa/Abidjan', findRichText: true));
    await tester.pumpAndSettle();
    expect(sunriseText(), isNot(equals(oldText)));
  });
}
