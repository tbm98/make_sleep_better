// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:make_sleep_better/main.dart';
import 'package:make_sleep_better/src/obj/data.dart';
import 'package:make_sleep_better/src/supports/file_store.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    Data data = Data(timeWakeUp: DateTime.now(), feedback: true, level: 2);

    //test json convert
    print(jsonEncode(data));
//    const FileStore fileStore = FileStore();
//    String value = await fileStore.readData();
//    print('value is:$value');
    final List<Data> listData = [data, data];
    String result = jsonEncode(listData);
    print(result);

    final listDynamic = jsonDecode(result) as List;
    print(jsonEncode(
        listDynamic.map((e) => Data.fromMap(e)).toList()..add(data)));

    //test decode empty string
    try {
      final a = jsonDecode('') as List;
      expect(a, null);
    } catch (e) {
      expect(e, isNotNull);
    }
    try {
      final a = jsonDecode('[]') as List;
      expect(a, isNotNull);
    } catch (e) {
      expect(e, null);
    }
  });
}
