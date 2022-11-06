import 'package:flutter/material.dart';
import 'dart:async';
import 'package:indexax/screens/root_screen.dart';
import 'package:indexax/tools/local_authentication.dart'
    as local_authentication;
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/theme_operations.dart' as theme_operations;
import 'package:indexax/tools/validations.dart' as validations;
import 'package:indexax/tools/secure_storage.dart';
import 'package:indexax/tools/token_operations.dart' as token_operations;
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/widgets/login_screen/token_instructions_popup.dart';
import 'package:indexax/widgets/login_screen/forget_token_popup.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver{
  final storage = SecureStorage();

  bool storedToken = false;
  bool rememberToken = false;

  final tokenTextController = TextEditingController();

  void enableRememberToken() async {
    if (await local_authentication.authenticateUserLocally(context)) {
      setState(() {
        rememberToken = true;
      });
    }
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

  void forgetToken() {
    token_operations.deleteToken();
    setState(() {
      storedToken = false;
      rememberToken = false;
      tokenTextController.text = "";
    });
  }

  Future<String?> findStoredToken() async {
    String? token = await token_operations.readToken(context);
    if (token != null) {
      storedToken = true;
      tokenTextController.text = "••••••••••••••••";
      print('Existing token detected!');
    } else {
      print('No existing token');
    }
    return token;
  }

  void tryToLoginWithStoredToken() async {
    String? storedToken = await findStoredToken();
    if (storedToken != null) {
      setState(() {
        rememberToken = true;
      });
      if (await local_authentication.authenticateUserLocally(context)) {
        goToMainScreen(token: storedToken, saveToken: false);
      }
    } else {
      setState(() {
        rememberToken = false;
      });
      print('No existing token');
    }
  }

  void goToMainScreen({required String token, bool? saveToken}) async {
    token = validations.sanitizeToken(token);
    if (validations.validateTokenFormat(token)) {
      try {
        bool? authenticatedToken =
            await (token_operations.authenticateToken(context, token));
        if (authenticatedToken ?? false) {
          if (saveToken!) await token_operations.storeToken(context, token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  RootScreen(token: token, pageNumber: 0, accountNumber: 0),
            ),
          );
        } else {
          snackbar.showInSnackBar(
              context, "login_screen.token_validation_failed".tr());
        }
      } on Exception catch (e) {
        print(e);
        snackbar.showInSnackBar(context, e.toString());
        setState(() {
          tokenTextController.text = token;
        });
      }
    } else {
      snackbar.showInSnackBar(
          context, "login_screen.invalid_token_format".tr());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    theme_operations.updateTheme(context);

    if (widget.errorMessage == null) {
      tryToLoginWithStoredToken();
    } else {
      String? message;
      if ((widget.errorMessage == null) || (widget.errorMessage == "")) {
        message = "login_screen.default_error_message".tr();
      } else {
        message = widget.errorMessage;
      }
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => snackbar.showInSnackBar(context, message!));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      theme_operations.updateTheme(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool landscapeOrientation = false;
    double availableWidth = MediaQuery.of(context).size.width;
    double availableHeight = MediaQuery.of(context).size.height;

    if (availableHeight <= availableWidth) {
      landscapeOrientation = true;
    }

    return
        // AnnotatedRegion<SystemUiOverlayStyle>(
        //   value: SystemUiOverlayStyle(
        //       statusBarColor: Theme.of(context).canvasColor,
        //       statusBarBrightness: Brightness.light, // iOS
        //       statusBarIconBrightness: Brightness.dark), // Android
        //   child:
        Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SizedBox(
                width: landscapeOrientation
                    ? availableWidth * 0.5
                    : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.15 < 60)
                            ? 60
                            : MediaQuery.of(context).size.height * 0.15),
                    Container(
                      width: landscapeOrientation
                          ? availableWidth * 0.5
                          : double.infinity,
                      child: Column(
                        children: [
                          Container(
                            child: Image.asset(
                                'assets/images/indexax_logo_wide.png'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('login_screen.for'.tr() + " Indexa Capital",
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.15 <
                                    60)
                                ? 60
                                : MediaQuery.of(context).size.height * 0.15),
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
                                    builder: (BuildContext context) =>
                                        TokenInstructionsPopup(),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface
                          ),
                          decoration: storedToken
                              ? InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "login_screen.api_token".tr(),
                                  hintText:
                                      'login_screen.your_indexa_token'.tr(),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                )
                              : InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'login_screen.api_token'.tr(),
                                  hintText:
                                      'login_screen.your_indexa_token'.tr(),
                                  counterText: ""),
                          enabled: storedToken ? false : true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  rememberToken
                                      ? Icons.lock_outline
                                      : Icons.lock_open,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'login_screen.remember_token'.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
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
                                  snackbar.showInSnackBar(context,
                                      "login_screen.please_enter_token".tr());
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
