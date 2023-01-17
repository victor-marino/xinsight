import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../tools/text_styles.dart';

// Plots the chart showing the portfolio distribution in overview screen

class DistributionChart extends StatelessWidget {
  const DistributionChart({
    Key? key,
    required this.portfolioData,
  }) : super(key: key);
  final List<PortfolioDataPoint> portfolioData;

  @override
  Widget build(BuildContext context) {
    int equityCount = 0;
    int fixedCount = 0;
    List<Color> colorList = [];

    for (var element in portfolioData) {
      switch (element.instrumentType) {
        case InstrumentType.equity:
          {
            colorList.add(equityColors[equityCount] ?? Colors.purple);
            if (equityCount < equityColors.length - 1) {
              equityCount++;
            } else {
              equityCount = 0;
            }
          }
          break;

        case InstrumentType.fixed:
          {
            colorList.add(fixedColors[fixedCount] ?? Colors.blue);
            if (fixedCount < fixedColors.length - 1) {
              fixedCount++;
            } else {
              fixedCount = 0;
            }
          }
          break;

        case InstrumentType.cash:
          {
            colorList.add(cashColor);
          }
          break;

        case InstrumentType.other:
          {
            colorList.add(otherColor);
          }
          break;

        default:
          {
            colorList.add(otherColor);
          }
          break;
      }
    }
    return SfCircularChart(
      palette: colorList,
      tooltipBehavior: TooltipBehavior(
          enable: true,
          decimalPlaces: 2,
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderColor: Theme.of(context).colorScheme.outline,
          borderWidth: 1,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(point.x + "\n" + getInvestmentAsString(point.y),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: roboto12.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
            );
          }),
      series: <CircularSeries>[
        DoughnutSeries<PortfolioDataPoint, String>(
          dataSource: portfolioData,
          xValueMapper: (PortfolioDataPoint data, _) {
            if (data.instrumentType == InstrumentType.equity) {
              return data.instrumentName +
                  '\n' +
                  'distribution_chart.instrument_type_equity'.tr() +
                  '\n(' +
                  getPercentAsString(data.percentage) +
                  ')';
            } else if (data.instrumentType == InstrumentType.fixed) {
              return data.instrumentName +
                  '\n' +
                  'distribution_chart.instrument_type_fixed'.tr() +
                  '\n(' +
                  getPercentAsString(data.percentage) +
                  ')';
            } else if (data.instrumentType == InstrumentType.cash) {
              return 'distribution_chart.instrument_type_cash'.tr() +
                  '\n(' +
                  getPercentAsString(data.percentage) +
                  ')';
            } else if (data.instrumentType == InstrumentType.other) {
              return 'distribution_chart.instrument_type_other'.tr() +
                  '\n(' +
                  getPercentAsString(data.percentage) +
                  ')';
            } else {
              return data.instrumentType.toString().tr() +
                  '\n' +
                  data.instrumentName +
                  '\n(' +
                  getPercentAsString(data.percentage) +
                  ')';
            }
          },
          yValueMapper: (PortfolioDataPoint data, _) => data.amount,
        ),
      ],
    );
  }
}
