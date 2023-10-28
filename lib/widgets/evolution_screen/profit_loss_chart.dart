import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:indexax/tools/profit_loss_chart_provider.dart';
import 'package:indexax/models/chart_series_type.dart';

// Plots the profit-loss chart with the monthly returns

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    Key? key,
    required this.profitLossSeries,
  }) : super(key: key);

  final Map<int, List<List>> profitLossSeries;

  @override
  Widget build(BuildContext context) {
    final TextStyle axisTextStyle = text_styles.roboto(context, 10);
    final TextStyle dataLabelTextStyle = text_styles.robotoBold(context, 8);

    ChartSeriesType seriesType =
        context.watch<ProfitLossChartProvider>().seriesType;
    int currentYear = context.watch<ProfitLossChartProvider>().currentYear;

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
          numberFormat: seriesType == ChartSeriesType.returns
              ? NumberFormat("#0.#")
              : NumberFormat.compactCurrency(
                  decimalDigits: 0, locale: "en_GB", symbol: ''),
          labelFormat: seriesType == ChartSeriesType.returns
              ? ' {value}%'
              : ' {value} €',
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
            dataSource: profitLossSeries[currentYear]!,
            xValueMapper: (List month, _) => month[0],
            yValueMapper: (List month, _) =>
                seriesType == ChartSeriesType.returns ? month[1] : month[2],
            pointColorMapper: (List month, _) =>
                month[1] == null || month[1] > 0
                    ? Colors.green[500]
                    : Colors.red[900],
          ),
        ]);
  }
}
