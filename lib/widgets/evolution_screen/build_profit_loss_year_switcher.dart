// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';

Widget buildProfitLossYearSwitcher(
    {int currentYear,
    List<DropdownMenuItem> profitLossYearDropdownItems,
    Function reloadProfitLossChart}) {
  bool dropdownEnabled;

  if (profitLossYearDropdownItems.length == 1) {
    dropdownEnabled = false;
  } else {
    dropdownEnabled = true;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (dropdownEnabled) Icon(
                Icons.arrow_drop_down_rounded, size: 20, color: Colors.blue),
              DropdownButton(
                iconSize: 0,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                disabledHint: DropdownMenuItem(
                    child: Text(
                  (profitLossYearDropdownItems[0].child as Text).data,
                  style: kAccountSwitcherDisabledSelectedTextStyle,
                )),
                value: currentYear,
                items: profitLossYearDropdownItems,
                style: kAccountSwitcherTextStyle,
                selectedItemBuilder: (BuildContext context) {
                  return profitLossYearDropdownItems
                      .map<Widget>((DropdownMenuItem item) {
                    return DropdownMenuItem(
                        child: Text(
                      (item.child as Text).data,
                      style: kAccountSwitcherSelectedTextStyle,
                    ));
                  }).toList();
                },
                underline: SizedBox(),
                onChanged: dropdownEnabled
                    ? (value) {
                        reloadProfitLossChart(value);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
