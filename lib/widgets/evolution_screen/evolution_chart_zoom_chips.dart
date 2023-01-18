import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Creates the chip buttons for the zoom levels in the evolution chart

List<ChoiceChip> evolutionChartZoomChips(
    {Duration? selectedPeriod,
    required List<Map> zoomLevels,
    required Function reloadEvolutionChart,
    required BuildContext context}) {
  final TextStyle choiceChipsTextStyle = text_styles.robotoBold(context, 12);
  List<ChoiceChip> chipList = [];

  for (Map element in zoomLevels) {
    chipList.add(
      ChoiceChip(
        label: Text(('evolution_screen.' + element['label']).tr(),
            style: choiceChipsTextStyle),
        autofocus: false,
        clipBehavior: Clip.none,
        elevation: 1,
        pressElevation: 0,
        visualDensity: VisualDensity.compact,
        selected: selectedPeriod == element['duration'],
        onSelected: (bool selected) {
          reloadEvolutionChart(period: element['duration']);
        },
      ),
    );
  }
  return chipList;
}
