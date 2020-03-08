import 'dart:io';

import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/supports/notifications.dart';
import 'package:make_sleep_better/src/supports/prefs.dart';
import '../supports/file_store.dart';
import '../supports/strings.dart';

class MainProvider extends ChangeNotifier {
  MainProvider() {
    _fileStore = const FileStore();
    _prefsSupport = PrefsSupport();
    _initLoad();
  }

  PrefsSupport _prefsSupport;
  FileStore _fileStore;
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void _initLoad() async {
    _darkMode = await _prefsSupport.getDarkMode();
    notifyListeners();
  }

  void switchBrightnessMode() async {
    _darkMode = !_darkMode;
    await _prefsSupport.saveDarkMode(_darkMode);
    notifyListeners();
  }

  Color getColorOfCycle(int cycle) {
    if (cycle >= 3 && cycle <= 6) {
      return Colors.green;
    }
    return Colors.red;
  }

  IconData getIconOfCycle(int cycle) {
    if (cycle >= 3 && cycle <= 6) {
      return Icons.sentiment_satisfied;
    }
    return Icons.sentiment_dissatisfied;
  }

  String getSuggest(int cycle, int delayMinute) {
    return '${Strings.suggest_cycle[cycle - 1]} - '
        '${Strings.time_cycle[cycle - 1]} + ${delayMinute}p';
  }

  Future<File> addData(
      DateTime timeWakeup, DateTime timeSleep, int cycle) async {
    return await _fileStore.addData(timeWakeup, timeSleep, cycle);
  }

  void setScheduleNotification(DateTime timeWakeup, DateTime now, int cycle,
      int delayMinutes, BuildContext context) {
    final int minutes = cycle * 90 + delayMinutes;
    final timeForSleep = Duration(hours: minutes ~/ 60, minutes: minutes % 60);
    NotificationSupport.instance(context)
        .addNotifiSchedule(timeWakeup, timeForSleep);
  }
}
