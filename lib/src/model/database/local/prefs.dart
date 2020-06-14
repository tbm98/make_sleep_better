import 'package:shared_preferences/shared_preferences.dart';

class PrefsSupport {
  PrefsSupport() {
    _init();
  }

  static const String store_key = 'make_sleep_better';
  static const String delay_minute_key = 'delay_minute';
  static const String dark_mode = 'dark_mode';
  Future<SharedPreferences> _prefs;

  void _init() {
    _prefs = SharedPreferences.getInstance();
  }

  Future<bool> saveDarkMode(bool value) async {
    return (await _prefs).setBool(dark_mode, value);
  }

  Future<bool> getDarkMode() async {
    await Future.delayed(const Duration(seconds: 1));
    return (await _prefs).getBool(dark_mode) ?? false;
  }

  Future<bool> saveDelayMinute(int delayMinute) async {
    return (await _prefs).setInt(delay_minute_key, delayMinute);
  }

  Future<int> getDelayMinute() async {
    return (await _prefs).getInt(delay_minute_key) ?? 14;
  }
}
