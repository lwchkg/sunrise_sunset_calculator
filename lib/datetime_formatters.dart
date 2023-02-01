import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

int floorDivide(int a, int b) {
  if (a >= 0) return a ~/ b;
  int q = a ~/ b;
  return a % b == 0 ? q : q - 1;
}

String shortTime(tz.TZDateTime? localTime) =>
  localTime == null ? '-' : DateFormat.Hm().format(localTime);

String longTime(tz.TZDateTime? localTime, DateTime reference) {
  if (localTime == null) return 'nil';

  var location = localTime.location;
  var localReference = tz.TZDateTime.from(reference, location);

  String timeString = DateFormat.Hm().format(localTime);
  if (localTime.day == localReference.day) {
    return timeString;
  }

  Duration interval =
  tz.TZDateTime(location, localTime.year, localTime.month, localTime.day)
      .difference(tz.TZDateTime(location, localReference.year,
      localReference.month, localReference.day));
  int dayDifference =
  floorDivide((interval + const Duration(hours: 12)).inHours, 24);
  String sign = dayDifference > 0 ? '+' : '\u2212';
  return '$timeString ($sign${dayDifference.abs()} day)';
}

String shortDate(tz.TZDateTime localTime) {
  return DateFormat.MMMd().format(localTime);
}
