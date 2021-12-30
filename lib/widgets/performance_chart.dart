import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexa_dashboard/models/performance_datapoint.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({
    Key key,
    @required this.performanceSeries,
  }) : super(key: key);

  final List<PerformanceDataPoint> performanceSeries;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      primaryYAxis: NumericAxis(labelFormat: '{value}%'),
      tooltipBehavior: TooltipBehavior(elevation: 10),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipAlignment: ChartAlignment.near,
        tooltipSettings: InteractiveTooltip(
          enable: true,
          decimalPlaces: 2,
          color: Colors.black,
        ),
      ),
      palette: <Color>[
        Colors.green,
        Colors.red,
        Colors.blue,
        Colors.black,
      ],
      legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
          padding: 4,
          itemPadding: 10),
      // Initialize DateTime axis
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: <ChartSeries<PerformanceDataPoint, DateTime>>[
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.positive'.tr(),
          opacity: 0.5,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.bestReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.negative'.tr(),
          opacity: 0.5,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.worstReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.expected'.tr(),
          opacity: 0.5,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.expectedReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'performance_chart.real'.tr(),
          animationDuration: 2000,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.realReturn,
        ),
      ],
    );
  }
}
