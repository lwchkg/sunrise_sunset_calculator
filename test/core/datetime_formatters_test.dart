import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:sunrise_sunset_calculator/core/datetime_formatters.dart';

main() {
  tz.initializeTimeZones();

  test('roundToNearestMinute', () {
    final location = tz.getLocation('America/New_York');
    expect(
        roundToNearestMinute(tz.TZDateTime(location, 2022, 5, 12, 2, 15, 25)),
        tz.TZDateTime(location, 2022, 5, 12, 2, 15));
    expect(
        roundToNearestMinute(tz.TZDateTime(location, 2022, 5, 12, 2, 15, 40)),
        tz.TZDateTime(location, 2022, 5, 12, 2, 16));

    expect(
        roundToNearestMinute(
            tz.TZDateTime(location, 2022, 5, 12, 2, 15, 29, 999, 999)),
        tz.TZDateTime(location, 2022, 5, 12, 2, 15));
    expect(
        roundToNearestMinute(tz.TZDateTime(location, 2022, 5, 12, 2, 15, 30)),
        tz.TZDateTime(location, 2022, 5, 12, 2, 16));
    expect(
        roundToNearestMinute(
            tz.TZDateTime(location, 2022, 5, 12, 2, 15, 30, 0, 1)),
        tz.TZDateTime(location, 2022, 5, 12, 2, 16));
    expect(
        roundToNearestMinute(
            tz.TZDateTime(location, 2022, 5, 12, 2, 15, 30, 1, 0)),
        tz.TZDateTime(location, 2022, 5, 12, 2, 16));
  });

  test('shortTime', () {
    expect(shortTime(null), '-');

    final location = tz.getLocation('America/New_York');
    expect(shortTime(tz.TZDateTime(location, 2022, 5, 12, 3, 25, 29)), '03:25');
    expect(shortTime(tz.TZDateTime(location, 2022, 5, 12, 3, 25, 30)), '03:26');
  });

  test('longTime', () {
    final location = tz.getLocation('America/New_York');
    final referenceTime = tz.TZDateTime(location, 2022, 5, 12, 23);

    expect(longTime(null, referenceTime), 'nil');

    expect(
        longTime(
            tz.TZDateTime(location, 2022, 5, 12, 3, 25, 29), referenceTime),
        '03:25');
    expect(
        longTime(
            tz.TZDateTime(location, 2022, 5, 12, 3, 25, 30), referenceTime),
        '03:26');

    expect(
        longTime(tz.TZDateTime(location, 2022, 5, 13, 0, 0, 29), referenceTime),
        '00:00 (+1 day)');
    expect(
        longTime(tz.TZDateTime(location, 2022, 5, 13, 0, 0, 30), referenceTime),
        '00:01 (+1 day)');

    expect(
        longTime(
            tz.TZDateTime(location, 2022, 5, 12, 23, 59, 29), referenceTime),
        '23:59');
    expect(
        longTime(
            tz.TZDateTime(location, 2022, 5, 12, 23, 59, 30), referenceTime),
        '00:00 (+1 day)');

    // \u2212 is the minus sign.
    expect(
        longTime(
            tz.TZDateTime(location, 2022, 5, 11, 23, 59, 29), referenceTime),
        '23:59 (\u22121 day)');
    expect(
        longTime(
            tz.TZDateTime(location, 2022, 5, 11, 23, 59, 30), referenceTime),
        '00:00');
  });
}
