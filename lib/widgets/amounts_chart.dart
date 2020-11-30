import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:indexa_dashboard/models/amounts_datapoint.dart';

class AmountsChart extends StatelessWidget {
  const AmountsChart({
    Key key,
    //@required this.gradientColors,
    @required this.amountsSeries,
  }) : super(key: key);

  final List<AmountsDataPoint> amountsSeries;

  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(Color(0xFF4FC3F7));
    color.add(Color(0xFFE040FB));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.7);

    final LinearGradient gradientColors = LinearGradient(
        transform: GradientRotation(pi * 1.5), colors: color, stops: stops);

    return SfCartesianChart(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      primaryYAxis: NumericAxis(labelFormat: '{value} €'),
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
        Colors.blue,
        Colors.blueGrey,
      ],
      legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
          padding: 4,
          itemPadding: 10),
      // Initialize DateTime axis
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        //minimum: DateTime(2020, 05, 01),
        dateFormat: DateFormat("d/M/yy"),
        //rangePadding: ChartRangePadding.round,
      ),
      series: <ChartSeries<AmountsDataPoint, DateTime>>[
        AreaSeries<AmountsDataPoint, DateTime>(
          name: 'Total',
          opacity: 0.7,
          // Bind data source
          dataSource: amountsSeries,
          xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
          yValueMapper: (AmountsDataPoint amounts, _) => amounts.totalAmount,
          gradient: gradientColors,
        ),
        LineSeries<AmountsDataPoint, DateTime>(
          name: 'Aportado',
          // Bind data source
          dataSource: amountsSeries,
          xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
          yValueMapper: (AmountsDataPoint amounts, _) => amounts.netAmount,
        ),
      ],
    );
  }
}
