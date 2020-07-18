import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'summary_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication localAuthentication = LocalAuthentication();
  final AndroidAuthMessages androidStrings = AndroidAuthMessages(
    fingerprintHint: "",
    fingerprintNotRecognized: "user_not_recognized".tr(),
    fingerprintSuccess: "user_authenticated".tr(),
    cancelButton: "cancel".tr(),
    signInTitle: "biometric_authentication".tr(),
    fingerprintRequiredTitle: "biometrics_required".tr(),
    goToSettingsButton: "go_to_settings".tr(),
    goToSettingsDescription: "go_to_settings_description".tr(),
  );

  Future supportsBiometrics() async {
    bool supportsBiometrics = false;
    try {
      print("Checking support...");
      supportsBiometrics = await localAuthentication.canCheckBiometrics;
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return supportsBiometrics;

    if (supportsBiometrics) {
      print("Biometrics supported");
    }
    return supportsBiometrics;
  }

  Future<void> getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await localAuthentication.getAvailableBiometrics();
    } on Exception catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  Future authenticateUser() async {
    bool isAuthenticated = false;
    try {
      print("Trying to authenticate...");
      isAuthenticated = await localAuthentication.authenticateWithBiometrics(
        androidAuthStrings: androidStrings,
        localizedReason: "please_authenticate".tr(),
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on Exception catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      print("User authenticated");
      return true;
    } else {
      print("User not authenticated");
      return false;
    }
//    isAuthenticated
//        ? print("User authenticated")
//        : print("User not authenticated");
  }

  void tryToAuthenticate() async {
    bool authenticated = false;
    if (await supportsBiometrics()) {
      await getListOfBiometricTypes();
      authenticated = await authenticateUser();
      if (authenticated) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SummaryScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tryToAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_title'.tr(),
        ),
      ),
      body: SafeArea(
        child: Text("good_morning".tr()),
      ),
    );
  }
}
