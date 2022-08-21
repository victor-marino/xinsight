//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/models/theme_preference_data.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/theme_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:indexax/widgets/settings_screen/logout_popup.dart';
import 'package:indexax/screens/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool themePreference;

  void enableDarkMode() {
    themePreference = true;
    Provider.of<ThemeProvider>(context, listen: false).currentTheme =
        ThemeMode.dark;
  }

  void disableDarkMode() {
    themePreference = false;
    Provider.of<ThemeProvider>(context, listen: false).currentTheme =
        ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ThemeProvider>(context, listen: true).currentTheme ==
        ThemeMode.dark) {
      themePreference = true;
    } else {
      themePreference = false;
    }

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
                  title: Text('Dark mode'),
                  trailing: Switch(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: themePreference,
                    onChanged: (newValue) {
                      if (newValue) {
                        enableDarkMode();
                      } else {
                        disableDarkMode();
                      }
                    },
                  ),
                ),
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
