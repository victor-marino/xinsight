import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:indexa_dashboard/models/amounts_datapoint.dart';
import 'package:indexa_dashboard/models/performance_datapoint.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({
    Key key,
    //@required this.gradientColors,
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
      zoomPanBehavior: ZoomPanBehavior(
          // Enables pinch zooming
          enablePinching: true,
          zoomMode: ZoomMode.x,
          enablePanning: true),
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
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries<PerformanceDataPoint, DateTime>>[
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'Positivo',
          opacity: 0.5,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.bestReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'Negativo',
          opacity: 0.5,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.worstReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'Esperado',
          opacity: 0.5,
          // Bind data source
          dataSource: performanceSeries,
          xValueMapper: (PerformanceDataPoint performances, _) => performances.date,
          yValueMapper: (PerformanceDataPoint performances, _) => performances.expectedReturn,
        ),
        LineSeries<PerformanceDataPoint, DateTime>(
          name: 'Real',
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
