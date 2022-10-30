import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../tools/bottom_navigation_bar_provider.dart';

enum ThemePreference { system, light, dark }

class ThemeModalBottomSheet extends StatefulWidget {
  const ThemeModalBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeModalBottomSheet> createState() => _ThemeModalBottomSheetState();
}

class _ThemeModalBottomSheetState extends State<ThemeModalBottomSheet> {
  ThemePreference? _themePreference = ThemePreference.system;

  @override
  Widget build(BuildContext context) {
    // final _storage = FlutterSecureStorage();
    // List<_SecItem> _items = [];

    // Future<List<_SecItem>> _readAll() async {
    //   final all = await _storage.readAll();
    //   _items = all.keys
    //       .map((key) => _SecItem(key, all[key]))
    //       .toList(growable: false);
    //   print(_items.length);
    //   return (_items);
    // }

    // void _deleteAll() async {
    //   await _storage.deleteAll();
    //   _readAll();
    // }

    // void _deleteAndLogout() async {
    //   _deleteAll();
    //   _readAll();
    //   Provider.of<BottomNavigationBarProvider>(context, listen: false)
    //       .currentIndex = 0;
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    //       (Route<dynamic> route) => false);
    // }

    _handleThemeChange(ThemePreference? value) {
      setState(() {
        _themePreference = value;
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 70,
          height: 5,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(3)),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
          child: Row(
            //direction: Axis.horizontal,
            //mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _handleThemeChange(ThemePreference.system);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 200,
                          child: Image.asset(
                              'assets/images/phone_mock_system.png'),
                        ),
                      ),
                      Text(
                        "System",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Radio<ThemePreference>(
                        value: ThemePreference.system,
                        activeColor: Colors.blue,
                        groupValue: _themePreference,
                        onChanged: (ThemePreference? value) {
                          setState(() {
                            _themePreference = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _handleThemeChange(ThemePreference.light);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 200,
                          child:
                              Image.asset('assets/images/phone_mock_light.png'),
                        ),
                      ),
                      Text(
                        "Light",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Radio<ThemePreference>(
                        value: ThemePreference.light,
                        activeColor: Colors.blue,
                        groupValue: _themePreference,
                        onChanged: (ThemePreference? value) {
                          setState(() {
                            _themePreference = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _handleThemeChange(ThemePreference.dark);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 200,
                          child:
                              Image.asset('assets/images/phone_mock_dark.png'),
                        ),
                      ),
                      Text(
                        "Dark",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Radio<ThemePreference>(
                        value: ThemePreference.dark,
                        activeColor: Colors.blue,
                        groupValue: _themePreference,
                        onChanged: (ThemePreference? value) {
                          setState(() {
                            _themePreference = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class _SecItem {
//   _SecItem(this.key, this.value);

//   final String key;
//   final String? value;
// }
