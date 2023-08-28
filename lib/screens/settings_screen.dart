import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:indexax/models/theme_preference_data.dart';
import 'package:indexax/screens/about_screen.dart';
import 'package:indexax/screens/privacy_screen.dart';
import 'package:indexax/tools/theme_operations.dart' as theme_operations;
import 'package:indexax/widgets/settings_screen/logout_popup.dart';
import 'package:indexax/widgets/settings_screen/theme_modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String _currentThemePreferenceText = "";
  String _currentSystemThemeText = "";
  String _currentAppVersion = "";
  String _currentBuildNumber = "";

  Future<ThemePreference?> findCurrentThemePreference() async {
    // Check if we already have a theme preference stored in the device.
    // If not, return 'System' as default preference.
    ThemePreference? themePreference =
        await theme_operations.readStoredThemePreference(context);
    if (themePreference != null) {
      if (kDebugMode) {
        print('Existing theme preference detected');
      }
    } else {
      themePreference = ThemePreference.system;
      if (kDebugMode) {
        print('No existing theme preference');
      }
    }
    return themePreference;
  }

  void updateCurrentThemePreferenceText() async {
    // Function that updates the text showing the current theme preference
    ThemePreference? storedThemePreference = await findCurrentThemePreference();
    if (storedThemePreference == null ||
        storedThemePreference == ThemePreference.system) {
      setState(() {
        _currentThemePreferenceText =
            ("settings_screen.${ThemePreference.system.toString().split(".").last}")
                .tr();
      });
    } else {
      setState(() {
        _currentThemePreferenceText =
            ("settings_screen.${storedThemePreference.toString().split(".").last}")
                .tr();
      });
    }
  }

  void _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _currentAppVersion = packageInfo.version;
      _currentBuildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    updateCurrentThemePreferenceText();
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    // Update the text showing the current system theme
    _currentSystemThemeText =
        ("settings_screen.${theme_operations.getCurrentSystemTheme(context).toString().split(".").last}")
            .tr();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings_screen.settings'.tr()),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SettingsList(
          darkTheme: SettingsThemeData(
              settingsListBackground: Theme.of(context).colorScheme.background),
          sections: [
            SettingsSection(
              title: Text('settings_screen.preferences'.tr()),
              tiles: [
                SettingsTile(
                  title: Text('settings_screen.theme'.tr()),
                  leading: const Icon(
                    Icons.format_paint_rounded,
                  ),
                  trailing: Row(
                    children: [
                      Text(
                        _currentThemePreferenceText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (_currentThemePreferenceText ==
                          "settings_screen.system".tr())
                        Text(
                          " ($_currentSystemThemeText)",
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
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      builder: (BuildContext context) {
                        return ThemeModalBottomSheet(
                            updateCurrentThemePreference:
                                updateCurrentThemePreferenceText);
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('settings_screen.information'.tr()),
              tiles: [
                SettingsTile(
                  title: Text('settings_screen.privacy'.tr()),
                  leading: const Icon(Icons.security_rounded),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const PrivacyScreen()));
                  },
                ),
                SettingsTile(
                  title: Text('settings_screen.about'.tr()),
                  leading: const Icon(Icons.info),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const AboutScreen()));
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Platform.isIOS ? null : const Text(" "),
              tiles: [
                SettingsTile(
                  title: Text('settings_screen.logout'.tr()),
                  trailing: Icon(Icons.logout, color: Colors.red.shade900),
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => const LogoutPopup());
                  },
                ),
              ],
            ),
            SettingsSection(
              margin: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              tiles: [
                CustomSettingsTile(
                  child: Text(
                    "v$_currentAppVersion ($_currentBuildNumber)",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
