import 'package:flutter/material.dart';

// Provider for toggling privacy mode
class PrivateModeProvider with ChangeNotifier {
  bool _privateModeEnabled = false;

  bool get privateModeEnabled => _privateModeEnabled;

  set privateModeEnabled(bool enabled) {
    _privateModeEnabled = enabled;
    notifyListeners();
  }
}
