import 'dart:convert';
import 'dart:io';

import 'package:make_sleep_better/src/obj/data.dart';
import 'package:path_provider/path_provider.dart';

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
    try {
      final file = await _localFile;

      // Read the file.
      final String contents = await file.readAsString();

      return contents ?? '';
    } catch (e) {
      // If encountering an error, return 0.
      return '';
    }
  }

  Future<File> addData(DateTime time) async {
    final data = Data(timeWakeUp: time, feedback: false, level: 0);
    final String readDataFromFile = await readData();
    List<Data> listData;
    if (readDataFromFile.isEmpty) {
      //make a new list<data> and encode to json then write to filestore
      listData = [data];
    } else {
      //if not empty, must read data=>convert to listdata=>add new data
      // =>encode to json=> write to filestore

      final listDataFromFile = jsonDecode(readDataFromFile) as List;
      listData = listDataFromFile.map((e) => Data.fromMap(e)).toList()
        ..add(data);
//      print(listData);
    }

    final String result = jsonEncode(listData);
//    print('write data to file:$result');
    return await writeData(result);
  }

  Future<File> updateData(List<Data> datas) async{
    final String result = jsonEncode(datas);
//    print('write data to file:$result');
    return await writeData(result);
  }
}
