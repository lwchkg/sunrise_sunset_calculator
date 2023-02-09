import 'package:intl/intl.dart';

toLocalizedString(n) =>
    NumberFormat.decimalPatternDigits(decimalDigits: 5).format(n);

bool isLatitude(String s) {
  try {
    double latitude = NumberFormat.decimalPattern().parse(s).toDouble();
    return latitude >= -90 && latitude <= 90;
  } on FormatException {
    return false;
  }
}

bool isLongitude(String s) {
  try {
    double longitude = NumberFormat.decimalPattern().parse(s).toDouble();
    return longitude >= -180 && longitude <= 180;
  } on FormatException {
    return false;
  }
}

String formatLatitude(double latitude) {
  if (latitude == 0) return '0°';
  return '${toLocalizedString(latitude.abs())}° ${latitude > 0 ? 'N' : 'S'}';
}

String formatLongitude(double longitude) {
  if (longitude == 0) return '0°';
  return '${toLocalizedString(longitude.abs())}° ${longitude > 0 ? 'E' : 'W'}';
}
