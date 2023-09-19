import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../test_util/expect_text_in_order.dart';
import '../test_util/mocks.dart';

import 'package:sunrise_sunset_calculator/core/datetime_formatters.dart' show shortDate;
import 'package:sunrise_sunset_calculator/widgets/multi_day_info.dart' show daysOfMonth;

import 'package:sunrise_sunset_calculator/pages/monthly_info_page.dart';

String sunriseText() =>
    (find.textContaining('Sunrise:', findRichText: true).evaluate().first.widget
            as RichText)
        .text
        .toPlainText();

void main() {
  setupMocks();

  String? getMonth() {
    final finder = find.byKey(const ValueKey('month'));
    expect(finder, findsOneWidget);
    return (finder.evaluate().first.widget as Text).data;
  }

  Finder prevButton() {
    final finder = find.byKey(const ValueKey('prevMonth'));
    expect(finder, findsOneWidget);
    return finder;
  }

  Finder nextButton() {
    final finder = find.byKey(const ValueKey('nextMonth'));
    expect(finder, findsOneWidget);
    return finder;
  }

  testWidgets('Monthly info page URL parsing', (WidgetTester tester) async {
    tz.initializeTimeZones();

    const uri =
        '/?latitude=20&longitude=30&location=America/New_York&year=2023&month=3';

    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            MonthlyInfoPage.fromState(title: 'test app', state: state),
      ),
    ]);
    router.push(uri);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expectTextInOrder([
      'Latitude: 20.00000° N',
      'Longitude: 30.00000° E',
      'Location: America/New_York',
      'Mar 2023'
    ]);
  });

  testWidgets('Monthly info page widget test', (WidgetTester tester) async {
    tz.initializeTimeZones();
    tz.Location location = tz.getLocation('America/New_York');
    await tester.pumpWidget(MaterialApp.router(
        routerConfig: GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MonthlyInfoPage(
            title: 'test app',
            latitude: 20,
            longitude: 30,
            year: 2023,
            month: 3,
            location: location),
      )
    ])));

    expectTextInOrder([
      'Latitude: 20.00000° N',
      'Longitude: 30.00000° E',
      'Location: America/New_York',
    ]);

    expect(getMonth(), 'Mar 2023');
    final marchDays = daysOfMonth(tz.TZDateTime(location, 2023, 3));
    final marchDayLabels = marchDays.map((d) => shortDate(d));
    expectTextInOrder(marchDayLabels);
    expectTextInOrder(['Mar 2', '22:57', '23:19', '11:05', '11:27', 'Mar 3']);

    await tester.tap(prevButton());
    await tester.pumpAndSettle();
    expect(getMonth(), 'Feb 2023');
    final februaryDays = daysOfMonth(tz.TZDateTime(location, 2023, 2));
    final februaryDayLabels = februaryDays.map((d) => shortDate(d));
    expectTextInOrder(februaryDayLabels);
    expectTextInOrder(['Feb 2', '23:12', '23:35', '10:52', '11:15', 'Feb 3']);

    await tester.tap(nextButton());
    await tester.pumpAndSettle();
    expect(getMonth(), 'Mar 2023');
    expectTextInOrder(marchDayLabels);
    expectTextInOrder(['Mar 2', '22:57', '23:19', '11:05', '11:27', 'Mar 3']);
  });

  testWidgets('Monthly info page widget test year rolling', (WidgetTester tester) async {
    tz.initializeTimeZones();
    tz.Location location = tz.getLocation('America/New_York');
    await tester.pumpWidget(MaterialApp.router(
        routerConfig: GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MonthlyInfoPage(
            title: 'test app',
            latitude: 20,
            longitude: 30,
            year: 2023,
            month: 1,
            location: location),
      )
    ])));

    expect(getMonth(), 'Jan 2023');

    await tester.tap(prevButton());
    await tester.pumpAndSettle();
    expect(getMonth(), 'Dec 2022');

    await tester.tap(nextButton());
    await tester.pumpAndSettle();
    expect(getMonth(), 'Jan 2023');
  });
}
