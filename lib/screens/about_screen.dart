//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexax/tools/constants.dart';
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
    // Get screen dimensions and orientation
    bool landscapeOrientation = false;
    double availableWidth = MediaQuery.of(context).size.width;
    double availableHeight = MediaQuery.of(context).size.height;

    if (availableHeight <= availableWidth) {
      landscapeOrientation = true;
    }

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
            child: Center(
              child: SizedBox(
                // Make content narrower in large landscape screens
                width: landscapeOrientation && availableWidth > 1000 ? availableWidth * 0.5 : null,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                      
                      child: SizedBox(
                        // Make logo smaller in landscape mode
                        width: landscapeOrientation ? availableWidth * 0.5 : double.infinity,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.center,
                                child: Image.asset('assets/images/indexax_logo_wider.png'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      'about_screen.for'.tr() + " ",
                                      style: TextStyle(
                                          color: Colors.black38)),
                                  Image.asset(
                                      'assets/images/indexa_logo.png',
                                      height: 30),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}