import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../tools/constants.dart';

class DistributionChart extends StatelessWidget {
  const DistributionChart({
    Key key,
    @required this.portfolioData,
  }) : super(key: key);
  final List<PortfolioDataPoint> portfolioData;

  @override
  Widget build(BuildContext context) {
    int equityCount = 0;
    int fixedCount = 0;
    List<Color> colorList = [];

    for (var element in portfolioData) {
      switch(element.instrumentType) {
        case InstrumentType.equity: {
          colorList.add(equityColors[equityCount]);
          if (equityCount < equityColors.length-1) {
            equityCount++;
          } else {
            equityCount=0;
          }
        }
        break;

        case InstrumentType.fixed: {
          colorList.add(fixedColors[fixedCount]);
          if (fixedCount < fixedColors.length-1) {
            fixedCount++;
          } else {
            fixedCount=0;
          }
        }
        break;

        case InstrumentType.cash: {
          colorList.add(cashColor);
        }
        break;

        case InstrumentType.other: {
          colorList.add(otherColor);
        }
        break;

        default: {
          colorList.add(otherColor);
        }
        break;
      }
    }
    return Container(
      height: 280,
      child: SfCircularChart(
        palette: colorList,
        //backgroundColor: Colors.blueGrey,
        tooltipBehavior: TooltipBehavior(
          enable: true,
          decimalPlaces: 2,
          format: 'point.x' + '\npoint.y €',
        ),
        series: <CircularSeries>[
          // Renders doughnut chart
          DoughnutSeries<PortfolioDataPoint,
              String>(
            dataSource: portfolioData,
            xValueMapper:
                (PortfolioDataPoint data, _) {
              if (data.instrumentType == InstrumentType.equity) {
                return data.instrumentName + '\n' + 'distribution_chart.instrument_type_equity'.tr() +
                    '\n(' +
                    (data.percentage * 100)
                        .toStringAsFixed(1) +
                    '%)';
                } else if (data.instrumentType == InstrumentType.fixed) {
                return data.instrumentName + '\n' + 'distribution_chart.instrument_type_fixed'.tr() +
                    '\n(' +
                    (data.percentage * 100)
                        .toStringAsFixed(1) +
                    '%)';
              } else if (data.instrumentType == InstrumentType.cash) {
                return 'distribution_chart.instrument_type_cash'.tr() +
                    '\n(' +
                    (data.percentage * 100)
                        .toStringAsFixed(1) +
                    '%)';
              } else if (data.instrumentType == InstrumentType.other) {
                return 'distribution_chart.instrument_type_other'.tr() +
                    '\n(' +
                    (data.percentage * 100)
                        .toStringAsFixed(1) +
                    '%)';
              } else {
                return data.instrumentType.toString().tr() +
                    '\n' +
                    data.instrumentName +
                    '\n(' +
                    (data.percentage * 100)
                        .toStringAsFixed(1) +
                    '%)';
              }
            },
            yValueMapper:
                (PortfolioDataPoint data,
                _) =>
            data.amount,
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