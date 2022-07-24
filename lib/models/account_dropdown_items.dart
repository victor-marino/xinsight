import 'package:flutter/material.dart';

class AccountDropdownItems {
  final List<String>? userAccounts;

  AccountDropdownItems({this.userAccounts});

  static List<DropdownMenuItem> _dropdownItems(List<String> userAccounts) {
    List<DropdownMenuItem> accountDropdownItems = [];
    for (var account in userAccounts) {
      accountDropdownItems.add(
        DropdownMenuItem(
          child: Text(account),
          value: accountDropdownItems.length,
        ),
      );
    }
    return accountDropdownItems;
  }

  List<DropdownMenuItem> get dropdownItems => _dropdownItems(userAccounts!);
}
