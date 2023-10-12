import 'package:flutter/material.dart';

// Provider for toggling between hidden and visible amounts
class HiddenAmountsProvider with ChangeNotifier {
  bool _hiddenAmounts = false;

  bool get hiddenAmounts => _hiddenAmounts;

  set hiddenAmounts(bool hidden) {
    _hiddenAmounts = hidden;
    notifyListeners();
  }
}