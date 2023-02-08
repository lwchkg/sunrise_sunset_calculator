import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:sunrise_sunset_calculator/widgets/multi_day_info.dart';

import '../test_util/expect_text_in_order.dart';

void main() {
  testWidgets('MultiDayInfo widget test', (WidgetTester tester) async {
    tz.initializeTimeZones();
    tz.Location location = tz.getLocation('America/New_York');
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: MultiDayInfo(
            latitude: 30,
            longitude: -82,
            location: location,
            days: daysFrom(tz.TZDateTime(location, 2023, 3, 15), 3))));

    expectTextInOrder([
      'Date',
      'Civil Twilight Start',
      'Sunrise',
      'Sunset',
      'Civil Twilight End',
      ...['Mar 15', '07:14', '07:38', '19:36', '20:00'],
      ...['Mar 16', '07:13', '07:37', '19:37', '20:01'],
      ...['Mar 17', '07:12', '07:36', '19:37', '20:01'],
    ]);

    expect(find.text('Mar 14', findRichText: true), findsNothing);
    expect(find.text('Mar 18', findRichText: true), findsNothing);
  });

  testWidgets('MultiDayInfo widget test #2', (WidgetTester tester) async {
    tz.initializeTimeZones();
    tz.Location location = tz.getLocation('America/New_York');
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: MultiDayInfo(
            latitude: 30,
            longitude: -82,
            location: location,
            days: daysFrom(tz.TZDateTime(location, 2023, 3, 15), 2))));

    expectTextInOrder([
      'Date',
      'Civil Twilight Start',
      'Sunrise',
      'Sunset',
      'Civil Twilight End',
      ...['Mar 15', '07:14', '07:38', '19:36', '20:00'],
      ...['Mar 16', '07:13', '07:37', '19:37', '20:01'],
    ]);

    expect(find.text('Mar 14', findRichText: true), findsNothing);
    expect(find.text('Mar 17', findRichText: true), findsNothing);
  });
}
