import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/models/performance_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Chart showing the future projection and expectations of the portfolio

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({
    super.key,
    required this.performanceSeries,
  });

  final List<PerformanceDataPoint> performanceSeries;

  @override
  Widget build(BuildContext context) {
    TextStyle axisTextStyle = text_styles.roboto(context, 10);

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      primaryYAxis: NumericAxis(
          labelFormat: '{value} %',
          numberFormat: NumberFormat.decimalPattern(getCurrentLocale()),
          labelStyle: axisTextStyle),
      tooltipBehavior: TooltipBehavior(elevation: 10),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipAlignment: ChartAlignment.near,
        tooltipSettings: InteractiveTooltip(
            enable: true,
            decimalPlaces: 2,
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderColor: Theme.of(context).colorScheme.outline,
            borderWidth: 1,
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      ),
      palette: <Color>[
        Colors.green,
        Colors.red,
        Colors.blue,
        Theme.of(context).colorScheme.onSurface,
      ],
      legend: const Legend(
          isVisible: true,
          position: LegendPosition.top,
          padding: 4,
          itemPadding: 10,
          overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelStyle: axisTextStyle,
      ),
      series: <CartesianSeries<PerformanceDataPoint, DateTime>>[
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.positive'.tr(),
          opacity: 1,
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) =>
              performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) =>
              performances.bestReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.negative'.tr(),
          opacity: 0.5,
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) =>
              performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) =>
              performances.worstReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.expected'.tr(),
          opacity: 0.5,
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) =>
              performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) =>
              performances.expectedReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.real'.tr(),
          animationDuration: 2000,
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) =>
              performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) =>
              performances.realReturn,
        ),
      ],
    );
  }
}
