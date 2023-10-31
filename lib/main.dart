import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexax/screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/bottom_navigation_bar_provider.dart';
import 'package:indexax/tools/theme_provider.dart';
import 'package:indexax/tools/private_mode_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<BottomNavigationBarProvider>(create: (_) => BottomNavigationBarProvider()),
        ChangeNotifierProvider<PrivateModeProvider>(create: (_) => PrivateModeProvider()),
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
  const MyApp({Key? key}) : super(key: key);

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

    return 
    Center(
      child: MaterialApp(
        title: 'Indexa X',
        theme: ThemeData.from(
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData.from(
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
