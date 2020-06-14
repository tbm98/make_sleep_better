import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import 'src/helpers/logs.dart';
import 'src/model/database/local/prefs.dart';
import 'src/notifiers/main.dart';
import 'src/notifiers/main_state.dart';
import 'src/presentation/screens/home.dart';

void main() => runApp(MultiProvider(providers: [
      Provider<PrefsSupport>(
        create: (_) => PrefsSupport(),
      ),
      StateNotifierProvider<MainNotifier, MainState>(
        create: (_) => MainNotifier(),
      )
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MainState, bool>(
      selector: (context, state) => state.darkMode,
      builder: (context, data, child) {
        logs('rebuild material app');

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Make sleep better - Giúp giấc ngủ tốt hơn',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: data ? Brightness.dark : Brightness.light),
          home: child,
        );
      },
      child: HomePage(),
    );
  }
}
