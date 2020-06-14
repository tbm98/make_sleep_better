import 'dart:io';

import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/notifiers/main_state.dart';
import 'package:state_notifier/state_notifier.dart';

import '../helpers/notifications.dart';
import '../helpers/strings.dart';
import '../model/database/local/file_store.dart';
import '../model/database/local/prefs.dart';

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier() : super(const MainState()) {
    _fileStore = const FileStore();
    _prefsSupport = PrefsSupport();
    _initLoad();
  }

  PrefsSupport _prefsSupport;
  FileStore _fileStore;

  void _initLoad() async {
    final darkMode = await _prefsSupport.getDarkMode();
    state = MainState(darkMode: darkMode);
  }

  void switchBrightnessMode() async {
    state = state.toggle();
    await _prefsSupport.saveDarkMode(state.darkMode);
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
    return '${Strings.suggestCycle[cycle - 1]} - '
        '${Strings.timeCycle[cycle - 1]} + ${delayMinute}p';
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
