import 'package:flutter/material.dart';

class MainNotifier extends ChangeNotifier {
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void switchBrightnessMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
