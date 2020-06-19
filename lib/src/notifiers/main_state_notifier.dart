import 'dart:io';

import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

import '../helpers/notifications.dart';
import '../helpers/strings.dart';
import '../model/database/local/file_store.dart';
import '../model/database/local/prefs.dart';
import 'main_state.dart';

class MainStateNotifier extends StateNotifier<MainState> with LocatorMixin {
  MainStateNotifier() : super(const MainState());

  PrefsSupport get _prefs => read<PrefsSupport>();

  FileStore get _fileStore => read<FileStore>();

  @override
  void initState() {
    _initLoad();
  }

  void _initLoad() async {
    final darkMode = await _prefs.getDarkMode();
    state = MainState(darkMode: darkMode);
  }

  void switchBrightnessMode() async {
    state = state.toggle();
    await _prefs.saveDarkMode(state.darkMode);
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
