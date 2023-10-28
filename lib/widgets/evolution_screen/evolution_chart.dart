import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/amounts_datapoint.dart';
import 'package:indexax/models/returns_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/tools/evolution_chart_provider.dart';
import 'package:indexax/models/chart_series_type.dart';

// Draws the evolution chart
// It plots the amounts (€) or the returns (%) based on the 'seriesType' variable of the provider

class EvolutionChart extends StatelessWidget {
  const EvolutionChart({
    Key? key,
    required this.amountsSeries,
    required this.returnsSeries,
  }) : super(key: key);

  final List<AmountsDataPoint> amountsSeries;
  final List<ReturnsDataPoint> returnsSeries;

  @override
  Widget build(BuildContext context) {
    DateTime? firstDate = context.watch<EvolutionChartProvider>().firstDate;
    DateTime? lastDate = context.watch<EvolutionChartProvider>().lastDate;
    DateTime? startDate = context.watch<EvolutionChartProvider>().startDate;
    DateTime? endDate = context.watch<EvolutionChartProvider>().endDate;
    ChartSeriesType seriesType =
        context.watch<EvolutionChartProvider>().seriesType;

    TextStyle axisTextStyle = text_styles.roboto(context, 10);

    // Color gradient for the area chart
    final List<Color> color = <Color>[
      Colors.blue.withOpacity(0),
      Colors.blue.withOpacity(0.7)
    ];
    final List<double> stops = <double>[0, 1];
    final LinearGradient gradientColors = LinearGradient(
        transform: const GradientRotation(pi * 1.5),
        colors: color,
        stops: stops);

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      primaryYAxis: seriesType == ChartSeriesType.returns
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
                      getAmountAsStringWithZeroDecimals(details.value,
                          maskValue: context
                              .watch<PrivateModeProvider>()
                              .privateModeEnabled),
                      axisTextStyle),
              numberFormat: NumberFormat.currency(
                  locale: getCurrentLocale(), symbol: '€', decimalDigits: 2),
            ),
      tooltipBehavior: TooltipBehavior(
        elevation: 10,
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.longPress,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        tooltipAlignment: ChartAlignment.far,
        tooltipSettings: InteractiveTooltip(
            enable: true,
            decimalPlaces: 2,
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderColor: Theme.of(context).colorScheme.outline,
            borderWidth: 1,
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface),
            format: seriesType == ChartSeriesType.returns
                ? 'series.name: point.y%'
                : context.watch<PrivateModeProvider>().privateModeEnabled
                    ? 'series.name: ${getAmountAsStringWithZeroDecimals(100, maskValue: true)}'
                    : 'series.name: point.y'),
      ),
      zoomPanBehavior: ZoomPanBehavior(
          enablePinching: false, zoomMode: ZoomMode.x, enablePanning: true),
      onActualRangeChanged: (newVisibleCoordinates) {
        context.read<EvolutionChartProvider>().startDate =
            DateTime.fromMillisecondsSinceEpoch(
                newVisibleCoordinates.visibleMin.toInt());
        context.read<EvolutionChartProvider>().endDate =
            DateTime.fromMillisecondsSinceEpoch(
                newVisibleCoordinates.visibleMax.toInt());
        // context.read<EvolutionChartProvider>().updateRangeSelectorText(context);
      },
      // onChartTouchInteractionUp: (tapArgs) {
      //   context.read<EvolutionChartProvider>().updateRangeSelectorText(context);
      // },
      palette: const <Color>[
        Colors.blue,
        Colors.black,
      ],
      legend: const Legend(
          isVisible: true,
          position: LegendPosition.top,
          padding: 4,
          itemPadding: 10),
      primaryXAxis: DateTimeAxis(
        minimum: firstDate,
        maximum: lastDate,
        visibleMinimum: startDate,
        visibleMaximum: endDate,
        dateFormat: DateFormat("dd/MM/yy"),
        labelStyle: axisTextStyle,
        intervalType: DateTimeIntervalType.months,
        majorGridLines: const MajorGridLines(
          width: 1,
          color: Colors.black12,
        ),
        enableAutoIntervalOnZooming: true,
      ),
      series: seriesType == ChartSeriesType.returns
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
