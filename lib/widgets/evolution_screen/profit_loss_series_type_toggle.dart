import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';
import 'package:indexax/tools/profit_loss_chart_provider.dart';
import 'package:provider/provider.dart';

Widget showProfitLossSeriesTypeToggle(BuildContext context) {
  return SizedBox(
    width: 65,
    child: SegmentedButton<ChartSeriesType>(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
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
          context.watch<ProfitLossChartProvider>().seriesType
        },
        onSelectionChanged: (Set<ChartSeriesType> newSelection) {
          context.read<ProfitLossChartProvider>().seriesType =
              newSelection.first;
        }),
  );
}
