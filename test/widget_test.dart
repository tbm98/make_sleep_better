// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:make_sleep_better/main.dart';
import 'package:make_sleep_better/src/model/database/local/prefs.dart';
import 'package:make_sleep_better/src/notifiers/main.dart';
import 'package:make_sleep_better/src/notifiers/main_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
//    final Data data =
//        Data(timeWakeUp: DateTime.now(), feedback: true, level: 2);

    //test json convert
//    logs(jsonEncode(data));
//    const FileStore fileStore = FileStore();
//    String value = await fileStore.readData();
//    print('value is:$value');
//    final List<Data> listData = [data, data];
//    final String result = jsonEncode(listData);
//    logs(result);

//    final listDynamic = jsonDecode(result) as List;
//    logs(jsonEncode(
//        listDynamic.map((e) => Data.fromMap(e)).toList()..add(data)));

    //test decode empty string
//    try {
//      final a = jsonDecode('') as List;
//      expect(a, null);
//    } catch (e) {
//      expect(e, isNotNull);
//    }
//    try {
//      final a = jsonDecode('[]') as List;
//      expect(a, isNotNull);
//    } catch (e) {
//      expect(e, null);
//    }

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<PrefsSupport>(
        create: (_) => PrefsSupport(),
      ),
      StateNotifierProvider<MainNotifier, MainState>(
        create: (_) => MainNotifier(),
      )
    ], child: MyApp()));
  });
}
