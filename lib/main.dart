import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'router.dart';

void main() async {
  await findSystemLocale();
  initializeDateFormatting(Intl.systemLocale, null);
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sunrise and Sunset times',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // Override platform specific defaults`.
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.standard,
      ),
      routerConfig: router,
    );
  }
}
