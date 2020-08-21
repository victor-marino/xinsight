import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indexa_dashboard/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: MaterialButton(
            child: Text(
              'Olvidar token y salir',
            ),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              _deleteAndLogout();
            },
          ),
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