import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class TokenInstructionsPopup extends StatelessWidget {
  const TokenInstructionsPopup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    Uri userAreaUrl = Uri(
      scheme: 'https',
      host: 'indexacapital.com',
      path: 'es/u/user'
    );

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('login_screen.get_token'.tr()),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'login_screen.in_your_client_area'.tr() + ':\n',
              style: kPopUpNormalTextStyle,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. ',
                  style: kPopUpNormalTextStyle.copyWith(
                      //fontSize: 12,
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
                    style: kPopUpNormalTextStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '2. ',
                  style: kPopUpNormalTextStyle,
                ),
                Text(
                  'login_screen.go_to_applications'.tr(),
                  style: kPopUpNormalTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '3. ',
                  style: kPopUpNormalTextStyle,
                ),
                Text(
                  'login_screen.press_generate_token'.tr(),
                  style: kPopUpNormalTextStyle,
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
