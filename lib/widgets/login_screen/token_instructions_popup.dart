import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

// Informational pop-up with instructions on how to obtain the user token

class TokenInstructionsPopup extends StatelessWidget {
  const TokenInstructionsPopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final Uri userAreaUrl = Uri(
      scheme: 'https',
      host: 'indexacapital.com',
      path: 'es/u/user'
    );

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('login_screen.get_token'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface
          ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'login_screen.in_your_client_area'.tr() + ':\n',
              style: roboto16.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. ',
                  style: roboto16.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'login_screen.go_to'.tr() + ' "',
                        ),
                        TextSpan(
                            text: 'login_screen.user_configuration'.tr(),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(
                                    userAreaUrl);
                              },
                            style: TextStyle(
                              color: Colors.blue,
                            )),
                        TextSpan(
                          text: '"',
                        ),
                      ],
                    ),
                    style: roboto16.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '2. ',
                  style: roboto16.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Text(
                  'login_screen.go_to_applications'.tr(),
                  style: roboto16.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '3. ',
                  style: roboto16.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Text(
                  'login_screen.press_generate_token'.tr(),
                  style: roboto16.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset('assets/images/token_indexa_highlighted.png'),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "OK",
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
