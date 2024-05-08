import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;

// Module that handles all biometric operations

final LocalAuthentication localAuthentication = LocalAuthentication();
final AndroidAuthMessages androidStrings = AndroidAuthMessages(
  biometricHint: "",
  biometricNotRecognized: "login_screen.user_not_recognized".tr(),
  biometricSuccess: "login_screen.user_authenticated".tr(),
  cancelButton: "login_screen.cancel".tr(),
  signInTitle: "login_screen.authentication".tr(),
  biometricRequiredTitle: "login_screen.biometrics_required".tr(),
  goToSettingsButton: "login_screen.go_to_settings".tr(),
  goToSettingsDescription: "login_screen.go_to_settings_description".tr(),
);
final IOSAuthMessages iosStrings = IOSAuthMessages(
  lockOut: "Locked Out",
  goToSettingsButton: "login_screen.go_to_settings".tr(),
  goToSettingsDescription: "login_screen.go_to_settings_description".tr(),
  cancelButton: "login_screen.cancel".tr(),
);

Future<bool> supportsBiometrics(BuildContext context) async {
  // Check if device supports biometric authentication
  bool isDeviceSupported = false;
  try {
    if (kDebugMode) {
      print("Checking support...");
    }
    isDeviceSupported = await localAuthentication.isDeviceSupported();
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
    if (context.mounted) snackbar.showInSnackBar(context, e.toString());
  }
  if (kDebugMode) {
    (isDeviceSupported)
        ? print("Biometrics supported")
        : print("Biometrics not supported");
  }
  return isDeviceSupported;
}

Future<bool> authenticateUserLocally(BuildContext context) async {
  // Executes biometric authentication if possible
  // Otherwise falls back to alternative method (e.g.: PIN)
  bool isAuthenticated = false;
  try {
    if (await (supportsBiometrics(context))) {
      if (kDebugMode) {
        print("Trying to authenticate...");
      }
      isAuthenticated = await localAuthentication.authenticate(
          authMessages: [androidStrings, iosStrings],
          localizedReason: "login_screen.please_authenticate".tr(),
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false,
            sensitiveTransaction: false,
          ));
    } else {
      if (kDebugMode) {
        print("Biometrics not supported");
      }
      isAuthenticated = false;
      if (context.mounted) {
        snackbar.showInSnackBar(
            context, "login_screen.screen_lock_required".tr());
      }
    }
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  if (kDebugMode) {
    isAuthenticated
        ? print("User authenticated")
        : print("User not authenticated");
  }
  return isAuthenticated;
}
