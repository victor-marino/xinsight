//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:indexax/widgets/settings_screen/logout_popup.dart';
import 'package:indexax/screens/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_screen.settings'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SettingsList(
          //backgroundColor: Colors.white10,
          lightTheme: SettingsThemeData(
            settingsSectionBackground: Colors.white10,
            settingsListBackground: Colors.white10,
          ),
          darkTheme: SettingsThemeData(
            settingsSectionBackground: Colors.white10,
            settingsListBackground: Colors.white10,
          ),
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: Text('settings_screen.about'.tr()),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onPressed: (BuildContext context) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => AboutScreen()));
                  },
                ),
                SettingsTile(
                    title: Text('settings_screen.logout'.tr()),
                    trailing: Icon(Icons.logout, color: Colors.red.shade900),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              LogoutPopup());
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