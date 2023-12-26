import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef BrightnessListener = Function(String);

class Settings {
  @visibleForTesting
  static const String prefBrightness = 'brightness';

  static final Settings _self = Settings._();
  late SharedPreferences _store;

  String _brightness = 'system';
  final _brightnessListeners = <BrightnessListener>[];

  Settings._();

  static Settings getInstance() => _self;

  static Future<void> init() async {
    Settings instance = getInstance();
    instance._store = await SharedPreferences.getInstance();
    instance
        .setBrightness(instance._store.getString(prefBrightness) ?? 'system');
  }

  String getBrightness() => _brightness;

  void setBrightness(String newBrightness) {
    if (newBrightness == _brightness) return;
    _brightness = newBrightness;
    _store.setString(prefBrightness, newBrightness);
    for (var listener in _brightnessListeners) {
      listener(_brightness);
    }
  }

  void addBrightnessListener(BrightnessListener listener) {
    _brightnessListeners.add(listener);
  }

  void removeBrightnessListener(BrightnessListener listener) {
    _brightnessListeners.remove(listener);
  }
}
