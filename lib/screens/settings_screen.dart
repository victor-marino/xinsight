//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:indexax/widgets/settings_screen/logout_popup.dart';
import 'package:indexax/screens/about_screen.dart';
import 'package:indexax/widgets/settings_screen/theme_modal_bottom_sheet.dart';
import 'package:indexax/models/theme_preference_data.dart';
import 'package:indexax/tools/theme_operations.dart' as theme_operations;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemePreference? currentThemePreference;
  Brightness? currentSystemTheme;

  Future<ThemePreference?> findStoredThemePreference() async {
    ThemePreference? themePreference =
        await theme_operations.readThemePreference(context);
    if (themePreference != null) {
      print('Existing theme preference detected');
    } else {
      themePreference = ThemePreference.system;
      print('No existing theme preference');
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
        currentThemePreference = ThemePreference.values
            .byName(storedThemePreference.toString().split(".").last);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateCurrentThemePreference();
  }

  @override
  Widget build(BuildContext context) {
    currentSystemTheme =
        theme_operations.getCurrentSystemTheme(context);

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
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).colorScheme.background
          ),
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
                  title: Text('settings_screen.theme'.tr()),
                  trailing: Row(
                    children: [
                      if (currentThemePreference != null)
                        Text(
                          ("settings_screen." +
                                  currentThemePreference
                                      .toString()
                                      .split(".")
                                      .last)
                              .tr(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      if (currentThemePreference == ThemePreference.system)
                        Text(
                          " (" +
                              ("settings_screen." +
                                      currentSystemTheme
                                          .toString()
                                          .split(".")
                                          .last)
                                  .tr() +
                              ")",
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  onPressed: (BuildContext context) {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      builder: (BuildContext context) {
                        return ThemeModalBottomSheet(
                            updateCurrentThemePreference:
                                updateCurrentThemePreference);
                      },
                    );
                  },
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
