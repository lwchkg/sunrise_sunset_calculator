import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/number_formatters.dart' show formatLatitude, formatLongitude;
import '../utils/layout.dart';
import '../widgets/multi_day_info.dart';

const numberOutputStyle = TextStyle(fontWeight: FontWeight.bold);

class MonthlyInfoPage extends StatefulWidget {
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
      final double latitude =
          double.parse(state.uri.queryParameters['latitude']!);
      final double longitude =
          double.parse(state.uri.queryParameters['longitude']!);
      final location = tz.getLocation(state.uri.queryParameters['location']!);
      final int year = int.parse(state.uri.queryParameters['year']!);
      final int month = int.parse(state.uri.queryParameters['month']!);
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
  State<MonthlyInfoPage> createState() => _MonthlyInfoPageState();
}

class _MonthlyInfoPageState extends State<MonthlyInfoPage> {
  int year = 1970;
  int month = 1;

  @override
  void initState() {
    year = widget.year;
    month = widget.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Padding(
          padding: allEdgeInsets,
          child: Text('Error: parameter parsing failed.'),
        ),
      );
    }

    final headingStyle = getHeadingStyle(context);
    final headingSizeStyle = TextStyle(fontSize: headingStyle.fontSize);
    final bodyTextStyle = getBodyTextStyle(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    text: formatLatitude(widget.latitude),
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
                    text: formatLongitude(widget.longitude),
                    style: numberOutputStyle),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Location: ',
              style: bodyTextStyle,
              children: [
                TextSpan(text: widget.location.name, style: numberOutputStyle),
              ],
            ),
          ),
          verticalSpacingBox,
          Row(
            children: [
              TextButton(
                  key: const ValueKey('prevMonth'),
                  onPressed: () {
                    setState(() {
                      month--;
                      if (month <= 0) {
                        month += 12;
                        year -= 1;
                      }
                    });
                  },
                  child: Text('<', style: headingSizeStyle)),
              Expanded(
                  child: Center(
                      child: Text(
                          DateFormat.yMMM().format(DateTime.utc(year, month)),
                          key: const ValueKey('month'),
                          style: headingStyle))),
              TextButton(
                  key: const ValueKey('nextMonth'),
                  onPressed: () {
                    setState(() {
                      month++;
                      if (month > 12) {
                        month -= 12;
                        year++;
                      }
                    });
                  },
                  child: Text('>', style: headingSizeStyle)),
            ],
          ),
          verticalSpacingBox,
          MultiDayInfo(
            latitude: widget.latitude,
            longitude: widget.longitude,
            location: widget.location,
            days: daysOfMonth(tz.TZDateTime(widget.location, year, month)),
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
