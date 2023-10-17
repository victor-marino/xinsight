import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/tools/evolution_chart_provider.dart';
import 'package:provider/provider.dart';

// Creates the chip buttons for the zoom levels in the evolution chart

List<ChoiceChip> evolutionChartZoomChips(
    {required BuildContext context}) {
  final TextStyle choiceChipsTextStyle = text_styles.robotoBold(context, 12);
  List<ChoiceChip> chipList = [];

    // Zoom options for the evolution chart
  final List<Map> zoomLevels = [
    {"label": "1m", "duration": const Duration(days: 30)},
    {"label": "3m", "duration": const Duration(days: 90)},
    {"label": "6m", "duration": const Duration(days: 180)},
    {"label": "1y", "duration": const Duration(days: 365)},
    {"label": "5y", "duration": const Duration(days: 1825)},
    {"label": "all", "duration": const Duration(seconds: 0)},
  ];
  
  for (Map element in zoomLevels) {
    chipList.add(
      ChoiceChip(
        label: Text("evolution_screen.${element['label']}".tr(),
            style: choiceChipsTextStyle),
        autofocus: false,
        clipBehavior: Clip.none,
        elevation: 1,
        pressElevation: 0,
        visualDensity: VisualDensity.compact,
        selected: context.watch<EvolutionChartProvider>().zoomLevel ==
            element['duration'],
        onSelected: (bool selected) {
          context.read<EvolutionChartProvider>().setPeriod =
              element['duration'];
        },
      ),
    );
  }
  return chipList;
}
