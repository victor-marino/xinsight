import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/constants.dart';

class DistributionChartSimplified extends StatelessWidget {
  const DistributionChartSimplified({
    Key? key,
    required this.portfolioDistribution,
  }) : super(key: key);
  final Map<InstrumentType, Map<ValueType, double>> portfolioDistribution;

  @override
  Widget build(BuildContext context) {
    final List<Color> colorList = [equityColors[2]!, fixedColors[2]!, cashColor, otherColor];

    return Container(
      height: 280,
      child: SfCircularChart(
        palette: colorList,
        tooltipBehavior: TooltipBehavior(
          enable: true,
          decimalPlaces: 2,
          format: 'point.x' + '\npoint.y €',
        ),
        series: <CircularSeries>[
          // Renders doughnut chart
          DoughnutSeries<InstrumentType, String>(
            dataSource: portfolioDistribution.keys.toList(),
            xValueMapper:
                (InstrumentType currentInstrumentType, _) {
              if (currentInstrumentType == InstrumentType.equity) {
                return 'distribution_chart.instrument_type_equity'.tr() +
                    '\n(' +
                    (portfolioDistribution[currentInstrumentType]![ValueType.percentage]! * 100)
                        .toStringAsFixed(1) +
                    '%)';
                } else if (currentInstrumentType == InstrumentType.fixed) {
                return 'distribution_chart.instrument_type_fixed'.tr() +
                    '\n(' +
                    (portfolioDistribution[currentInstrumentType]![ValueType.percentage]! * 100)
                        .toStringAsFixed(1) +
                    '%)';
              } else if (currentInstrumentType == InstrumentType.cash) {
                return 'distribution_chart.instrument_type_cash'.tr() +
                    '\n(' +
                    (portfolioDistribution[currentInstrumentType]![ValueType.percentage]! * 100)
                        .toStringAsFixed(1) +
                    '%)';
              } else {
                return 'distribution_chart.instrument_type_other'.tr() +
                    '\n(' +
                    (portfolioDistribution[currentInstrumentType]![ValueType.percentage]! * 100)
                        .toStringAsFixed(1) +
                    '%)';
              }
            },
            yValueMapper:
                (InstrumentType currentInstrumentType,
                _) =>
            double.parse(portfolioDistribution[currentInstrumentType]![ValueType.amount]!.toStringAsFixed(2)),
            dataLabelSettings:
            DataLabelSettings(
              margin: EdgeInsets.all(0),
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 10,
              ),
              borderWidth: 0,
              labelPosition:
              ChartDataLabelPosition
                  .outside,
              connectorLineSettings:
              ConnectorLineSettings(
                // Type of the connector line
                  type:
                  ConnectorType.line),
              labelIntersectAction: LabelIntersectAction.none,
            ),
          ),
        ],
      ),
    );
  }
}