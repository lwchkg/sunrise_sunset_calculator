import 'package:shared_preferences/shared_preferences.dart';

typedef BrightnessListener = Function(String);

const String prefBrightness = 'brightness';

class Settings {
  static final Settings _self = Settings._();
  late SharedPreferences _store;

  late String _brightness;
  final _brightnessListeners = <BrightnessListener>[];

  Settings._();

  static Settings getInstance() => _self;

  static Future<void> init() async {
    Settings instance = getInstance();
    instance._store = await SharedPreferences.getInstance();
    instance._brightness =
        instance._store.getString(prefBrightness) ?? 'system';
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
