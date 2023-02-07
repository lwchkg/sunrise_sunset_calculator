import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:sunrise_sunset_calculator/single_day_info.dart';

import 'test_util/expect_text_in_order.dart';

void main() {
  testWidgets('SingleDayInfo widget test', (WidgetTester tester) async {
    tz.initializeTimeZones();
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: SingleDayInfo(
            latitude: 30,
            longitude: -82,
            location: tz.getLocation('America/New_York'),
            now: DateTime.utc(2023, 3, 16))));

    expectTextInOrder([
      'Civil Twilight Start: 07:14',
      'Sunrise: 07:38',
      'Sunset: 19:36',
      'Civil Twilight End: 20:00'
    ]);
  });

  testWidgets('SingleDayInfo widget test round up',
      (WidgetTester tester) async {
    tz.initializeTimeZones();
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: SingleDayInfo(
            latitude: 20,
            longitude: 120,
            location: tz.getLocation('Asia/Manila'),
            now: DateTime.utc(2023, 3, 20))));

    // The time should be 2023-03-20 05:42:42.802339+0800, which rounds up.
    expect(find.text('Civil Twilight Start: 05:42', findRichText: true),
        findsNothing);

    expectTextInOrder([
      'Civil Twilight Start: 05:43',
      'Sunrise: 06:05',
      'Sunset: 18:11',
      'Civil Twilight End: 18:33'
    ]);
  });

  testWidgets('SingleDayInfo widget test +1 day', (WidgetTester tester) async {
    tz.initializeTimeZones();
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: SingleDayInfo(
            latitude: 30,
            longitude: -82,
            location: tz.getLocation('Europe/London'),
            now: DateTime.utc(2023, 3, 15))));

    expect(find.text('Civil Twilight End: 00:00 (+1 day)', findRichText: true),
        findsOneWidget);
  });

  testWidgets('SingleDayInfo widget test -1 day', (WidgetTester tester) async {
    tz.initializeTimeZones();
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: SingleDayInfo(
            latitude: 20,
            longitude: 120,
            location: tz.getLocation('Europe/London'),
            now: DateTime.utc(2023, 3, 20))));

    // \u2212 is the minus sign.
    expect(find.text('Sunrise: 22:05 (\u22121 day)', findRichText: true),
        findsOneWidget);
  });
}
