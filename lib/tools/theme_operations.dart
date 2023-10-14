import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/theme_preference_data.dart';
import 'package:indexax/tools/secure_storage.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/theme_provider.dart';
import 'package:provider/provider.dart';

// Theme-related functions are grouped here

final _storage = SecureStorage();

Future<ThemePreference?> readStoredThemePreference(BuildContext context) async {
  // Check if there's any stored theme preference
  ThemePreference? themePreference;
  try {
    String? themePreferenceString = await _storage.read('themePreference');
    if (themePreferenceString != null) {
      themePreference = ThemePreference.values.byName(themePreferenceString);
    }
  } on Exception catch (e) {
    snackbar.showInSnackBar(context, e.toString());
  }
  return themePreference;
}

Future<void> storeThemePreference(
    // Save theme preference to device
    ThemePreference themePreference) async {
  try {
    await _storage.storeKey(
        keyName: "themePreference",
        value: themePreference.toString().split(".").last);
  } on Exception {
    rethrow;
  }
}

Brightness getCurrentSystemTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness;
}

void updateTheme(BuildContext context) async {
  // Applies theme based on current theme preference and current system theme.
  // Can be called from any screen by passing its context.
  if (kDebugMode) {
    print("Updating theme");
  }

  ThemePreference? currentThemePreference =
      await readStoredThemePreference(context);
  if (currentThemePreference == null) {
    currentThemePreference = ThemePreference.system;
    try {
      await storeThemePreference(ThemePreference.system);
    } on Exception {
      rethrow;
    }
  }
  if (currentThemePreference == ThemePreference.system && context.mounted) {
    context.read<ThemeProvider>().currentTheme = ThemeMode.values.byName(
        MediaQuery.of(context).platformBrightness.toString().split(".").last);
  } else {
    if (context.mounted) {
      context.read<ThemeProvider>().currentTheme = ThemeMode.values
          .byName(currentThemePreference.toString().split(".").last);
    }
  }
}
