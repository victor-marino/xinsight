import 'package:flutter/material.dart';

DropdownButton buildAccountSwitcher({int currentAccountNumber, List<DropdownMenuItem> accountDropdownItems, Function reloadPageFromAccountSwitcher}) {
  return DropdownButton(
    value: currentAccountNumber,
    items: accountDropdownItems,
    onChanged: (value) {
      reloadPageFromAccountSwitcher(value);
    },
  );
}