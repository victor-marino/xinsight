// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'tools/bottom_navigation_bar_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'tools/theme_provider.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    //statusBarIconBrightness: Brightness.dark,
  ));
  runApp(ChangeNotifierProvider<ThemeProvider>(
    create: (_) => new ThemeProvider(),
    child: EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('gl', 'ES')
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  ));
}

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
            theme: ThemeData.from(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                secondary: Colors.blue,
                onSurface: Colors.black,
                onSurfaceVariant: Colors.black45,
              ),
              textTheme: Typography.material2021().black.copyWith(
                headline4: GoogleFonts.oxygen(color: Colors.black, fontWeight: FontWeight.bold))
              //primarySwatch: Colors.blue,
              //brightness: Brightness.light,
              //backgroundColor: Colors.white,
              //scaffoldBackgroundColor: Colors.white,
              // appBarTheme: AppBarTheme(
              //     foregroundColor: Colors.black,
              //     systemOverlayStyle: SystemUiOverlayStyle(
              //         statusBarBrightness: Brightness.light,
              //         statusBarColor: Colors.white,
              //         statusBarIconBrightness: Brightness.dark)),
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              // visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.from(
              colorScheme: ColorScheme.dark(
                primary: Colors.blue,
                secondary: Colors.blue,
                onSurface: Colors.white,
                onSurfaceVariant: Colors.white60,
                // background: Colors.black,
                // onBackground: Colors.white
              ),
              textTheme: Typography.material2021().white.copyWith(
                headline4: GoogleFonts.oxygen(color: Colors.white, fontWeight: FontWeight.bold))
              //scaffoldBackgroundColor: Colors.black,
              //backgroundColor: Colors.black,
              //primarySwatch: Colors.blue,
              //brightness: Brightness.dark,
              // appBarTheme: AppBarTheme(
              //     foregroundColor: Colors.white,
              //     systemOverlayStyle: SystemUiOverlayStyle(
              //         statusBarBrightness: Brightness.dark,
              //         statusBarColor: Colors.black,
              //         statusBarIconBrightness: Brightness.light)),

              /* dark theme settings */
            ),
            localizationsDelegates: context.localizationDelegates,
            //themeMode: ThemeMode.dark,
            themeMode:
                Provider.of<ThemeProvider>(context, listen: true).currentTheme,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          ),
        ),
      ),
    );
  }
}
