import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:indexax/models/amounts_datapoint.dart';

class AmountsChart extends StatelessWidget {
  const AmountsChart({
    Key? key,
    required this.amountsSeries,
    this.period,
  }) : super(key: key);

  final List<AmountsDataPoint> amountsSeries;
  final Duration? period;

  @override
  Widget build(BuildContext context) {
    DateTime? startDate;

    if (period == null) {
      startDate = amountsSeries[0].date;
    } else if (amountsSeries.last.date!
        .subtract(period!)
        .isBefore(amountsSeries[0].date!)) {
      startDate = amountsSeries[0].date;
    } else {
      startDate = amountsSeries.last.date!.subtract(period!);
    }

    final List<Color> color = <Color>[];
    color.add(Colors.white);
    color.add(Colors.blue);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.6);

    final LinearGradient gradientColors = LinearGradient(
        transform: GradientRotation(pi * 1.5), colors: color, stops: stops);

    return SfCartesianChart(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          labelStyle: kProfitLossChartLabelTextStyle,
          axisLabelFormatter: (AxisLabelRenderDetails details) =>
              ChartAxisLabel(getAmountAsStringWithZeroDecimals(details.value), kProfitLossChartLabelTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          numberFormat: NumberFormat.currency(
              locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)),
      tooltipBehavior: TooltipBehavior(
        elevation: 10,
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipAlignment: ChartAlignment.near,
        tooltipSettings: InteractiveTooltip(
          enable: true,
          decimalPlaces: 2,
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderColor: Theme.of(context).colorScheme.onSurfaceVariant,
          borderWidth: 1,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface
          ),
        ),
      ),
      zoomPanBehavior: ZoomPanBehavior(
          // Enables pinch zooming
          enablePinching: false,
          zoomMode: ZoomMode.x,
          enablePanning: false),
      palette: <Color>[
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
        //minimum: DateTime(amountsSeries[0].date.year, 01),
        minimum: startDate,
        dateFormat: DateFormat("dd/MM/yy"),
        labelStyle: kProfitLossChartLabelTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
        intervalType: DateTimeIntervalType.months,
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.black12,
        ),
        enableAutoIntervalOnZooming: true,
      ),
      series: <ChartSeries<AmountsDataPoint, DateTime>>[
        AreaSeries<AmountsDataPoint, DateTime>(
          name: 'amounts_chart.total'.tr(),
          opacity: 0.75,
          // Bind data source
          dataSource: amountsSeries,
          xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
          yValueMapper: (AmountsDataPoint amounts, _) => amounts.totalAmount,
          gradient: gradientColors,
        ),
        LineSeries<AmountsDataPoint, DateTime>(
          name: 'amounts_chart.invested'.tr(),
          // Bind data source
          dataSource: amountsSeries,
          xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
          yValueMapper: (AmountsDataPoint amounts, _) => amounts.netAmount,
          width: 1,
        ),
      ],
    );
  }
}
