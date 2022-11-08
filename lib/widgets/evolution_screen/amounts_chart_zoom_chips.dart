import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';

List<ChoiceChip> amountsChartZoomChips(
    {Duration? selectedPeriod,
    required List<Map> zoomLevels,
    Function? reloadAmountsChart,
    required BuildContext context}) {
  List<ChoiceChip> chipList = [];

  for (Map element in zoomLevels) {
    chipList.add(
      ChoiceChip(
        label: Text(('evolution_screen.' + element['label']).tr(),
            style: kChipTextStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface)),
        autofocus: false,
        clipBehavior: Clip.none,
        elevation: 1,
        pressElevation: 0,
        visualDensity: VisualDensity.compact,
        selected: selectedPeriod == element['duration'],
        onSelected: (bool selected) {
          reloadAmountsChart!(element['duration']);
        },
      ),
    );
  }
  return chipList;
}
