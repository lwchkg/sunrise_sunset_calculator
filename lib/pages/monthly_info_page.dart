import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../utils/layout.dart';
import '../widgets/multi_day_info.dart';

toLocalizedString(n) =>
    NumberFormat.decimalPatternDigits(decimalDigits: 5).format(n);

const numberOutputStyle = TextStyle(fontWeight: FontWeight.bold);

class MonthlyInfoPage extends StatelessWidget {
  final String title;

  final double latitude;
  final double longitude;
  final int year;
  final int month;
  final tz.Location location;
  final bool isError;

  const MonthlyInfoPage({
    super.key,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.year,
    required this.month,
    required this.location,
    this.isError = false,
  });

  static MonthlyInfoPage fromState(
      {Key? key, required String title, required GoRouterState state}) {
    try {
      final double latitude = double.parse(state.queryParams['latitude']!);
      final double longitude = double.parse(state.queryParams['longitude']!);
      final location = tz.getLocation(state.queryParams['location']!);
      final int year = int.parse(state.queryParams['year']!);
      final int month = int.parse(state.queryParams['month']!);
      return MonthlyInfoPage(
        key: key,
        title: title,
        latitude: latitude,
        longitude: longitude,
        year: year,
        month: month,
        location: location,
      );
    } catch (e) {
      debugPrint('Failed to parse parameters. Message: $e');
      return MonthlyInfoPage(
        key: key,
        title: title,
        latitude: 0,
        longitude: 0,
        year: 2000,
        month: 1,
        location: tz.getLocation('UTC'),
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const Padding(
          padding: allEdgeInsets,
          child: Text('Error: parameter parsing failed.'),
        ),
      );
    }

    final bodyTextStyle = getBodyTextStyle(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: allEdgeInsets,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: 'Latitude: ',
              style: bodyTextStyle,
              children: [
                TextSpan(
                    text: toLocalizedString(latitude),
                    style: numberOutputStyle),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Longitude: ',
              style: bodyTextStyle,
              children: [
                TextSpan(
                    text: toLocalizedString(longitude),
                    style: numberOutputStyle),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Location: ',
              style: bodyTextStyle,
              children: [
                TextSpan(text: location.name, style: numberOutputStyle),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Month: ',
              style: bodyTextStyle,
              children: [
                TextSpan(
                    text: DateFormat.yMMM().format(DateTime.utc(year, month)),
                    style: numberOutputStyle),
              ],
            ),
          ),
          verticalSpacingBox,
          MultiDayInfo(
            latitude: latitude,
            longitude: longitude,
            location: location,
            days: daysOfMonth(tz.TZDateTime(location, year, month)),
            title: 'Monthly sunrise and sunset times',
          ),
          // Add home button if this page is a standalone web page.
          if (!context.canPop()) ...[
            verticalSpacingBox,
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Home'),
            ),
          ],
        ],
      ),
    );
  }
}
