import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

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

  //dropdownEnabled = false;

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
              dropdownEnabled ? Icon(
                Icons.arrow_drop_down_outlined, size: 20) : SizedBox(width: 0, height: 0),
              DropdownButton(
                iconSize: 0,
                disabledHint: DropdownMenuItem(
                    child: Text(
                  (profitLossYearDropdownItems[0].child as Text).data,
                  style: kAccountSwitcherDisabledSelectedTextStyle,
                )),
                //isExpanded: true,
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
                    //return Text((item.child as Text).data.split(" ")[1], style: TextStyle(height: 2.4));
                    //return Text((item), style: kAccountSwitcherTextStyle);
                  }).toList();
                },
                underline: SizedBox(),
                // onChanged: (value) {
                //   reloadPage(value, currentPage);
                // },
                // onChanged: null,
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
