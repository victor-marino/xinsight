import 'package:flutter/material.dart';
import 'package:indexax/tools/text_styles.dart';

// Dropdown year switcher for the profit-loss chart

class ProfitLossYearSwitcher extends StatelessWidget {
  const ProfitLossYearSwitcher(
      {Key? key,
      required this.currentYear,
      required this.yearList,
      required this.reloadProfitLossChart})
      : super(key: key);

  final int currentYear;
  final List<int> yearList;
  final Function reloadProfitLossChart;

  @override
  Widget build(BuildContext context) {
    bool dropdownEnabled = false;

    if (yearList.length > 1) {
      dropdownEnabled = true;
    }

    List<DropdownMenuItem> profitLossYearDropdownItems = [];

    for (int i = 0; i < yearList.length; i++) {
      profitLossYearDropdownItems.add(
        DropdownMenuItem(
          child: Text(yearList[i].toString(),
              style: yearList[i] == currentYear
                  ? roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold)
                  : roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
          value: yearList[i],
          enabled: yearList[i] == currentYear ? false : true,
        ),
      );
    }

    profitLossYearDropdownItems.sort((b, a) => a.value.compareTo(b.value));

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
                if (dropdownEnabled)
                  Icon(Icons.arrow_drop_down_rounded,
                      size: 20, color: Colors.blue),
                DropdownButton(
                  iconSize: 0,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  disabledHint: DropdownMenuItem(
                      child: Text(
                    currentYear.toString(),
                    style: roboto15Bold.copyWith(color: Colors.black38),
                  )),
                  value: currentYear,
                  items: profitLossYearDropdownItems,
                  style: roboto15,
                  selectedItemBuilder: (BuildContext context) {
                    return profitLossYearDropdownItems
                        .map<Widget>((DropdownMenuItem item) {
                      return DropdownMenuItem(
                          child: Text(
                        (item.child as Text).data!,
                        style: dropdownEnabled
                            ? roboto15Bold.copyWith(
                                color: Theme.of(context).colorScheme.onSurface)
                            : roboto15Bold.copyWith(color: Colors.black45),
                      ));
                    }).toList();
                  },
                  underline: SizedBox(),
                  onChanged: dropdownEnabled
                      ? (dynamic value) {
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
}
