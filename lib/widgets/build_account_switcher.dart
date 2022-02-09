// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';

Widget buildAccountSwitcher(
    {int currentAccountNumber,
    int currentPage,
    List<DropdownMenuItem> accountDropdownItems,
    Function reloadPage}) {
    bool dropdownEnabled;

  if (accountDropdownItems.length == 1) {
    dropdownEnabled = false;
  } else {
    dropdownEnabled = true;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'account_switcher.account'.tr() + ':',
          style: TextStyle(
            color: Colors.blueGrey[300],
          ),
        ),
      ),
      DecoratedBox(
        decoration: dropdownEnabled ? kEnabledAccountSwitcherBoxDecoration : kDisabledAccountSwitcherBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 40,
            child: DropdownButton(
              iconSize: 0,
              disabledHint: DropdownMenuItem(
                  child: Text(
                    (accountDropdownItems[0].child as Text).data,
                  style: kAccountSwitcherDisabledSelectedTextStyle,
                  )),
              value: currentAccountNumber,
              items: accountDropdownItems,
              style: kAccountSwitcherTextStyle,
              selectedItemBuilder: (BuildContext context) {
                return accountDropdownItems
                    .map<Widget>((DropdownMenuItem item) {
                  return DropdownMenuItem(
                      child: Text(
                    (item.child as Text).data,
                    style: dropdownEnabled ? kAccountSwitcherSelectedTextStyle : kAccountSwitcherDisabledSelectedTextStyle,
                  ));
                }).toList();
              },
              underline: SizedBox(),
              onChanged: dropdownEnabled ? (value) {
                reloadPage(value, currentPage);
              } : null,
            ),
          ),
        ),
      ),
    ],
  );
}
