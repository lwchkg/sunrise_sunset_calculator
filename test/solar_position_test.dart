import 'package:sunrise_sunset_calculator/solar_position.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:test/test.dart';

void main() {
  test('Solar position UTC one iteration', () {
    // The cases in this test are validated against the results in NOAA solar
    // calculation worksheet.

    // Normal case.
    expect(
        timeOfSolarElevationOneIteration(DateTime.utc(2023, 3, 15), 30, -82,
            apparentHorizon, SolarPosition.beforeSolarNoon),
        const Duration(
            hours: 11, minutes: 38, seconds: 37, microseconds: 683430));

    // Case with expected result above 24 hours.
    expect(
        timeOfSolarElevationOneIteration(DateTime.utc(2023, 3, 20), 30, -82,
            civilTwilight, SolarPosition.afterSolarNoon),
        const Duration(
            hours: 24, minutes: 2, seconds: 34, microseconds: 689949));

    // Case with expected result below zero.
    expect(
        timeOfSolarElevationOneIteration(DateTime.utc(2023, 3, 20), 20, 120,
            civilTwilight, SolarPosition.beforeSolarNoon),
        const Duration(
            hours: -2, minutes: -17, seconds: -22, microseconds: -188119));
  });

  test('Solar position UTC non-existent', () {
    // Case with the sun always below the stated elevation.
    expect(
        timeOfSolarElevationOneIteration(DateTime.utc(2023, 12, 20), 80, 50,
            apparentHorizon, SolarPosition.afterSolarNoon),
        null);

    // Case with the sun always above the stated elevation.
    expect(
        timeOfSolarElevationOneIteration(DateTime.utc(2023, 12, 20), -70, 50,
            civilTwilight, SolarPosition.afterSolarNoon),
        null);
  });

  test('Solar position multi-pass', () {
    tz.initializeTimeZones();

    expect(
        timeOfSolarElevation(
                tz.TZDateTime.from(DateTime.utc(2023, 3, 16),
                    tz.getLocation('America/New_York')),
                30,
                -82,
                apparentHorizon,
                SolarPosition.beforeSolarNoon)
            ?.toUtc(),
        DateTime.utc(2023, 3, 15, 11, 38, 3, 0, 003896));

    expect(
        timeOfSolarElevation(
                tz.TZDateTime.from(DateTime.utc(2023, 3, 21),
                    tz.getLocation('America/New_York')),
                30,
                -82,
                civilTwilight,
                SolarPosition.afterSolarNoon)
            ?.toUtc(),
        DateTime.utc(2023, 3, 21, 0, 3, 12, 0, 177438));

    expect(
        timeOfSolarElevation(
                tz.TZDateTime.from(
                    DateTime.utc(2023, 3, 20), tz.getLocation('Asia/Manila')),
                20,
                120,
                civilTwilight,
                SolarPosition.beforeSolarNoon)
            ?.toUtc(),
        DateTime.utc(2023, 3, 19, 21, 42, 42, 0, 802339));

    expect(
        timeOfSolarElevation(
                tz.TZDateTime.from(DateTime.utc(2021, 5, 15),
                    tz.getLocation('Asia/Srednekolymsk')),
                70,
                150,
                apparentHorizon,
                SolarPosition.beforeSolarNoon)
            ?.toUtc(),
        DateTime.utc(2021, 5, 14, 14, 43, 28, 0, 210493));
  });

  test('Solar azimuth angle', () {
    // The cases in this test are validated against the results in NOAA solar
    // calculation worksheet.

    // Morning: less than 180 degrees.
    expect(
        solarAzimuthAngle(
            tz.TZDateTime(tz.getLocation('America/New_York'), 2023, 3, 15, 8),
            30,
            -82),
        94.73345656796909);
    // Afternoon: greater than 180 degrees.
    expect(
        solarAzimuthAngle(
            tz.TZDateTime(tz.getLocation('America/New_York'), 2023, 3, 15, 20),
            30,
            -82),
        271.2246075210496);

    expect(
        solarAzimuthAngle(
            tz.TZDateTime(
                tz.getLocation('Asia/Srednekolymsk'), 2021, 5, 15, 11),
            70,
            150),
        145.38164506747705);
  });

  test('Solar azimuth angle across timezones', () {
    final dateTime =
        tz.TZDateTime(tz.getLocation('America/New_York'), 2023, 3, 15, 18);
    final dateTimeDifferentTimeZone =
        tz.TZDateTime.from(dateTime, tz.getLocation('Australia/Sydney'));
    // The azimuth angle should not depend on the time zone.
    expect(solarAzimuthAngle(dateTimeDifferentTimeZone, 30, -82),
        solarAzimuthAngle(dateTime, 30, -82));
  });
}
