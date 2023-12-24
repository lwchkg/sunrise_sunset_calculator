import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.title = ""});

  final String title;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _platformDispatcher = SchedulerBinding.instance.platformDispatcher;
  var _brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    _platformDispatcher.onPlatformBrightnessChanged = () {
      setState(() {
        _brightness = _platformDispatcher.platformBrightness;
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sunrise and Sunset Times',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: _brightness),
        // Override platform specific defaults.
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.standard,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
