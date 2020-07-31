import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/screens/projection_screen.dart';
import 'summary_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:indexa_dashboard/tools/constants.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SyncfusionLicense.registerLicense(SYNCFUSION_LICENSE);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).canvasColor,
        statusBarBrightness: Brightness.light, // iOS
        statusBarIconBrightness: Brightness.dark),// Android
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            SummaryScreen(),
            ProjectionScreen(),
          ],
        ),
      ),
    );
  }
}
