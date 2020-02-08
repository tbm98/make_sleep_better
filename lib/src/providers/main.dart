import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/supports/strings.dart';

class MainProvider extends ChangeNotifier {
  bool _darkMode = false;

  bool get darkMode => _darkMode;



  void switchBrightnessMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  Color getColorOfCycle(int cycle) {
    if(cycle >=3 && cycle <=6){
      return Colors.green;
    }
    return Colors.red;
  }

  IconData getIconOfCycle(int cycle) {
    if(cycle >=3 && cycle <=6){
      return Icons.sentiment_satisfied;
    }
    return Icons.sentiment_dissatisfied;
  }

  String getSuggest(int cycle) {
    return Strings.suggest_cycle[cycle-1];
  }
}
