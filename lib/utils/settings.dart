typedef BrightnessListener = Function(String);

class Settings {
  static final Settings _self = Settings._();

  String _brightness = "system";
  final _brightnessListeners = <BrightnessListener>[];

  Settings._();

  static Settings get() => _self;

  String getBrightness() => _brightness;

  void setBrightness(String newBrightness) {
    if (newBrightness == _brightness) return;
    _brightness = newBrightness;
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
