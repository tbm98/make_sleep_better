import 'dart:convert';

import 'package:flutter/material.dart';
import '../supports/file_store.dart';
import '../obj/data.dart';
import '../supports/strings.dart';

class MainProvider extends ChangeNotifier {
  MainProvider() {
    _fileStore = const FileStore();
    _testReadFile();
  }

  void _testReadFile() async {
    print('data from file: ${await _fileStore.readData()}');
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

  void addData(DateTime time) async {
    final data = Data(timeWakeUp: time, feedback: false, level: 0);
    final String readData = await _fileStore.readData();
    List<Data> listData;
    if (readData.isEmpty) {
      //make a new list<data> and encode to json then write to filestore
      listData = [data];
    } else {
      //if not empty, must read data=>convert to listdata=>add new data
      // =>encode to json=> write to filestore

      final listDataFromFile = jsonDecode(readData) as List;
      listData = listDataFromFile.map((e) => Data.fromMap(e)).toList();
      listData.add(data);
//      print(listData);
    }

    final String result = jsonEncode(listData);
//    print('write data to file:$result');
    await _fileStore.writeData(result);
  }
}
