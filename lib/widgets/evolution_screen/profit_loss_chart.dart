import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/profit_loss_datapoint.dart';
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

  final Map<int, List<ProfitLossDataPoint?>> profitLossSeries;

  @override
  Widget build(BuildContext context) {
    final TextStyle axisTextStyle = text_styles.roboto(context, 10);
    final TextStyle dataLabelTextStyle = text_styles.robotoBold(context, 8);

    ChartSeriesType seriesType =
        context.watch<ProfitLossChartProvider>().seriesType;
    int selectedYear = context.watch<ProfitLossChartProvider>().selectedYear;

    NumberFormat primaryYAxisNumberFormat;
    String primaryYAxisLabelFormat;
    List<ProfitLossDataPoint?> dataSource;
    String? xValueMapper(ProfitLossDataPoint? datapoint, _) =>
        datapoint?.periodName;
    num? Function(ProfitLossDataPoint? datapoint, int) yValueMapper;
    Color? pointColorMapper(ProfitLossDataPoint? datapoint, _) =>
        (datapoint != null) ? datapoint.color : null;
    double chartOffset = 0;

    List<ProfitLossDataPoint> annualSeries = [];
    double totalPercentReturn = 1;
    double totalCashReturn = 0;

    // Create the annual series
    for (var element in profitLossSeries.keys) {
      String periodName = element.toString();
      double? percentReturn = profitLossSeries[element]![12]!.percentReturn;
      double? cashReturn = profitLossSeries[element]![12]!.cashReturn;
      annualSeries.add(ProfitLossDataPoint(
          periodName: periodName,
          percentReturn: percentReturn,
          cashReturn: cashReturn));
      if (profitLossSeries[element]![12]!.percentReturn != null) {
        totalPercentReturn *=
            (profitLossSeries[element]![12]!.percentReturn)! + 1;
      }
      if (profitLossSeries[element]![12]!.cashReturn != null) {
        totalCashReturn += profitLossSeries[element]![12]!.cashReturn!;
      }
    }
    annualSeries.add(ProfitLossDataPoint(
        periodName: "Total",
        percentReturn: (totalPercentReturn - 1),
        cashReturn: totalCashReturn));

    // Prepare the chart depending on selected data
    if (seriesType == ChartSeriesType.returns) {
      // Percentage returns
      primaryYAxisNumberFormat =
          NumberFormat.decimalPercentPattern(decimalDigits: 1);
      primaryYAxisLabelFormat = ' {value}';
      if (selectedYear == 0) {
        // Annual returns
        dataSource = annualSeries;
        yValueMapper =
            (ProfitLossDataPoint? datapoint, _) => datapoint!.percentReturn;
        chartOffset = annualSeries.length.toDouble() - 10;
      } else {
        // Monthly returns for selected year
        dataSource = profitLossSeries[selectedYear]!;
        yValueMapper =
            (ProfitLossDataPoint? datapoint, _) => datapoint!.percentReturn;
      }
    } else {
      // Cash returns
      primaryYAxisNumberFormat = NumberFormat.compactCurrency(
          decimalDigits: 0, locale: "en_GB", symbol: '');
      primaryYAxisLabelFormat = ' {value} €';
      if (selectedYear == 0) {
        // Annual returns
        dataSource = annualSeries;
        yValueMapper =
            (ProfitLossDataPoint? datapoint, _) => datapoint!.cashReturn;
        chartOffset = annualSeries.length.toDouble() - 10;
      } else {
        // Monthly returns for selected year
        dataSource = profitLossSeries[selectedYear]!;
        yValueMapper =
            (ProfitLossDataPoint? datapoint, _) => datapoint!.cashReturn;
      }
    }

    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        axes: const [],
        enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(
            interval: 1,
            crossesAt: 0,
            placeLabelsNearAxisLine: false,
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            labelStyle: axisTextStyle,
            visibleMinimum: chartOffset),
        primaryYAxis: NumericAxis(
          numberFormat: primaryYAxisNumberFormat,
          labelFormat: primaryYAxisLabelFormat,
          isVisible: false,
          crossesAt: 0,
        ),
        series: <ChartSeries<ProfitLossDataPoint?, String>>[
          ColumnSeries<ProfitLossDataPoint?, String>(
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
            pointColorMapper: pointColorMapper,
          )
        ]);
  }
}
