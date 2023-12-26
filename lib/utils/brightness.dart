import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sunrise_sunset_calculator/utils/settings.dart';

Brightness getCurrentBrightness() {
  String brightness = Settings.getInstance().getBrightness();
  if (brightness == "light") return Brightness.light;
  if (brightness == "dark") return Brightness.dark;
  return SchedulerBinding.instance.platformDispatcher.platformBrightness;
}
