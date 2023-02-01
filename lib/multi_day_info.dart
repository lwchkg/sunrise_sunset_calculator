import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import 'datetime_formatters.dart' show shortTime, shortDate;
import 'solar_position.dart';

/// Return a list of [count] day, which the first day is [from]. The time of the
/// returned days is noon.
List<tz.TZDateTime> daysFrom(tz.TZDateTime from, int count) {
  var utcDay = DateTime.utc(from.year, from.month, from.day);
  List<tz.TZDateTime> days = [];
  for (var i = 0; i < count; ++i) {
    days.add(tz.TZDateTime(
        from.location, utcDay.year, utcDay.month, utcDay.day, 12));
    // UTC is not affected by DST, so adding by 1 day is safe.
    utcDay = utcDay.add(const Duration(days: 1));
  }
  return days;
}

const bgColor1 = Color(0x04000000);
const bgColor2 = Color(0x08000000);

class MultiDayInfo extends StatelessWidget {
  final double latitude;
  final double longitude;
  final tz.Location location;
  final List<tz.TZDateTime> days;
  final String title;

  static const rowHeight = 32.0;
  static const headerRowPadding = EdgeInsets.symmetric(vertical: 8);

  String sunrise(tz.TZDateTime dateTime) {
    return shortTime(timeOfSolarElevation(dateTime, latitude, longitude,
        apparentHorizon, SolarPosition.beforeSolarNoon));
  }

  String sunset(tz.TZDateTime dateTime) {
    return shortTime(timeOfSolarElevation(dateTime, latitude, longitude,
        apparentHorizon, SolarPosition.afterSolarNoon));
  }

  String civilTwilightStart(tz.TZDateTime dateTime) {
    return shortTime(timeOfSolarElevation(dateTime, latitude, longitude,
        civilTwilight, SolarPosition.beforeSolarNoon));
  }

  String civilTwilightEnd(tz.TZDateTime dateTime) {
    return shortTime(timeOfSolarElevation(dateTime, latitude, longitude,
        civilTwilight, SolarPosition.afterSolarNoon));
  }

  const MultiDayInfo(
      {required this.latitude,
      required this.longitude,
      required this.location,
      required this.days,
      this.title = 'Sunrise and Sunset Times',
      super.key});

  TableRow tableHeader() {
    const labels = [
      'Civil Twilight Start',
      'Sunrise',
      'Sunset',
      'Civil Twilight End'
    ];
    return TableRow(
      decoration: const BoxDecoration(color: bgColor1),
      children: <Widget>[
        // Hack that works only if the cell is not the tallest, which may not be
        // true for all languages.
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            alignment: Alignment.center,
            color: bgColor2,
            child: const Text(
              'Date',
              maxLines: 10,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ...labels.map(
          (text) => Container(
            alignment: Alignment.center,
            padding: headerRowPadding,
            child: Text(
              text,
              maxLines: 10,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  TableRow tableRow(tz.TZDateTime dateTime) {
    final funcList = [civilTwilightStart, sunrise, sunset, civilTwilightEnd];
    return TableRow(children: <Widget>[
      Container(
        alignment: Alignment.center,
        color: bgColor2,
        height: rowHeight,
        child: Text(shortDate(dateTime), textAlign: TextAlign.center),
      ),
      ...funcList.map(
        (func) => Container(
          alignment: Alignment.center,
          height: rowHeight,
          child: Text(func(dateTime), textAlign: TextAlign.center),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var headingStyle = Theme.of(context).textTheme.headlineSmall;
    var borderSide =
        BorderSide(color: Theme.of(context).dividerColor, width: 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: headingStyle),
        const SizedBox(height: 16),
        Table(
          border: TableBorder(horizontalInside: borderSide),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [tableHeader(), ...days.map(tableRow).toList()],
        ),
      ],
    );
  }
}
