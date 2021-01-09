import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

Widget buildAccountSwitcher({int currentAccountNumber, int currentPage, List<DropdownMenuItem> accountDropdownItems, Function reloadPage}) {
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
        decoration: ShapeDecoration(
          color: Colors.blueGrey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 40,
            child: DropdownButton(
              iconSize: 0,
              //isExpanded: true,
              value: currentAccountNumber,
              items: accountDropdownItems,
              style: kAccountSwitcherTextStyle,
              // selectedItemBuilder: (BuildContext context) {
              //   return accountDropdownItems.map<Widget>((DropdownMenuItem item) {
              //     return item.child;
              //     //return Text((item.child as Text).data.split(" ")[1], style: TextStyle(height: 2.4));
              //
              //   }).toList();
              // },
              underline: SizedBox(),
              onChanged: (value) {
                reloadPage(value, currentPage);
              },
            ),
          ),
        ),
      ),
    ],
  );
}