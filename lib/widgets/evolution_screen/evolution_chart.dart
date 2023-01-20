import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/amounts_datapoint.dart';
import 'package:indexax/models/returns_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:syncfusion_flutter_charts/charts.dart';

// Draws the evolution chart.
// If showReturns=true, it plots the returns (%). Otherwise it plots the amounts (€)

class EvolutionChart extends StatelessWidget {
  const EvolutionChart({
    Key? key,
    required this.amountsSeries,
    required this.returnsSeries,
    required this.period,
    required this.showReturns,
  }) : super(key: key);

  final List<AmountsDataPoint> amountsSeries;
  final List<ReturnsDataPoint> returnsSeries;
  final Duration period;
  final bool showReturns;

  @override
  Widget build(BuildContext context) {
    DateTime? startDate;
    TextStyle axisTextStyle = text_styles.roboto(context, 10);

    // If a period of 0 is passed, we plot the full history.
    if (period == const Duration(seconds: 0)) {
      startDate = amountsSeries[0].date;
    } else if (amountsSeries.last.date
        .subtract(period)
        .isBefore(amountsSeries[0].date)) {
      startDate = amountsSeries[0].date;
    } else {
      startDate = amountsSeries.last.date.subtract(period);
    }

    // Color gradient for the area chart
    final List<Color> color = <Color>[
      Colors.blue.withOpacity(0),
      Colors.blue.withOpacity(0.7)
    ];
    final List<double> stops = <double>[0, 1];
    final LinearGradient gradientColors = LinearGradient(
        transform: const GradientRotation(pi * 1.5), colors: color, stops: stops);

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      primaryYAxis: showReturns
          ? NumericAxis(
              axisLabelFormatter: (AxisLabelRenderDetails details) =>
                  ChartAxisLabel(
                      getWholePercentWithPercentSignAsString(
                          details.value / 100),
                      axisTextStyle),
            )
          : NumericAxis(
              axisLabelFormatter: (AxisLabelRenderDetails details) =>
                  ChartAxisLabel(
                      getAmountAsStringWithZeroDecimals(details.value),
                      axisTextStyle),
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
          borderColor: Theme.of(context).colorScheme.outline,
          borderWidth: 1,
          textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      zoomPanBehavior: ZoomPanBehavior(
          enablePinching: false, zoomMode: ZoomMode.x, enablePanning: false),
      palette: const <Color>[
        Colors.blue,
        Colors.black,
      ],
      legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
          padding: 4,
          itemPadding: 10),
      primaryXAxis: DateTimeAxis(
        minimum: startDate,
        dateFormat: DateFormat("dd/MM/yy"),
        labelStyle:
            axisTextStyle,
        intervalType: DateTimeIntervalType.months,
        majorGridLines: const MajorGridLines(
          width: 1,
          color: Colors.black12,
        ),
        enableAutoIntervalOnZooming: true,
      ),
      series: showReturns
          ? <ChartSeries<ReturnsDataPoint, DateTime>>[
              AreaSeries<ReturnsDataPoint, DateTime>(
                name: 'evolution_chart.return'.tr(),
                opacity: 1,
                borderColor: Colors.lightBlue,
                borderWidth: 2,
                dataSource: returnsSeries,
                xValueMapper: (ReturnsDataPoint performance, _) =>
                    performance.date,
                yValueMapper: (ReturnsDataPoint performance, _) =>
                    performance.totalReturn,
                gradient: gradientColors,
              ),
            ]
          : <ChartSeries<AmountsDataPoint, DateTime>>[
              AreaSeries<AmountsDataPoint, DateTime>(
                name: 'evolution_chart.total'.tr(),
                opacity: 1,
                borderColor: Colors.lightBlue,
                borderWidth: 2,
                dataSource: amountsSeries,
                xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
                yValueMapper: (AmountsDataPoint amounts, _) =>
                    amounts.totalAmount,
                gradient: gradientColors,
              ),
              LineSeries<AmountsDataPoint, DateTime>(
                name: 'evolution_chart.invested'.tr(),
                color: Theme.of(context).colorScheme.outline,
                markerSettings: const MarkerSettings(
                  isVisible: false,
                ),
                dataSource: amountsSeries,
                xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
                yValueMapper: (AmountsDataPoint amounts, _) =>
                    amounts.netAmount,
                width: 2,
              ),
            ],
    );
  }
}
