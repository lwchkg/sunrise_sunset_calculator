import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sunrise_sunset_calculator/utils/settings.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    return Settings.init();
  });

  test('Brightness settings accessors', () async {
    SharedPreferences.setMockInitialValues({});
    await Settings.init();

    Settings.getInstance().setBrightness('light');
    expect(Settings.getInstance().getBrightness(), 'light');

    Settings.getInstance().setBrightness('dark');
    expect(Settings.getInstance().getBrightness(), 'dark');
  });

  test('Brightness settings default', () async {
    SharedPreferences.setMockInitialValues({});
    await Settings.init();
    expect(Settings.getInstance().getBrightness(), 'system');
  });

  test('Loading brightness setting from pref store', () async {
    SharedPreferences.setMockInitialValues({Settings.prefBrightness: 'light'});
    await Settings.init();
    expect(Settings.getInstance().getBrightness(), 'light');

    Settings.getInstance().setBrightness('dark');
    expect(Settings.getInstance().getBrightness(), 'dark');
  });

  test('Mock pref storage', () async {
    SharedPreferences.setMockInitialValues({});
    await Settings.init();
    Settings.getInstance().setBrightness('light');
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    expect(prefs.getString(Settings.prefBrightness), 'light');
  });
}
