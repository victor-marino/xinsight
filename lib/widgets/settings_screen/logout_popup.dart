import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../../tools/bottom_navigation_bar_provider.dart';

class LogoutPopup extends StatelessWidget {
  const LogoutPopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'logout_popup.title'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      content: Text(
        'logout_popup.text'.tr(),
        style: kPopUpNormalTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      contentPadding: EdgeInsets.fromLTRB(
          24, 24, 24, 0),
      actions: [
        TextButton(
          child: Text('logout_popup.cancel_button'.tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
              'logout_popup.logout_button'.tr(),
            style: TextStyle(
              //color: Colors.red.shade900
              color: Theme.of(context).colorScheme.error
            ),
          ),
          onPressed: () {
            _deleteAndLogout();
            },
        ),
      ],
    );
  }
}

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String? value;
}