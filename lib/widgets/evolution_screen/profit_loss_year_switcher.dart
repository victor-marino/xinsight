import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

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
    TextStyle nonSelectedYearTextStyle = text_styles.roboto(context, 15);
    TextStyle selectedYearTextStyle = text_styles.robotoBold(context, 15);
    TextStyle disabledYearTextStyle =
        text_styles.robotoBoldLighter(context, 15);

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
                  ? selectedYearTextStyle
                  : nonSelectedYearTextStyle),
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
                    style: selectedYearTextStyle,
                  )),
                  value: currentYear,
                  items: profitLossYearDropdownItems,
                  style: nonSelectedYearTextStyle,
                  selectedItemBuilder: (BuildContext context) {
                    return profitLossYearDropdownItems
                        .map<Widget>((DropdownMenuItem item) {
                      return DropdownMenuItem(
                          child: Text(
                        (item.child as Text).data!,
                        style: dropdownEnabled
                            ? selectedYearTextStyle
                            : disabledYearTextStyle,
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
