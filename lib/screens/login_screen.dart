import 'dart:io';

import 'package:flutter/material.dart';
import 'package:indexa_dashboard/screens/root_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const token =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdXRoX2J5IjoiYXBpK2luZGV4YV9vMiIsImVuZHBvaW50IjoiaHR0cDpcL1wvYXBpLmluZGV4YWNhcGl0YWwuY29tIiwiaWF0IjoxNTkzNTkxNTk3LCJpc3MiOiJJbmRleGEgQ2FwaXRhbCIsInN1YiI6InZpY3Rvcm1hcmlub0BnbWFpbC5jb20ifQ.w9uteOcIV15cX1kH8hzmCMBKvv5ufwqcC_jn58Vy0aA';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberToken = false;
  final tokenTextController = TextEditingController();

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
  }

  void tryToAuthenticate() async {
    bool authenticated = false;
    if (await supportsBiometrics()) {
      await getListOfBiometricTypes();
      authenticated = await authenticateUser();
      if (authenticated) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RootScreen(token: token)));
      } else {
        tryToAuthenticate();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //tryToAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: tokenTextController,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Indexa API token',
                    hintText: 'Tu token de Indexa',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  child: Text(
                    'ENTRAR',
                  ),
                  height: 40,
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 8,
                  onPressed: () {
                    print(tokenTextController.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RootScreen(token: tokenTextController.text)));
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Recordar token',
                    textAlign: Platform.isIOS ? TextAlign.left: TextAlign.right,
                  ),
                  value: rememberToken,
                  controlAffinity: ListTileControlAffinity.platform,
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  onChanged: (newValue) {
                    print(newValue);
                    setState(() {
                      rememberToken = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
