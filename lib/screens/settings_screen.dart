//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/theme_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:indexax/widgets/settings_screen/logout_popup.dart';
import 'package:indexax/screens/about_screen.dart';
import 'package:indexax/widgets/settings_screen/theme_modal_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = FlutterSecureStorage();
  ThemePreference? currentThemePreference;
  Brightness? currentSystemTheme;

  Future<ThemePreference?> findStoredThemePreference() async {
    ThemePreference? themePreference;
    try {
      Map<String, String> savedData = await _readAll();
      if (savedData['themePreference'] != null) {
        themePreference =
            ThemePreference.values.byName(savedData['themePreference']!.split(".").last);
        print('Existing theme preference detected');
      } else {
        themePreference = ThemePreference.system;
        print('No existing theme preference');
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    return themePreference;
  }

  void updateCurrentThemePreference() async {
    ThemePreference? storedThemePreference = await findStoredThemePreference();
    if (storedThemePreference == null ||
        storedThemePreference == ThemePreference.system) {
      setState(() {
        currentThemePreference = ThemePreference.system;
      });
    } else {
      setState(() {
        currentThemePreference = ThemePreference.values.byName(storedThemePreference.toString().split(".").last);
      });
    }
  }

  Future<Map<String, String>> _readAll() async {
    final all = await _storage.readAll();
    return (all);
  }

  @override
  void initState() {
    super.initState();
    updateCurrentThemePreference();
  }

  @override
  Widget build(BuildContext context) {
    currentSystemTheme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_screen.settings'.tr()),
        elevation: 0,
        // backgroundColor: Theme.of(context).colorScheme.background,
        // foregroundColor: Theme.of(context).colorScheme.onBackground,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   systemStatusBarContrastEnforced: true,
        // ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SettingsList(
          //backgroundColor: Colors.white10,
          // lightTheme: SettingsThemeData(
          //   settingsSectionBackground: Colors.white10,
          //   settingsListBackground: Colors.white10,
          // ),
          // darkTheme: SettingsThemeData(
          //   settingsSectionBackground: Colors.white10,
          //   settingsListBackground: Colors.white10,
          // ),
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: Text('Theme'),
                  trailing: Row(
                    children: [
                      Text(
                        currentThemePreference.toString().split(".").last +
                            " (" +
                            currentSystemTheme.toString().split(".").last +
                            ")",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                  onPressed: (BuildContext context) {
                    showModalBottomSheet<void>(
                      context: context,
                      //backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      barrierColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      builder: (BuildContext context) {
                        return ThemeModalBottomSheet(updateCurrentThemePreference: updateCurrentThemePreference);
                      },
                    );
                  },
                ),
                // SettingsTile(
                //   title: Text('Dark mode'),
                //   trailing: Switch(
                //     activeColor: Theme.of(context).colorScheme.secondary,
                //     value: themePreference,
                //     onChanged: (newValue) {
                //       if (newValue) {
                //         enableDarkMode();
                //       } else {
                //         disableDarkMode();
                //       }
                //     },
                //   ),
                // ),
                SettingsTile(
                  title: Text('settings_screen.about'.tr()),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AboutScreen()));
                  },
                ),
                SettingsTile(
                  title: Text('settings_screen.logout'.tr()),
                  trailing: Icon(Icons.logout, color: Colors.red.shade900),
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => LogoutPopup());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
