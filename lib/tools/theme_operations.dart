import 'package:flutter/material.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/secure_storage.dart';
import 'package:indexax/models/theme_preference_data.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/theme_provider.dart';

final _storage = SecureStorage();

Future<ThemePreference?> readThemePreference(BuildContext context) async {
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
    BuildContext context, ThemePreference themePreference) async {
  try {
  await _storage.storeKey(
      keyName: "themePreference",
      value: themePreference.toString().split(".").last);
} on Exception catch (e) {
    snackbar.showInSnackBar(context, e.toString());
  }
}
Brightness getCurrentSystemTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness;
}

void updateTheme(BuildContext context) async {
  print("Updating theme");
  ThemePreference? currentThemePreference = await readThemePreference(context);
  if (currentThemePreference == null) {
    currentThemePreference = ThemePreference.system;
    await storeThemePreference(context, ThemePreference.system);
  }
  if (currentThemePreference == ThemePreference.system) {
    Provider.of<ThemeProvider>(context, listen: false).currentTheme =
        ThemeMode.values.byName(MediaQuery.of(context)
            .platformBrightness
            .toString()
            .split(".")
            .last);
  } else {
    Provider.of<ThemeProvider>(context, listen: false).currentTheme = ThemeMode
        .values
        .byName(currentThemePreference.toString().split(".").last);
  }
}
