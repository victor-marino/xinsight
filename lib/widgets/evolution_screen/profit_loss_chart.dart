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

  final ({
    Map<int, List<ProfitLossDataPoint?>> monthlySeries,
    List<ProfitLossDataPoint> annualSeries
  }) profitLossSeries;

  @override
  Widget build(BuildContext context) {
    // Text styles for the chart
    final TextStyle axisTextStyle = text_styles.roboto(context, 10);
    final TextStyle dataLabelTextStyle = text_styles.robotoBold(context, 8);

    // Watch the necessary provider variables to update the chart
    // whenever the user changes any filters.
    ChartSeriesType seriesType =
        context.watch<ProfitLossChartProvider>().seriesType;
    int selectedYear = context.watch<ProfitLossChartProvider>().selectedYear;

    // Declaration of variables containing chart settings that will be modified
    // depending on selected filters. Extracted up here to avoid cluttering
    // the code of the chart with too many conditions and ternary operators.
    NumberFormat primaryYAxisNumberFormat;
    String primaryYAxisLabelFormat;
    List<ProfitLossDataPoint?> dataSource;
    String? xValueMapper(ProfitLossDataPoint? datapoint, _) =>
        datapoint?.periodName;
    num? Function(ProfitLossDataPoint? datapoint, int) yValueMapper;
    Color? pointColorMapper(ProfitLossDataPoint? datapoint, _) =>
        datapoint?.color;
    double? chartOffset;
    ZoomPanBehavior zoomPanBehavior;

    // Set and update chart settings depending on user-selected filters
    if (seriesType == ChartSeriesType.returns) {
      // Percentage returns
      primaryYAxisNumberFormat =
          NumberFormat.decimalPercentPattern(decimalDigits: 1);
      primaryYAxisLabelFormat = ' {value}';
      yValueMapper =
          (ProfitLossDataPoint? datapoint, _) => datapoint!.percentReturn;
    } else {
      // Cash returns
      primaryYAxisNumberFormat = NumberFormat.compactCurrency(
          decimalDigits: 0, locale: "en_GB", symbol: '');
      primaryYAxisLabelFormat = ' {value} €';
      yValueMapper =
          (ProfitLossDataPoint? datapoint, _) => datapoint!.cashReturn;
    }

    if (selectedYear == 0) {
      // Annual returns
      dataSource = profitLossSeries.annualSeries;
      chartOffset = profitLossSeries.annualSeries.length.toDouble() - 10;
      if (dataSource.length >= 10) {
        zoomPanBehavior =
            ZoomPanBehavior(enablePanning: true, zoomMode: ZoomMode.x);
      } else {
        zoomPanBehavior =
            ZoomPanBehavior(enablePanning: false, zoomMode: ZoomMode.x);
      }
    } else {
      // Monthly returns for selected year
      dataSource = profitLossSeries.monthlySeries[selectedYear]!;
      chartOffset = 0;
      zoomPanBehavior =
          ZoomPanBehavior(enablePanning: false, zoomMode: ZoomMode.x);
    }

    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        axes: const [],
        enableAxisAnimation: true,
        zoomPanBehavior: zoomPanBehavior,
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
            anchorRangeToVisiblePoints: false),
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
