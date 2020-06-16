import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../entities/data.dart';

class FileStore {
  const FileStore();

  static const String file_name = 'data.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$file_name');
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    // await delay for app look like smooth
//    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final file = await _localFile;

      // Read the file.
      final String contents = await file.readAsString();
      //fake
//      return '[{"timeSleep":"null","timeWakeUp":"2020-02-28 14:32:59.471543","cycleSleep":null,"feedback":true,"level":2},{"timeSleep":"null","timeWakeUp":"2020-02-28 14:32:59.471543","cycleSleep":null,"feedback":true,"level":2}]';
      return contents ?? '[]';
    } catch (e) {
      // If encountering an error, return 0.
      return '[]';
    }
  }

  Future<List<Data>> readDataToList() async {
    // await delay for app look like smooth

//    await Future.delayed(const Duration(milliseconds: 500));

    final String readDataFromFile = await readData();

    //if not empty, must read data=>convert to listdata=>add new data
    // =>encode to json=> write to filestore
    final listDataFromFile = jsonDecode(readDataFromFile) as List;
    return listDataFromFile.map((e) => Data.fromJson(e)).toList();
  }

  Future<File> addData(
      DateTime timeWakeup, DateTime timeSleep, int cycle) async {
    final data = Data(
        timeSleep: timeSleep,
        timeWakeUp: timeWakeup,
        cycleSleep: cycle,
        feedback: false,
        level: 0);
    final String readDataFromFile = await readData();
    List<Data> listData;
    if (readDataFromFile.isEmpty) {
      //make a new list<data> and encode to json then write to filestore
      listData = [data];
    } else {
      //if not empty, must read data=>convert to listdata=>add new data
      // =>encode to json=> write to filestore

      final listDataFromFile = jsonDecode(readDataFromFile) as List;
      listData = listDataFromFile.map((e) => Data.fromJson(e)).toList()
        ..add(data);
//      print(listData);
    }

    final String result = jsonEncode(listData);
//    print('write data to file:$result');
    return await writeData(result);
  }

  Future<File> updateData(Data data) async {
    final listData = await readDataToList();
    for (int i = 0; i < listData.length; i++) {
      if (listData[i].id == data.id) {
        listData[i] = data;
      }
    }
    final String result = jsonEncode(listData);
//    print('write data to file:$result');
    return await writeData(result);
  }

  Future<File> removeData(Data data) async {
    var listData = await readDataToList();
    listData = listData..removeWhere((dt) => dt.id == data.id);
    final String result = jsonEncode(listData);
    return await writeData(result);
  }
}
