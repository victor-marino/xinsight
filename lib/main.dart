import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/bottom_navigation_bar_provider.dart';
import 'package:indexax/tools/theme_provider.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/widgets/crash_report_popup.dart';

// We create a global key here so we have an available context outside the build method
// Required so we can show a crash report dialogue from the code in main()
final navigator = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Show a crash report dialogue in case of any uncaught exceptions
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final appVersion =
      "${packageInfo.appName} v${packageInfo.version} (${packageInfo.buildNumber})";

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    final information = details.informationCollector?.call() ?? [];
    showCrashReport(
      navigator.currentContext!,
      appVersion,
      details.exception.toString(),
      details.stack.toString(),
      information.toString(),
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    showCrashReport(navigator.currentContext!, appVersion, error.toString(),
        stack.toString());
    return true;
  };

  // Run the actual app
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<BottomNavigationBarProvider>(
          create: (_) => BottomNavigationBarProvider()),
      ChangeNotifierProvider<PrivateModeProvider>(
          create: (_) => PrivateModeProvider()),
    ],
    child: EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('gl', 'ES')
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme lightColorScheme = const ColorScheme.light(
        primary: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.blue,
        onSurface: Colors.black,
        onSurfaceVariant: Colors.black45,
        onBackground: Colors.black12);

    ColorScheme darkColorScheme = const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blue,
      surface: Colors.black87,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white60,
      background: Colors.black,
      onBackground: Colors.white54,
    );

    return Center(
      child: MaterialApp(
        navigatorKey: navigator,
        title: 'X Insight',
        theme: ThemeData.from(
          useMaterial3: false,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData.from(
          useMaterial3: false,
          colorScheme: darkColorScheme,
          /* dark theme settings */
        ).copyWith(
            bottomSheetTheme:
                BottomSheetThemeData(backgroundColor: Colors.grey[900])),
        localizationsDelegates: context.localizationDelegates,
        themeMode: context.watch<ThemeProvider>().currentTheme,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}
