import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:url_launcher/url_launcher.dart';

// Informational pop-up with instructions on how to obtain the user token

class TokenInstructionsPopup extends StatelessWidget {
  const TokenInstructionsPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle instructionsTextStyle = text_styles.robotoLighter(context, 16);

    final Uri userSettingsUrl = Uri(
        scheme: 'https',
        host: 'indexacapital.com',
        path: 'es/u/user',
        fragment: 'settings-apps');

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'login_screen.get_token'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'login_screen.in_your_client_area'.tr()}:\n',
              style: instructionsTextStyle,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. ',
                  style: instructionsTextStyle,
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${'login_screen.go_to'.tr()} "',
                        ),
                        TextSpan(
                            text: 'login_screen.user_configuration'.tr(),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(userSettingsUrl, mode: LaunchMode.externalApplication);
                              },
                            style: const TextStyle(
                              color: Colors.blue,
                            )),
                        const TextSpan(
                          text: '"',
                        ),
                      ],
                    ),
                    style: instructionsTextStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '2. ',
                  style: instructionsTextStyle,
                ),
                Text(
                  'login_screen.go_to_applications'.tr(),
                  style: instructionsTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '3. ',
                  style: instructionsTextStyle,
                ),
                Text(
                  'login_screen.press_generate_token'.tr(),
                  style: instructionsTextStyle,
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
          child: const Text(
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
