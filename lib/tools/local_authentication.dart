import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
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
    print("Checking support...");
    isDeviceSupported = await localAuthentication.isDeviceSupported();
  } on Exception catch (e) {
    print(e);
    snackbar.showInSnackBar(context, e.toString());
  }
  (isDeviceSupported)
      ? print("Biometrics supported")
      : print("Biometrics not supported");

  return isDeviceSupported;
}

Future<bool> authenticateUserLocally(BuildContext context) async {
  // Executes biometric authentication if possible
  // Otherwise falls back to alternative method (e.g.: PIN)
  bool isAuthenticated = false;
  try {
    if (await (supportsBiometrics(context))) {
      print("Trying to authenticate...");
      isAuthenticated = await localAuthentication.authenticate(
          authMessages: [androidStrings, iosStrings],
          localizedReason: "login_screen.please_authenticate".tr(),
          options: AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false,
            sensitiveTransaction: false,
          ));
    } else {
      print("Biometrics not supported");
      isAuthenticated = false;
      snackbar.showInSnackBar(
          context, "login_screen.screen_lock_required".tr());
    }
  } on Exception catch (e) {
    print(e);
  }

  isAuthenticated
      ? print("User authenticated")
      : print("User not authenticated");

  return isAuthenticated;
}
