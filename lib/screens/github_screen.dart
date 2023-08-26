import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:url_launcher/url_launcher.dart';

class GithubScreen extends StatefulWidget {
  const GithubScreen({Key? key}) : super(key: key);

  @override
  GithubScreenState createState() => GithubScreenState();
}

class GithubScreenState extends State<GithubScreen> {
  bool _landscapeOrientation = false;
  late double _availableWidth;
  late double _availableHeight;
  final Uri _githubRepository =
      Uri(scheme: 'https', host: 'github.com', path: '/victor-marino/indexax');

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
        title: Text('github_screen.github'.tr()),
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
                        text: 'github_screen.text1'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: 'github_screen.text2'.tr(),
                        style: contentTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/github_mark.png'),
                    ),
                    const SizedBox(width: 5),
                    Text.rich(
                      TextSpan(
                        text: "https://github.com/victor-marino/indexax",
                        style: contentTextStyle.copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(_githubRepository);
                          },
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
