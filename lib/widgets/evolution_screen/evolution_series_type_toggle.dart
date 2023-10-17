import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/evolution_chart_provider.dart';

SizedBox evolutionSeriesTypeToggle(BuildContext context) {
  return SizedBox(
    width: 65,
    child: SegmentedButton<ChartSeriesType>(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.onPrimary;
              }
              return Theme.of(context).colorScheme.onSurface;
            },
          ),
          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        showSelectedIcon: false,
        segments: const <ButtonSegment<ChartSeriesType>>[
          ButtonSegment<ChartSeriesType>(
              value: ChartSeriesType.amounts, label: Text('€')),
          ButtonSegment<ChartSeriesType>(
              value: ChartSeriesType.returns, label: Text('%')),
        ],
        selected: <ChartSeriesType>{
          context.watch<EvolutionChartProvider>().seriesType
        },
        onSelectionChanged: (Set<ChartSeriesType> newSelection) {
          context.read<EvolutionChartProvider>().seriesType =
              newSelection.first;
        }),
  );
}
