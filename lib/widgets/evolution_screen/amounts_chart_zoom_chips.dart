import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';

List<ChoiceChip> amountsChartZoomChips(
    {Duration currentPeriod,
    List<Map> zoomLevels,
    Function reloadAmountsChart}) {

  List<ChoiceChip> chipList = [];

  for (Map element in zoomLevels) {
    chipList.add(
      ChoiceChip(
        label: Text(('evolution_screen.' + element['label']).tr(),
            style: kChipTextStyle),
        autofocus: false,
        clipBehavior: Clip.none,
        elevation: 0,
        pressElevation: 0,
        visualDensity: VisualDensity.compact,
        selected: currentPeriod == element['duration'],
        onSelected: (bool selected) {
          reloadAmountsChart(element['duration']);
        },
      ),
    );
  }
  return chipList;
}
