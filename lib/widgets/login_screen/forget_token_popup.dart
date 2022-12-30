import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Confirmation pop-up before deleting locally stored token

class ForgetTokenPopup extends StatelessWidget {
  const ForgetTokenPopup({
    Key? key, this.forgetToken,
  }) : super(key: key);
  final VoidCallback? forgetToken;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'login_screen.forget_token_popup_title'.tr(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(
          24, 24, 24, 0),
      actions: [
        TextButton(
          child: Text('login_screen.forget_token_popup_cancel_button'.tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
              'login_screen.forget_token_popup_ok_button'.tr(),
            style: TextStyle(
              color: Colors.red
            ),
          ),
          onPressed: () {
            forgetToken!();
            Navigator.of(context).pop();
            },
        ),
      ],
    );
  }
}