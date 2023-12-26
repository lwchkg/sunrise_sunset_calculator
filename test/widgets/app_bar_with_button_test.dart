import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunrise_sunset_calculator/utils/brightness.dart';

import 'package:sunrise_sunset_calculator/utils/settings.dart';
import 'package:sunrise_sunset_calculator/widgets/app_bar_with_button.dart';

void main() {
  testWidgets('Dark mode tests', (WidgetTester tester) async {
    MaterialApp app() {
      // Cannot use const constructor because the dark/light mode button built
      // depends on the brightness setting.
      // ignore: prefer_const_constructors
      return MaterialApp(home: Scaffold(appBar: AppBarWithButton()));
    }

    SharedPreferences.setMockInitialValues({Settings.prefBrightness: 'light'});
    Settings.init();
    expect(getCurrentBrightness(), Brightness.light);

    // Now the app should be in light mode.
    await tester.pumpWidget(app());

    final darkModeButton = find.byIcon(Icons.dark_mode);
    expect(darkModeButton, findsOneWidget);
    await tester.tap(darkModeButton);

    // Rebuild app in dark mode to load the new button.
    await tester.pumpWidget(app());

    expect(find.byIcon(Icons.dark_mode), findsNothing);
    final lightModeButton = find.byIcon(Icons.light_mode);
    expect(lightModeButton, findsOneWidget);
    await tester.tap(lightModeButton);

    // Rebuild app in light mode to load the new button.
    await tester.pumpWidget(app());

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    expect(find.byIcon(Icons.light_mode), findsNothing);
  });
}
