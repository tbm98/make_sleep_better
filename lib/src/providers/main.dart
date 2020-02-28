import 'dart:io';

import 'package:flutter/material.dart';
import '../supports/file_store.dart';
import '../supports/strings.dart';

class MainProvider extends ChangeNotifier {
  MainProvider() {
    _fileStore = const FileStore();
  }

  FileStore _fileStore;
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void switchBrightnessMode() {
    _darkMode = !_darkMode;
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

  Future<File> addData(DateTime time, DateTime now,int cycle) async {
    return await _fileStore.addData(time,now,cycle);
  }
}
