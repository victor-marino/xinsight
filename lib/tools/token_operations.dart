import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/services/indexa_data.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/validations.dart' as validations;
import 'package:indexax/tools/secure_storage.dart';
import 'package:indexax/widgets/circular_progress_indicator.dart';

final storage = SecureStorage();

Future<void> storeToken(
    BuildContext context, String value) async {
  value = validations.sanitizeToken(value);
  if (validations.validateTokenFormat(value)) {
    await storage.storeKey(keyName: "indexaToken", value: value);
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
    token = await storage.read("indexaToken");
  } on Exception catch (e) {
    snackbar.showInSnackBar(context, e.toString());
  }
  return token;
}

Future<void> deleteToken() async {
  await storage.deleteKey(keyName: "indexaToken");
}

Future<bool?> authenticateToken(BuildContext context, String token) async {
  bool? authenticatedToken;
  token = validations.sanitizeToken(token);
  if (validations.validateTokenFormat(token)) {
    buildLoading(context);
    IndexaData indexaData = IndexaData(token: token);
    try {
      var userAccounts = await indexaData.getUserAccounts();
      if (userAccounts != null) {
        print("Token authenticated!");
        Navigator.of(context).pop();
        authenticatedToken = true;
      } else {
        Navigator.of(context).pop();
        authenticatedToken = false;
      }
    } on Exception catch (e) {
      Navigator.of(context).pop();
      print(e);
      throw (e);
    }
  } else {
    snackbar.showInSnackBar(
      context,
      "login_screen.invalid_token_format".tr(),
    );
  }
  return authenticatedToken;
}
