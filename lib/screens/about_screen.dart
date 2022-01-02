//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about_screen.about'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                RichText(text:
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'about_screen.text1'.tr(),
                        style: kAboutScreenTextStyle,
                      ),
                      TextSpan(
                        text: 'about_screen.text2'.tr(),
                        style: kAboutScreenTextStyle,
                      ),
                      TextSpan(
                        text: 'about_screen.text3'.tr(),
                        recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://indexacapital.com/en/api-rest-v1');
                          },
                        style: kAboutScreenTextStyle.copyWith(color: Colors.blue),
                      ),
                      TextSpan(
                        text: 'about_screen.text4'.tr(),
                        style: kAboutScreenTextStyle,
                      ),
                      TextSpan(
                        text: 'about_screen.text5'.tr(),
                        style: kAboutScreenTextStyle,
                      ),
                      TextSpan(
                        text: "flutter_secure_storage",
                        style: kAboutScreenTextStyle.copyWith(color: Colors.blue),
                          recognizer:
                          TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                              'https://pub.dev/packages/flutter_secure_storage');
                        },
                      ),
                      TextSpan(
                        text: 'about_screen.text6'.tr(),
                        style: kAboutScreenTextStyle,
                      ),
                      TextSpan(
                        text: 'about_screen.text7'.tr(),
                        style: kAboutScreenTextStyle,
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}