import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../../tools/bottom_navigation_bar_provider.dart';
import 'package:indexax/tools/token_operations.dart' as token_operations;

// Pop-up asking for confirmation before logging the user out

class LogoutPopup extends StatelessWidget {
  const LogoutPopup({
    Key? key,
  }) : super(key: key);

  void _logout(BuildContext context) async {
    await token_operations.deleteToken(context);
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = 0;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'logout_popup.title'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      content: Text(
        'logout_popup.text'.tr(),
        style: kPopUpNormalTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                color: Colors.red),
          ),
          onPressed: () {
            _logout(context);
          },
        ),
      ],
    );
  }
}