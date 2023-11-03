import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:url_launcher/url_launcher.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  PrivacyScreenState createState() => PrivacyScreenState();
}

class PrivacyScreenState extends State<PrivacyScreen> {
  bool _landscapeOrientation = false;
  late double _availableWidth, _availableHeight;

  final Uri _flutterSecureStorageUrl = Uri(
      scheme: 'https',
      host: 'pub.dev',
      path: 'packages/flutter_secure_storage');
  final Uri _indexaApiUrl =
      Uri(scheme: 'https', host: 'indexacapital.com', path: 'en/api-rest-v1');
  final Uri _userSettingsUrl = Uri(
      scheme: 'https',
      host: 'indexacapital.com',
      path: 'es/u/user',
      fragment: 'settings-apps');
  final Uri _privacyPolicyUrl = Uri(
      scheme: 'https',
      host: 'victormarino.com',
      path:
          "${'privacy_screen.privacy_policy_language'.tr()}/indexax/privacy-policy/");

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    _availableWidth = MediaQuery.of(context).size.width;
    _availableHeight = MediaQuery.of(context).size.height;

    TextStyle headerTextStyle = text_styles.robotoBold(context, 20);
    TextStyle contentTextStyle = text_styles.roboto(context, 16);

    if (_availableHeight <= _availableWidth) {
      _landscapeOrientation = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_screen.privacy'.tr()),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SizedBox(
              // Make content narrower in large landscape screens
              width: _landscapeOrientation && _availableWidth > 1000
                  ? _availableWidth * 0.5
                  : null,
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'privacy_screen.data_collection'.tr(),
                        style: headerTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text1'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text2'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: "flutter_secure_storage",
                        style: contentTextStyle.copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_flutterSecureStorageUrl,
                                mode: LaunchMode.externalApplication);
                          },
                      ),
                      TextSpan(
                        text: 'privacy_screen.text3'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text4'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.account_security'.tr(),
                        style: headerTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text5'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text6'.tr(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_indexaApiUrl,
                                mode: LaunchMode.externalApplication);
                          },
                        style: contentTextStyle.copyWith(color: Colors.blue),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text7'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text8'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text9'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text10'.tr(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_userSettingsUrl,
                                mode: LaunchMode.externalApplication);
                          },
                        style: contentTextStyle.copyWith(color: Colors.blue),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text11'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.privacy_policy'.tr(),
                        style: headerTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: '\n\n',
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text12'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text13'.tr(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_privacyPolicyUrl,
                                mode: LaunchMode.externalApplication);
                          },
                        style: contentTextStyle.copyWith(color: Colors.blue),
                      ),
                      TextSpan(
                        text: 'privacy_screen.text14'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
