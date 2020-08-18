import 'package:flutter/material.dart';
import 'dart:io';
import 'package:indexa_dashboard/screens/root_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = FlutterSecureStorage();

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

  Future<bool> tryToAuthenticate() async {
    bool authenticated = false;
    if (await supportsBiometrics()) {
      await getListOfBiometricTypes();
      authenticated = await authenticateUser();
    }
    return (authenticated);
  }

  void enableRememberToken() async {
    if (await tryToAuthenticate()) {
      setState(() {
        rememberToken = true;
      });
    }
  }

  void disableRememberToken() async {
    setState(() {
      rememberToken = false;
    });
  }

  Future<Map<String, String>> _readAll() async {
    final all = await _storage.readAll();
    return (all);
  }

  Future<void> _storeKey(String value) async {
    await _storage.write(key: 'indexaToken', value: value);
    _readAll();
  }

  void tryToLoginWithLocalToken() async {
    Map<String, String> tokens = await _readAll();
    if (tokens['indexaToken'] != null) {
      print('Existing token: ' + tokens['indexaToken']);
      authenticateAndGoToHome(token: tokens['indexaToken']);
    } else {
      print('No existing token');
    }
  }

  void authenticateAndGoToHome({String token}) async {
    if (await tryToAuthenticate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RootScreen(token: token),
        ),
      );
    }
  }

  void goToHome({String token}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RootScreen(token: token),
      ),
    );
  }

  void saveTokenAndGoToHome() async {
    await _storeKey(tokenTextController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RootScreen(token: tokenTextController.text),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //authenticateAndGoToHome();
    tryToLoginWithLocalToken();
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
                    labelText: 'API token',
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
                    if (rememberToken) {
                      saveTokenAndGoToHome();
                    } else {
                      goToHome();
                    }
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Recordar token',
                    textAlign:
                        Platform.isIOS ? TextAlign.left : TextAlign.right,
                  ),
                  value: rememberToken,
                  controlAffinity: ListTileControlAffinity.platform,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  onChanged: (newValue) {
                    if (newValue) {
                      enableRememberToken();
                    } else {
                      disableRememberToken();
                    }
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