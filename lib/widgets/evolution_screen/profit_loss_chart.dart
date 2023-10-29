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
    int selectedYear = context.watch<ProfitLossChartProvider>().selectedYear;

    NumberFormat primaryYAxisNumberFormat;
    String primaryYAxisLabelFormat;
    List<List<dynamic>> dataSource;
    String Function(List<dynamic>, int) xValueMapper =
        (List month, _) => month[0];
    num? Function(List<dynamic>, int) yValueMapper;

    if (seriesType == ChartSeriesType.returns) {
      primaryYAxisNumberFormat = NumberFormat("#0.#");
      primaryYAxisLabelFormat = ' {value}%';
      if (selectedYear != 0) {
        dataSource = profitLossSeries[selectedYear]!;
        yValueMapper = (List month, _) => month[1];
      } else {
        List<List<dynamic>> annualSeries = [];
        profitLossSeries.keys.forEach((element) {
          annualSeries
              .add([element.toString(), profitLossSeries[element]![12][1], profitLossSeries[element]![12][2]
          ]);
        });
        print(annualSeries.toString());
        dataSource = annualSeries;
        yValueMapper = (List year, _) => year[1];
      }
    } else {
      primaryYAxisNumberFormat = NumberFormat.compactCurrency(
          decimalDigits: 0, locale: "en_GB", symbol: '');
      primaryYAxisLabelFormat = ' {value} €';
      if (selectedYear != 0) {
        dataSource = profitLossSeries[selectedYear]!;
        yValueMapper = (List month, _) => month[2];
      } else {
        dataSource = profitLossSeries[selectedYear]!;
        yValueMapper = (List month, _) => month[1];
      }
    }

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
          numberFormat: primaryYAxisNumberFormat,
          labelFormat: primaryYAxisLabelFormat,
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
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            pointColorMapper: (List month, _) =>
                month[1] == null || month[1] > 0
                    ? Colors.green[500]
                    : Colors.red[900],
          ),
        ]);
  }
}
