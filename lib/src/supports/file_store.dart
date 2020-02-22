import 'dart:io';

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
}
