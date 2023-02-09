import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

int _floorDivide(int a, int b) {
  if (a >= 0) return a ~/ b;
  int q = a ~/ b;
  return a % b == 0 ? q : q - 1;
}

tz.TZDateTime roundToNearestMinute(tz.TZDateTime dateTime) {
  bool isHalfMinuteOrMore = dateTime.second >= 30;

  return tz.TZDateTime(
    dateTime.location,
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute + (isHalfMinuteOrMore ? 1 : 0),
  );
}

String shortTime(tz.TZDateTime? localTime) {
  return localTime == null
      ? '-'
      : DateFormat.Hm().format(roundToNearestMinute(localTime));
}

String longTime(tz.TZDateTime? localTime, DateTime reference) {
  if (localTime == null) return 'nil';

  var location = localTime.location;
  reference = tz.TZDateTime.from(reference, location);

  localTime = roundToNearestMinute(localTime);
  String timeString = DateFormat.Hm().format(localTime);
  if (localTime.day == reference.day) {
    return timeString;
  }

  Duration interval =
      tz.TZDateTime(location, localTime.year, localTime.month, localTime.day)
          .difference(tz.TZDateTime(
              location, reference.year, reference.month, reference.day));
  int dayDifference =
      _floorDivide((interval + const Duration(hours: 12)).inHours, 24);
  // \u2212 is the minus sign.
  String sign = dayDifference > 0 ? '+' : '\u2212';
  return '$timeString ($sign${dayDifference.abs()} day)';
}

String shortDate(tz.TZDateTime localTime) {
  return DateFormat.MMMd().format(localTime);
}
