import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/tools/profit_loss_chart_provider.dart';
import 'package:provider/provider.dart';

// Dropdown year switcher for the profit-loss chart

class ProfitLossYearSwitcher extends StatelessWidget {
  const ProfitLossYearSwitcher({Key? key, required this.yearList})
      : super(key: key);

  final List<int> yearList;

  @override
  Widget build(BuildContext context) {
    TextStyle nonSelectedYearTextStyle = text_styles.roboto(context, 15);
    TextStyle selectedYearTextStyle = text_styles.robotoBold(context, 15);
    TextStyle disabledYearTextStyle =
        text_styles.robotoBoldLighter(context, 15);

    bool dropdownEnabled = false;

    int currentYear = context.watch<ProfitLossChartProvider>().selectedYear;

    if (yearList.length > 1) {
      dropdownEnabled = true;
    }

    List<DropdownMenuItem> profitLossYearDropdownItems = [];

    
    for (int i = 0; i < yearList.length; i++) {
      profitLossYearDropdownItems.add(
        DropdownMenuItem(
          value: yearList[i],
          enabled: yearList[i] == currentYear ? false : true,
          child: Text(yearList[i].toString(),
              style: yearList[i] == currentYear
                  ? selectedYearTextStyle
                  : nonSelectedYearTextStyle),
        ),
      );
    }
    

    profitLossYearDropdownItems.sort((b, a) => a.value.compareTo(b.value));

    profitLossYearDropdownItems.insert(0, DropdownMenuItem(
      value: 0,
      enabled: 0 == currentYear ? false : true,
      child: Text("Anual",
          style: 0 == currentYear
              ? selectedYearTextStyle
              : nonSelectedYearTextStyle),
    ));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (dropdownEnabled)
                  const Icon(Icons.arrow_drop_down_rounded,
                      size: 20, color: Colors.blue),
                DropdownButton(
                  iconSize: 0,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  underline: const SizedBox(),
                  onChanged: dropdownEnabled
                      ? (dynamic value) {
                          context
                              .read<ProfitLossChartProvider>()
                              .updateCurrentYear(value);
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
