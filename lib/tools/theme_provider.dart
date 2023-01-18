import 'package:flutter/material.dart';

// Provider to handle theme changes

class ThemeProvider with ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;

  ThemeMode get currentTheme => _currentTheme;

  set currentTheme(ThemeMode theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}