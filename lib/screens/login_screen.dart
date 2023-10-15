import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/screens/root_screen.dart';
import 'package:indexax/tools/local_authentication.dart'
    as local_authentication;
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/theme_operations.dart' as theme_operations;
import 'package:indexax/tools/token_operations.dart' as token_operations;
import 'package:indexax/widgets/login_screen/forget_token_popup.dart';
import 'package:indexax/widgets/login_screen/token_instructions_popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    this.errorMessage,
  }) : super(key: key);

  final String? errorMessage;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  bool _storedToken = false;
  bool _rememberToken = false;

  final _tokenTextController = TextEditingController();

  void enableRememberToken() async {
    // Called when the user flips on the switch to remember the token
    if (await local_authentication.authenticateUserLocally(context)) {
      setState(() {
        _rememberToken = true;
      });
    }
  }

  void disableRememberToken() async {
    // Called when the user flips off the switch to remember the token
    if (_storedToken = true) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              ForgetTokenPopup(forgetToken: forgetToken));
    } else {
      setState(() {
        _rememberToken = false;
      });
    }
  }

  void forgetToken() async {
    // Delete the token from secure storage and clear the text field
    await token_operations.deleteToken(context);
    setState(() {
      _storedToken = false;
      _rememberToken = false;
      _tokenTextController.text = "";
    });
  }

  Future<String?> findStoredToken() async {
    // Check if a token is stored in this device
    String? token = await token_operations.readToken(context);
    if (token != null) {
      _storedToken = true;
      _tokenTextController.text = getMaskedString(length: 16);
      if (kDebugMode) {
        print('Existing token detected!');
      }
    } else {
      if (kDebugMode) {
        print('No existing token');
      }
    }
    return token;
  }

  void tryToLoginWithStoredToken() async {
    String? storedToken = await findStoredToken();
    if (storedToken != null) {
      setState(() {
        _rememberToken = true;
      });
      if (!mounted) return;
      if (await local_authentication.authenticateUserLocally(context)) {
        goToMainScreen(token: storedToken, saveToken: false);
      }
    } else {
      setState(() {
        _rememberToken = false;
      });
      if (kDebugMode) {
        print('No existing token');
      }
    }
  }

  void goToMainScreen({required String token, required bool saveToken}) async {
    bool? authenticatedToken =
        await (token_operations.authenticateToken(context, token));
    if (authenticatedToken ?? false) {
      if (!mounted) return;
      if (saveToken) await token_operations.storeToken(context, token);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              RootScreen(token: token, pageIndex: 0, accountIndex: 0),
        ),
      );
    } else {
      setState(() {
        _tokenTextController.text = token;
        snackbar.showInSnackBar(
            context, "login_screen.token_authentication_failed".tr());
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    // Check if we were thrown back to the login screen after an error
    // Otherwise, try to find a stored token and login with it
    if (widget.errorMessage == null) {
      tryToLoginWithStoredToken();
    } else {
      String? message;
      if (widget.errorMessage == "") {
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
    // Check if system theme has changed after the app is resumed
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
    theme_operations.updateTheme(context);
    bool landscapeOrientation = false;
    double availableWidth = MediaQuery.of(context).size.width;
    double availableHeight = MediaQuery.of(context).size.height;

    if (availableHeight <= availableWidth) {
      landscapeOrientation = true;
    }

    return Scaffold(
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
                    SizedBox(
                      width: landscapeOrientation
                          ? availableWidth * 0.5
                          : double.infinity,
                      child: Column(
                        children: [
                          Image.asset('assets/images/indexax_logo_wide.png'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${'login_screen.for'.tr()} Indexa Capital",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)),
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
                                        const TokenInstructionsPopup(),
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
                                    const Icon(
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
                          controller: _tokenTextController,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          maxLength: 400,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                          decoration: _storedToken
                              ? InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "login_screen.api_token".tr(),
                                  hintText:
                                      'login_screen.your_indexa_token'.tr(),
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.1),
                                )
                              : InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'login_screen.api_token'.tr(),
                                  hintText:
                                      'login_screen.your_indexa_token'.tr(),
                                  counterText: ""),
                          enabled: _storedToken ? false : true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _rememberToken
                                      ? Icons.lock_outline
                                      : Icons.lock_open,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'login_screen.remember_token'.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              value: _rememberToken,
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
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 8,
                            onPressed: () {
                              if (_storedToken) {
                                tryToLoginWithStoredToken();
                              } else {
                                if (_tokenTextController.text == "") {
                                  snackbar.showInSnackBar(context,
                                      "login_screen.please_enter_token".tr());
                                } else {
                                  if (_rememberToken) {
                                    goToMainScreen(
                                        token: _tokenTextController.text,
                                        saveToken: true);
                                  } else {
                                    goToMainScreen(
                                        token: _tokenTextController.text,
                                        saveToken: false);
                                  }
                                }
                              }
                            },
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
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
