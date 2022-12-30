import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Plots the profit-loss chart with the monhtly returns

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    Key? key,
    required this.profitLossSeries,
    required this.selectedYear,
  }) : super(key: key);

  final Map<int, List<List>> profitLossSeries;
  final int? selectedYear;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        axes: [],
        primaryXAxis: CategoryAxis(
          interval: 1,
          crossesAt: 0,
          placeLabelsNearAxisLine: false,
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          labelStyle: kProfitLossChartLabelTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat("#0.0"),
          labelFormat: ' {value}%',
          isVisible: false,
          crossesAt: 0,
        ),
        series: <ChartSeries<List, String>>[
          ColumnSeries<List, String>(
            spacing: 0,
            width: 0.7,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: kChartLabelTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface),
              labelAlignment: ChartDataLabelAlignment.outer,
            ),
            enableTooltip: false,
            dataSource: profitLossSeries[selectedYear!]!,
            xValueMapper: (List month, _) => month[0],
            yValueMapper: (List month, _) => month[1],
            pointColorMapper: (List month, _) =>
                month[1] == null || month[1] > 0
                    ? Colors.green[500]
                    : Colors.red[900],
          ),
        ]);
  }
}
