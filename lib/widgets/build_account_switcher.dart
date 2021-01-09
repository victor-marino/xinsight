import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

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
          "Cuenta",
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
              //isExpanded: true,
              value: currentAccountNumber,
              items: accountDropdownItems,
              style: kAccountSwitcherTextStyle,
              selectedItemBuilder: (BuildContext context) {
                return accountDropdownItems
                    .map<Widget>((DropdownMenuItem item) {
                  return DropdownMenuItem(
                      child: Text(
                    (item.child as Text).data,
                    style: kAccountSwitcherSelectedTextStyle,
                  ));
                  //return Text((item.child as Text).data.split(" ")[1], style: TextStyle(height: 2.4));
                  //return Text((item), style: kAccountSwitcherTextStyle);
                }).toList();
              },
              underline: SizedBox(),
              // onChanged: (value) {
              //   reloadPage(value, currentPage);
              // },
              // onChanged: null,
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
