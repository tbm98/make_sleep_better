import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/supports/logs.dart';
import 'src/providers/main.dart';
import 'src/pages/home.dart';
import 'src/supports/prefs.dart';

void main() => runApp(MultiProvider(providers: [
      Provider<PrefsSupport>(
        create: (_) => PrefsSupport(),
      ),
      ChangeNotifierProvider(
        create: (_) => MainProvider(),
      )
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MainProvider, bool>(
      selector: (context, notifier) => notifier.darkMode,
      builder: (context, data, child) {
        logs('rebuild material app');

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Make sleep better',
//          theme: data ? ThemeData.dark() : ThemeData.light(),
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
