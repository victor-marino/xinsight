import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/validations.dart' as validations;
import 'package:indexax/tools/secure_storage.dart';
import 'package:indexax/widgets/circular_progress_indicator.dart';
import 'package:indexax/tools/indexa_data.dart';

// All token-related functions are grouped here

final _storage = SecureStorage();

Future<void> storeToken(BuildContext context, String value) async {
  value = validations.sanitizeToken(value);
  if (validations.validateTokenFormat(value)) {
    try {
      await _storage.storeKey(keyName: "indexaToken", value: value);
    } on Exception catch (e) {
      snackbar.showInSnackBar(context, e.toString());
    }
  } else {
    snackbar.showInSnackBar(
      context,
      "login_screen.invalid_token_format".tr(),
    );
  }
}

Future<String?> readToken(BuildContext context) async {
  String? token;
  try {
    token = await _storage.read("indexaToken");
  } on Exception catch (e) {
    snackbar.showInSnackBar(context, e.toString());
  }
  return token;
}

Future<void> deleteToken(BuildContext context) async {
  try {
    await _storage.deleteKey(keyName: "indexaToken");
  } on Exception catch (e) {
    snackbar.showInSnackBar(context, e.toString());
  }
}

Future<bool?> authenticateToken(BuildContext context, String token) async {
  // Checks if a token is valid by trying to authenticate with it
  bool? authenticatedToken;
  token = validations.sanitizeToken(token);
  if (validations.validateTokenFormat(token)) {
    buildLoading(context);
    IndexaData indexaData = IndexaData(token: token);
    try {
      // Passing contexts across async calls can cause problems, so instead 
      // we previously store the navigator in a variable and pass it later
      NavigatorState currentNavigator = Navigator.of(context);
      var userAccounts = await indexaData.getUserAccounts();
      if (userAccounts != null) {
        if (kDebugMode) {
          print("Token authenticated!");
        }
        currentNavigator.pop();
        authenticatedToken = true;
      } else {
        currentNavigator.pop();
        authenticatedToken = false;
      }
    } on Exception catch (e) {
      Navigator.of(context).pop();
      if (kDebugMode) {
        print(e);
      }
      snackbar.showInSnackBar(
        context,
        e.toString(),
      );
    }
  } else {
    snackbar.showInSnackBar(
      context,
      "login_screen.invalid_token_format".tr(),
    );
  }
  return authenticatedToken;
}
