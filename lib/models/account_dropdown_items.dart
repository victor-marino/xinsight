import 'package:flutter/material.dart';

class AccountDropdownItems {
  final List<String>? userAccounts;

  AccountDropdownItems({this.userAccounts});

  static List<DropdownMenuItem> _dropdownItems(List<String> userAccounts) {
    List<DropdownMenuItem> _accountDropdownItems = [];
    for (var account in userAccounts) {
      _accountDropdownItems.add(
        DropdownMenuItem(
          child: Text(account),
          value: _accountDropdownItems.length,
        ),
      );
    }
    return _accountDropdownItems;
  }

  List<DropdownMenuItem> get dropdownItems => _dropdownItems(userAccounts!);
}
