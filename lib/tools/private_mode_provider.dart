import 'package:flutter/material.dart';

// Provider for toggling between hidden and visible amounts
class PrivateModeProvider with ChangeNotifier {
  bool _privateMode = false;

  bool get privateMode => _privateMode;

  set privateMode(bool hidden) {
    _privateMode = hidden;
    notifyListeners();
  }
}
