import 'package:flutter/material.dart';
import 'package:indexax/tools/local_authentication.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:easy_localization/easy_localization.dart';

// Provider for toggling privacy mode
class PrivateModeProvider with ChangeNotifier {
  bool _privateModeEnabled = false;

  bool get privateModeEnabled => _privateModeEnabled;

  set privateModeEnabled(bool hidden) {
    _privateModeEnabled = hidden;
    notifyListeners();
  }

  void togglePrivateMode(BuildContext context) async {
    if (_privateModeEnabled) {
      bool isAuthenticated = await authenticateUserLocally(context);
      if (isAuthenticated && context.mounted) {
        _privateModeEnabled = false;
        snackbar.showInSnackBar(
            context, "root_screen.private_mode_disabled".tr());
      }
    } else {
      _privateModeEnabled = true;
      snackbar.showInSnackBar(context, "root_screen.private_mode_enabled".tr());
    }
    notifyListeners();
  }
}
