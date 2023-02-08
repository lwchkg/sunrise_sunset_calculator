import 'dart:math';

import 'package:timezone/timezone.dart' as tz;

enum SolarPosition { beforeSolarNoon, afterSolarNoon }

// Common elevation of the sun, in degrees.
const apparentHorizon = -0.833;
const civilTwilight = -6.0;
const nauticalTwilight = -12.0;
const astronomicalTwilight = -18.0;

// Degree and radian conversions.
double radians(double degrees) => degrees / 180 * pi;
double degrees(double radians) => radians / pi * 180;

class _SunParameters {
  double equationOfTime; // In minutes of time.
  double declinationRadian;
  _SunParameters(
      {required this.equationOfTime, required this.declinationRadian});
}

_SunParameters _calculateSunParameters(DateTime dateTimeUtc) {
  final baseDate = DateTime.utc(2000, 1, 1);
  const baseDateJulian = 2451545;

  final julianDay = dateTimeUtc.difference(baseDate).inMicroseconds /
          Duration.microsecondsPerDay +
      baseDateJulian -
      0.5;

  final julianCentury = (julianDay - baseDateJulian) / 36525;

  final meanSolarLongitude =
      (280.46646 + julianCentury * (36000.76983 + 0.0003032 * julianCentury)) %
          360;
  final meanSolarLongitudeRadian = radians(meanSolarLongitude);

  final meanAnomaly =
      (357.52911 + julianCentury * (35999.05029 - 0.0001537 * julianCentury)) %
          360;
  final meanAnomalyRad = radians(meanAnomaly);

  final eccentricity = 0.016708634 -
      julianCentury * (0.000042037 + 0.0000001267 * julianCentury);

  final eqCenter = sin(meanAnomalyRad) *
          (1.914602 - julianCentury * (0.004817 + 0.000014 * julianCentury)) +
      sin(2 * meanAnomalyRad) * (0.019993 - 0.000101 * julianCentury) +
      sin(3 * meanAnomalyRad) * 0.000289;

  final trueSolarLongitude = meanSolarLongitude + eqCenter;

  final omegaRadian = radians(125.04 - 1934.136 * julianCentury);

  final apparentSolarLongitude =
      trueSolarLongitude - 0.00569 - 0.00478 * sin(omegaRadian);
  final apparentSolarLongitudeRadian = radians(apparentSolarLongitude);

  final meanObliquity = 23 +
      (26 +
              ((21.448 -
                      julianCentury *
                          (46.815 +
                              julianCentury *
                                  (0.00059 - julianCentury * 0.001813)))) /
                  60) /
          60;

  final corrObliquity = meanObliquity + 0.00256 * cos(omegaRadian);
  final corrObliquityRadian = radians(corrObliquity);

  final solarDeclinationRadian =
      asin(sin(corrObliquityRadian) * sin(apparentSolarLongitudeRadian));

  var y = tan(corrObliquityRadian / 2);
  y = y * y;

  final equationOfTime = 4 *
      degrees(y * sin(2 * meanSolarLongitudeRadian) -
          2 * eccentricity * sin(meanAnomalyRad) +
          4 *
              eccentricity *
              y *
              sin(meanAnomalyRad) *
              cos(2 * meanSolarLongitudeRadian) -
          0.5 * y * y * sin(4 * meanSolarLongitudeRadian) -
          1.25 * eccentricity * eccentricity * sin(2 * meanAnomalyRad));

  return _SunParameters(
      equationOfTime: equationOfTime,
      declinationRadian: solarDeclinationRadian);
}

/// Calculate the time when the sun is at a certain [elevation] from the
/// horizon. [latitude], [longitude] and [elevation] are in degrees.
/// [solarPosition] determines whether the time before or after the solar noon
/// should be returned.
///
/// See https://gml.noaa.gov/grad/solcalc/calcdetails.html for the algorithm
/// used in the calculations.
///
/// The return value is a duration from UTC midnight, which can go outside both
/// ends of the interval [0 hours, 24 hours]. A duration is returned because the
/// same duration can be added to different dates in different situations.
/// If the sun does not reach the elevation, returns null.
///
/// Note: UTC time is used because the local time still has a time difference
/// from the longitude, which continues to make the return value go outside the
/// interval [0 hours, 24 hours]. In addition, complications in daylight saving
/// time makes local time extremely difficult to handle correctly.
Duration? timeOfSolarElevationOneIteration(
    DateTime dateTimeUtc,
    double latitude,
    double longitude,
    double elevation,
    SolarPosition solarPosition) {
  final sun = _calculateSunParameters(dateTimeUtc);

  final solarNoonPastMidnight = 720 - 4 * longitude - sun.equationOfTime;

  final latitudeRadian = radians(latitude);
  final elevationRadian = radians(elevation);

  final cosineHourAngleSunset = sin(elevationRadian) /
          (cos(latitudeRadian) * cos(sun.declinationRadian)) -
      tan(latitudeRadian) * tan(sun.declinationRadian);

  // The sun does not pass through the required elevation if the angle cannot be
  // found.
  if (cosineHourAngleSunset > 1 || cosineHourAngleSunset < -1) return null;

  final hourAngle = degrees(acos(cosineHourAngleSunset));

  final timePastMidnight = solarPosition == SolarPosition.beforeSolarNoon
      ? solarNoonPastMidnight - hourAngle * 4
      : solarNoonPastMidnight + hourAngle * 4;
  final time = Duration(
      microseconds:
          (timePastMidnight * Duration.microsecondsPerMinute).round());

  return time;
}

/// Calculate the time when the sun is at a certain [elevation] from the
/// horizon. [latitude], [longitude] and [elevation] are in degrees.
/// [solarPosition] determines whether the time before or after the solar noon
/// should be returned.
///
/// This function runs [timeOfSolarElevationOneIteration] multiple times to
/// improve the accuracy of the calculation.
///
/// Returns a [DateTime] in the same location of [localTime] if the time exists,
/// or null if not. In some cases the time can be in the next or previous day,
/// even after time zone adjustment.
tz.TZDateTime? timeOfSolarElevation(tz.TZDateTime localTime, double latitude,
    double longitude, double elevation, SolarPosition solarPosition,
    [int passes = 8]) {
  final DateTime date =
      DateTime.utc(localTime.year, localTime.month, localTime.day);
  Duration offset = localTime.difference(date);

  int currentPass = 1;
  do {
    final Duration? newOffset = timeOfSolarElevationOneIteration(
        date.add(offset), latitude, longitude, elevation, solarPosition);
    if (newOffset == null) break;
    currentPass++;

    // Early exit if converged already.
    if (offset == newOffset) break;
    offset = newOffset;
  } while (currentPass <= passes);

  // Return a value if at least one pass is non-null. I am not confident about
  // the accuracy of the calculations at extreme values, so when in doubt a time
  // is preferable to null.
  return currentPass > 1
      ? tz.TZDateTime.from(date.add(offset), localTime.location)
      : null;
}

/// Calculates the solar azimuth angle with [dateTime], [latitude] and
/// [longitude].
double solarAzimuthAngle(DateTime dateTime, double latitude, double longitude) {
  final utcTime = dateTime.toUtc();
  final sun = _calculateSunParameters(utcTime);

  final timeInMinutes = utcTime.hour * 60 +
      utcTime.minute +
      (utcTime.second + utcTime.microsecond / Duration.microsecondsPerSecond) /
          60;

  // In Dart a % b is done by Euclidean division, i.e. 0 <= r < abs(b), which
  // does not require extra processing in this case.
  final trueSolarTime = (timeInMinutes + 4 * longitude + sun.equationOfTime) %
      Duration.minutesPerDay;

  final hourAngle = 0.25 * trueSolarTime - 180;
  final hourAngleRadian = radians(hourAngle);

  final latitudeRadian = radians(latitude);
  final sineLatitude = sin(latitudeRadian);
  final cosineLatitude = cos(latitudeRadian);
  final sineDeclination = sin(sun.declinationRadian);

  final cosineZenith = sineLatitude * sineDeclination +
      cosineLatitude * cos(sun.declinationRadian) * cos(hourAngleRadian);
  final sineZenith = sqrt(1 - cosineZenith * cosineZenith);

  final cosineAzimuth = (sineDeclination - sineLatitude * cosineZenith) /
      (cosineLatitude * sineZenith);
  final azimuth = hourAngle > 0
      ? 360 - degrees(acos(cosineAzimuth))
      : degrees(acos(cosineAzimuth));

  return azimuth;
}
