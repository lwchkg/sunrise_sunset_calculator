import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:sunrise_sunset_calculator/multi_day_info.dart';

void main() {
  test('MultiDayInfo utility function: daysFrom', () {
    tz.initializeTimeZones();

    tz.Location location = tz.getLocation('America/New_York');
    expect(daysFrom(tz.TZDateTime(location, 2020, 2, 28), 3), [
      tz.TZDateTime(location, 2020, 2, 28, 12),
      tz.TZDateTime(location, 2020, 2, 29, 12),
      tz.TZDateTime(location, 2020, 3, 1, 12),
    ]);

    location = tz.getLocation('Asia/Manila');
    expect(daysFrom(tz.TZDateTime(location, 2100, 2, 28), 4), [
      tz.TZDateTime(location, 2100, 2, 28, 12),
      tz.TZDateTime(location, 2100, 3, 1, 12),
      tz.TZDateTime(location, 2100, 3, 2, 12),
      tz.TZDateTime(location, 2100, 3, 3, 12),
    ]);

    location = tz.getLocation('Europe/London');
    expect(daysFrom(tz.TZDateTime(location, 2022, 12, 31), 2), [
      tz.TZDateTime(location, 2022, 12, 31, 12),
      tz.TZDateTime(location, 2023, 1, 1, 12),
    ]);
  });

  test('MultiDayInfo utility function: daysOfMonth', () {
    tz.initializeTimeZones();

    tz.Location location = tz.getLocation('America/New_York');
    expect(daysOfMonth(tz.TZDateTime(location, 2020, 2, 28, 15)),
        daysFrom(tz.TZDateTime(location, 2020, 2, 1), 29));

    location = tz.getLocation('Asia/Manila');
    expect(daysOfMonth(tz.TZDateTime(location, 2100, 2, 14, 3)),
        daysFrom(tz.TZDateTime(location, 2100, 2, 1), 28));

    location = tz.getLocation('Europe/London');
    expect(daysOfMonth(tz.TZDateTime(location, 2022, 12, 29)),
        daysFrom(tz.TZDateTime(location, 2022, 12, 1), 31));
  });
}
