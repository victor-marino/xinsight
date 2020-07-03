import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future _supportsBiometrics() async {
    bool supportsBiometrics = false;
    try {
      print("Checking support...");
      supportsBiometrics = await _localAuthentication.canCheckBiometrics;
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return supportsBiometrics;

    if (supportsBiometrics) {
      print("Biometrics supported");
    }
    return supportsBiometrics;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on Exception catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  Future _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      print("Trying to authenticate...");
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
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
    isAuthenticated ? print("User authenticated") : print("User not authenticated");
  }

  void tryToAuthenticate() async {
    if (await _supportsBiometrics()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
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