import 'package:test/test.dart';

import 'package:sunrise_sunset_calculator/core/number_formatters.dart';

main() {
  test('isLatitude', () {
    expect(isLatitude('0'), true);
    expect(isLatitude('90'), true);
    expect(isLatitude('-90'), true);
    expect(isLatitude('90.1'), false);
    expect(isLatitude('-90.1'), false);
    expect(isLatitude('1a2'), false);
  });

  test('isLongitude', () {
    expect(isLongitude('0'), true);
    expect(isLongitude('180'), true);
    expect(isLongitude('-180'), true);
    expect(isLongitude('180.1'), false);
    expect(isLongitude('-180.1'), false);
    expect(isLongitude('1a2'), false);
  });

  test('formatLatitude', () {
    expect(formatLatitude(0), '0°');
    expect(formatLatitude(12), '12.00000° N');
    expect(formatLatitude(-23.12345), '23.12345° S');
  });

  test('formatLongitude', () {
    expect(formatLongitude(0), '0°');
    expect(formatLongitude(12), '12.00000° E');
    expect(formatLongitude(-23.12345), '23.12345° W');
  });
}
