import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:syncfusion_flutter_charts/charts.dart';

// Plots the profit-loss chart with the monthly returns

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    Key? key,
    required this.profitLossSeries,
    required this.selectedYear,
  }) : super(key: key);

  final Map<int, List<List>> profitLossSeries;
  final int selectedYear;  

  @override
  Widget build(BuildContext context) {
    final TextStyle axisTextStyle = text_styles.roboto(context, 10);
    final TextStyle dataLabelTextStyle = text_styles.robotoBold(context, 8);

    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        axes: const [],
        primaryXAxis: CategoryAxis(
          interval: 1,
          crossesAt: 0,
          placeLabelsNearAxisLine: false,
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          labelStyle: axisTextStyle,
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
              textStyle: dataLabelTextStyle,
              labelAlignment: ChartDataLabelAlignment.outer,
            ),
            enableTooltip: false,
            dataSource: profitLossSeries[selectedYear]!,
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
