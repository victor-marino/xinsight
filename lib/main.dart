// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'tools/bottom_navigation_bar_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// mixin PortraitModeMixin on StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     _portraitModeOnly();
//     return null;
//   }
// }

// void _portraitModeOnly() {
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//     DeviceOrientation.landscapeLeft,
//     DeviceOrientation.landscapeRight
//   ]);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('es', 'ES'), Locale('gl', 'ES')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

//class MyApp extends StatelessWidget with PortraitModeMixin {
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return ChangeNotifierProvider<BottomNavigationBarProvider>(
      create: (context) {
        return BottomNavigationBarProvider();
      },
      child: Center(
        child: RefreshConfiguration(
          enableRefreshVibrate: true,
          child: MaterialApp(
            title: 'Indexa X',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            // debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          ),
        ),
      ),
    );
  }
}
