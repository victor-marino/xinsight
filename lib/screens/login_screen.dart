import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/services/indexa_data.dart';
import 'package:indexa_dashboard/screens/root_screen.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indexa_dashboard/widgets/token_instructions_popup.dart';

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
    biometricHint: "",
    biometricNotRecognized: "login_screen.user_not_recognized".tr(),
    biometricSuccess: "login_screen.user_authenticated".tr(),
    cancelButton: "login_screen.cancel".tr(),
    signInTitle: "login_screen.biometric_authentication".tr(),
    biometricRequiredTitle: "login_screen.biometrics_required".tr(),
    goToSettingsButton: "login_screen.go_to_settings".tr(),
    goToSettingsDescription: "login_screen.go_to_settings_description".tr(),
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

  Future authenticateUserLocally() async {
    bool isAuthenticated = false;
    try {
      print("Trying to authenticate...");
      isAuthenticated = await localAuthentication.authenticate(
        sensitiveTransaction: false,
        androidAuthStrings: androidStrings,
        localizedReason: "login_screen.please_authenticate".tr(),
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

  Future<bool> tryToAuthenticateLocally() async {
    bool authenticated = false;
    if (await supportsBiometrics()) {
      await getListOfBiometricTypes();
      authenticated = await authenticateUserLocally();
    }
    return (authenticated);
  }

  void enableRememberToken() async {
    if (await tryToAuthenticateLocally()) {
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
      setState(() {
        rememberToken = true;
      });
      print('Existing token detected!');
      authenticateLocallyAndGoToHome(token: tokens['indexaToken']);
    } else {
      setState(() {
        rememberToken = false;
      });
      print('No existing token');
    }
  }

  Future<bool> validateToken({String token}) async {
    IndexaData indexaData = IndexaData(token: token);
    try {
      var userAccounts = await indexaData.getUserAccounts();
      if (userAccounts != null) {
        print("Token authenticated!");
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }

  void authenticateLocallyAndGoToHome({String token}) async {
    if (await tryToAuthenticateLocally()) {
      try {
        bool validatedToken = await validateToken(token: token);
        if (validatedToken == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RootScreen(token: token, pageNumber: 0, accountNumber: 0),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("login_screen.token_validation_failed".tr()),
          ));
        }
      } on Exception catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
        setState(() {
          tokenTextController.text = token;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("login_screen.biometric_authentication_failed".tr()),
      ));
    }
  }

  void goToHome({String token}) async {
    try {
      bool validatedToken = await validateToken(token: token);
      if (validatedToken) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RootScreen(token: token, pageNumber: 0, accountNumber: 0),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("login_screen.token_validation_failed".tr()),
        ));
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void saveTokenAndGoToHome() async {
    await _storeKey(tokenTextController.text);
    try {
      bool validatedToken = await validateToken(token: tokenTextController.text);
      if (validatedToken) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                RootScreen(token: tokenTextController.text, pageNumber: 0, accountNumber: 0),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("login_screen.token_validation_failed".tr()),
        ));
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    tryToLoginWithLocalToken();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).canvasColor,
          statusBarBrightness: Brightness.light, // iOS
          statusBarIconBrightness: Brightness.dark), // Android
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: Center(
                            child: Image.asset('assets/images/indexa_logo.png'),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => TokenInstructionsPopup(),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        'login_screen.how_to_get_token'.tr(),
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.help_outline,
                                      color: Colors.black38,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: tokenTextController,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'login_screen.api_token'.tr(),
                            hintText: 'login_screen.your_indexa_token'.tr(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    rememberToken
                                        ? Icons.lock_outline
                                        : Icons.lock_open,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'login_screen.remember_token'.tr(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: rememberToken,
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
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: MaterialButton(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              //size: 30,
                            ),
                            //height: 60,
                            padding: EdgeInsets.all(0),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 8,
                            onPressed: () {
                              if (rememberToken) {
                                saveTokenAndGoToHome();
                              } else if (tokenTextController.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("login_screen.please_enter_token".tr()),
                                ));
                              } else {
                                goToHome(token: tokenTextController.text);
                              }
                            },
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}