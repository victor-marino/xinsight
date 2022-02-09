import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexax/services/indexa_data.dart';
import 'package:indexax/screens/root_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indexax/widgets/login_screen/token_instructions_popup.dart';
import 'package:indexax/widgets/login_screen/forget_token_popup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = FlutterSecureStorage();

  bool storedToken = false;
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    supportsBiometrics ? print("Biometrics supported") : print("Biometrics not supported");

    return supportsBiometrics;
  }

  void enableRememberToken() async {
    if (await authenticateUserLocally()) {
      setState(() {
        rememberToken = true;
      });
    }
  }

  void forgetToken() {
    _deleteAll();
    setState(() {
      storedToken = false;
      rememberToken = false;
    });
  }

  void disableRememberToken() async {
    if (storedToken = true) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              ForgetTokenPopup(forgetToken: forgetToken));
    } else {
      setState(() {
        rememberToken = false;
      });
    }
  }

  Future<Map<String, String>> _readAll() async {
    final all = await _storage.readAll();
    return (all);
  }

  Future<void> _storeKey(String value) async {
    await _storage.write(key: 'indexaToken', value: value);
    _readAll();
  }

  void _deleteAll() async {
    await _storage.deleteAll();
    _readAll();
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

  Future<bool> authenticateUserLocally() async {
    bool isAuthenticated = false;
    try {
      if (await supportsBiometrics()) {
        print("Trying to authenticate...");
        isAuthenticated = await localAuthentication.authenticate(
          sensitiveTransaction: false,
          androidAuthStrings: androidStrings,
          localizedReason: "login_screen.please_authenticate".tr(),
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } else {
        print("Biometrics not supported");
        isAuthenticated = false;
      }
    } on Exception catch (e) {
      print(e);
    }

    isAuthenticated ? print("User authenticated") : print("User not authenticated");

    return isAuthenticated;
  }

  void goToMainScreen({String token, bool saveToken}) async {
    try {
      bool validatedToken = await validateToken(token: token);
      if (validatedToken) {
        if (saveToken) await _storeKey(token);
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
  }

  Future<String> findStoredToken() async {
    String token;
    try {
      Map<String, String> tokens = await _readAll();
      if (tokens['indexaToken'] != null) {
        storedToken = true;
        token = tokens['indexaToken'];
        print('Existing token detected!');
      } else {
        print('No existing token');
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    return token;
  }

  void tryToLoginWithStoredToken() async {
    String storedToken = await findStoredToken();
    if (storedToken != null) {
      setState(() {
        rememberToken = true;
      });
      if (await authenticateUserLocally()) {
        goToMainScreen(token: storedToken, saveToken: false);
      }
    } else {
      setState(() {
        rememberToken = false;
      });
        print('No existing token');
    }
  }

  @override
  void initState() {
    super.initState();
    tryToLoginWithStoredToken();
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height-30,
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Image.asset('assets/images/indexax_logo_wider.png'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                'login_screen.for'.tr() + " ",
                              style: TextStyle(
                                color: Colors.black38)),
                            Image.asset(
                                'assets/images/indexa_logo.png',
                                height: 30),
                          ],
                        )
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
                                      color: Colors.blue,
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
                          maxLength: 400,
                          decoration: storedToken ? InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••",
                            hintText: 'login_screen.your_indexa_token'.tr(),
                            filled: true,
                            fillColor: Colors.grey[300],
                          ) : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'login_screen.api_token'.tr(),
                            hintText: 'login_screen.your_indexa_token'.tr(),
                            counterText: ""
                          ),
                          enabled: storedToken ? false : true,
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
                            ),
                            padding: EdgeInsets.all(0),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 8,
                            onPressed: () {
                              if (storedToken) {
                                tryToLoginWithStoredToken();
                              } else {
                                if (tokenTextController.text == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "login_screen.please_enter_token"
                                                .tr()),
                                      ));
                                } else {
                                  if (rememberToken) {
                                    goToMainScreen(
                                        token: tokenTextController.text,
                                        saveToken: true);
                                  } else {
                                    goToMainScreen(
                                        token: tokenTextController.text,
                                        saveToken: false);
                                  }
                                }
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