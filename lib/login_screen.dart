import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication localAuthentication = LocalAuthentication();
  final AndroidAuthMessages androidStrings = AndroidAuthMessages(
    fingerprintHint: "",
    fingerprintNotRecognized: "User not recognised",
    fingerprintSuccess: "User authenticated",
    cancelButton: "Cancel",
    signInTitle: "Biometric Authentication",
    fingerprintRequiredTitle: "Biometric Authentication Required",
    goToSettingsButton: "Go to Settings",
    goToSettingsDescription: "Biometric authentication not configured in this device. Please go to your device Settings to configure.",
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
        localizedReason: "Please authenticate",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on Exception catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      print("User authenticated");
    }
    isAuthenticated
        ? print("User authenticated")
        : print("User not authenticated");
  }

  void tryToAuthenticate() async {
    if (await supportsBiometrics()) {
      await getListOfBiometricTypes();
      await authenticateUser();
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
          "Indexa Dashboard",
        ),
      ),
      body: SafeArea(
        child: Text("Hey!"),
      ),
    );
  }
}
