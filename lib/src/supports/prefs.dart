import 'package:shared_preferences/shared_preferences.dart';

class PrefsSupport {
  PrefsSupport() {
    _init();
  }

  static const String store_key = 'make_sleep_better';
  static const String delay_minute_key = 'delay_minute';
  Future<SharedPreferences> _prefs;

  void _init() {
    _prefs = SharedPreferences.getInstance();
  }

  Future<bool> saveDelayMinute(int delayMinute) async {
    return (await _prefs).setInt(delay_minute_key, delayMinute);
  }

  Future<int> getDelayMinute() async {
    await Future.delayed(const Duration(seconds: 1));
    return (await _prefs).getInt(delay_minute_key) ?? 14;
  }
}
