//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../tools/bottom_navigation_bar_provider.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:indexax/widgets/logout_popup.dart';
import 'package:indexax/screens/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = FlutterSecureStorage();
  List<_SecItem> _items = [];

  Future<List<_SecItem>> _readAll() async {
    final all = await _storage.readAll();
    _items =
        all.keys.map((key) => _SecItem(key, all[key])).toList(growable: false);
    print(_items.length);
    return(_items);
  }
  void _deleteAll() async {
    await _storage.deleteAll();
    _readAll();
  }

  void _deleteAndLogout() async {
    _deleteAll();
    _readAll();
    Provider.of<BottomNavigationBarProvider>(context, listen: false).currentIndex = 0;
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    bool rememberToken = true;
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
          backgroundColor: Colors.white10,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: 'settings_screen.about'.tr(),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onPressed: (BuildContext context) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => AboutScreen()));
                  },
                ),
                SettingsTile(
                    title: 'settings_screen.logout'.tr(),
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

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}