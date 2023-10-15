import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/tools/token_operations.dart' as token_operations;
import 'package:provider/provider.dart';
import 'package:indexax/tools/bottom_navigation_bar_provider.dart';

// Pop-up asking for confirmation before logging the user out

class LogoutPopup extends StatelessWidget {
  const LogoutPopup({
    Key? key,
  }) : super(key: key);

  void _logout(BuildContext context) async {
    Future<dynamic> futureNavigationRoute = Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
        (Route<dynamic> route) => false);
    await token_operations.deleteToken(context);
    if (context.mounted) context.read<BottomNavigationBarProvider>().currentIndex = 0;
    futureNavigationRoute;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle descriptionTextStyle = text_styles.robotoLighter(context, 16);

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
        style: descriptionTextStyle,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
            style: const TextStyle(color: Colors.red),
          ),
          onPressed: () {
            _logout(context);
          },
        ),
      ],
    );
  }
}
