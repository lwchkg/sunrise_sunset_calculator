import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/datetime_formatters.dart' show longTime;
import '../core/solar_position.dart';
import '../utils/layout.dart';

class SingleDayInfo extends StatelessWidget {
  final double latitude;
  final double longitude;
  final tz.Location location;
  final DateTime now;

  tz.TZDateTime getDateTime() => tz.TZDateTime.from(now, location);

  String sunrise() {
    tz.TZDateTime? dateTime = timeOfSolarElevation(getDateTime(), latitude,
        longitude, apparentHorizon, SolarPosition.beforeSolarNoon);
    return longTime(dateTime, now);
  }

  String sunset() {
    tz.TZDateTime? dateTime = timeOfSolarElevation(getDateTime(), latitude,
        longitude, apparentHorizon, SolarPosition.afterSolarNoon);
    return longTime(dateTime, now);
  }

  String civilTwilightStart() {
    tz.TZDateTime? dateTime = timeOfSolarElevation(getDateTime(), latitude,
        longitude, civilTwilight, SolarPosition.beforeSolarNoon);
    return longTime(dateTime, now);
  }

  String civilTwilightEnd() {
    tz.TZDateTime? dateTime = timeOfSolarElevation(getDateTime(), latitude,
        longitude, civilTwilight, SolarPosition.afterSolarNoon);
    return longTime(dateTime, now);
  }

  const SingleDayInfo(
      {required this.latitude,
      required this.longitude,
      required this.location,
      required this.now,
      super.key});

  @override
  Widget build(BuildContext context) {
    final headingStyle = getHeadingStyle(context);
    final bodyTextStyle = getBodyTextStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Sunrise and sunset times', style: headingStyle),
        RichText(
          text: TextSpan(
            text: 'Civil Twilight Start: ',
            style: bodyTextStyle,
            children: [
              TextSpan(text: civilTwilightStart(), style: numberOutputStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Sunrise: ',
            style: bodyTextStyle,
            children: [
              TextSpan(text: sunrise(), style: numberOutputStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Sunset: ',
            style: bodyTextStyle,
            children: [
              TextSpan(text: sunset(), style: numberOutputStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Civil Twilight End: ',
            style: bodyTextStyle,
            children: [
              TextSpan(text: civilTwilightEnd(), style: numberOutputStyle),
            ],
          ),
        ),
      ],
    );
  }
}
