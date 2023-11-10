import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  bool _landscapeOrientation = false;
  late double _availableWidth, _availableHeight;
  final Uri _githubRepository =
      Uri(scheme: 'https', host: 'github.com', path: '/victor-marino/indexax');
  final Uri _flutterURL = Uri(scheme: 'https', host: 'flutter.dev');

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    _availableWidth = MediaQuery.sizeOf(context).width;
    _availableHeight = MediaQuery.sizeOf(context).height;

    TextStyle contentTextStyle = text_styles.roboto(context, 16);

    if (_availableHeight <= _availableWidth) {
      _landscapeOrientation = true;
    } else {
      _landscapeOrientation = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('about_screen.about'.tr()),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            TextSpan(
                              text: 'about_screen.text2'.tr(),
                              style:
                                  contentTextStyle.copyWith(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(_flutterURL,
                                      mode: LaunchMode.externalApplication);
                                },
                            ),
                            TextSpan(
                              text: 'about_screen.text3'.tr(),
                              style: contentTextStyle.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            TextSpan(
                              text: '\n\n',
                              style: contentTextStyle.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            TextSpan(
                              text: 'about_screen.text4'.tr(),
                              style: contentTextStyle.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            const TextSpan(text: '\n'),
                          ]),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'assets/images/github_mark.png'),
                              ),
                              const SizedBox(width: 5),
                              Text.rich(
                                TextSpan(
                                  text:
                                      "https://github.com/victor-marino/indexax",
                                  style: contentTextStyle.copyWith(
                                      color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(_githubRepository,
                                          mode: LaunchMode.externalApplication);
                                    },
                                ),
                              ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 10, right: 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${'about_screen.for'.tr()} Indexa Capital",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                      ),
                                    ],
                                  ),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'about_screen.text5'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      )),
    );
  }
}
