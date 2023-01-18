import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _landscapeOrientation = false;
  late double _availableWidth;
  late double _availableHeight;
  Uri _indexaApiUrl =
      Uri(scheme: 'https', host: 'indexacapital.com', path: 'en/api-rest-v1');
  Uri _flutterSecureStorageUrl = Uri(
      scheme: 'https',
      host: 'pub.dev',
      path: 'packages/flutter_secure_storage');

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    _availableWidth = MediaQuery.of(context).size.width;
    _availableHeight = MediaQuery.of(context).size.height;

    TextStyle contentTextStyle = text_styles.roboto(context, 16);
    
    if (_availableHeight <= _availableWidth) {
      _landscapeOrientation = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('about_screen.about'.tr()),
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
                        text: 'about_screen.text1'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'about_screen.text2'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'about_screen.text3'.tr(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_indexaApiUrl);
                          },
                        style:
                            contentTextStyle.copyWith(color: Colors.blue),
                      ),
                      TextSpan(
                        text: 'about_screen.text4'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'about_screen.text5'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: "flutter_secure_storage",
                        style:
                            contentTextStyle.copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_flutterSecureStorageUrl);
                          },
                      ),
                      TextSpan(
                        text: 'about_screen.text6'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'about_screen.text7'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: SizedBox(
                      // Make logo smaller in landscape mode
                      width: _landscapeOrientation
                          ? _availableWidth * 0.5
                          : double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                  'assets/images/indexax_logo_wide.png'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'about_screen.for'.tr() + " Indexa Capital",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                ),
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
      )),
    );
  }
}
