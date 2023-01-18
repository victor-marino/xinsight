// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'tools/bottom_navigation_bar_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'tools/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
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
    ColorScheme lightColorScheme = ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: Colors.blue,
      onSurface: Colors.black,
      onSurfaceVariant: Colors.black45,
      onBackground: Colors.black12
    );

    ColorScheme darkColorScheme = ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blue,
      surface: Colors.black87,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white60,
      background: Colors.black,
      onBackground: Colors.white54,
    );

    return ChangeNotifierProvider<BottomNavigationBarProvider>(
      create: (context) {
        return BottomNavigationBarProvider();
      },
      child: Center(
        child: RefreshConfiguration(
          enableRefreshVibrate: true,
          child: MaterialApp(
            title: 'Indexa X',
            theme: ThemeData.from(colorScheme: lightColorScheme,
                ),
            darkTheme: ThemeData.from(
                colorScheme: darkColorScheme,
                /* dark theme settings */
                ).copyWith(
                bottomSheetTheme:
                    BottomSheetThemeData(backgroundColor: Colors.grey[900])),                
            localizationsDelegates: context.localizationDelegates,
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
