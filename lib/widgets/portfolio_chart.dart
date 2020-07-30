import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../tools/constants.dart';

class PortfolioChart extends StatelessWidget {
  const PortfolioChart({
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
          equityCount++;
        }
        break;

        case InstrumentType.fixed: {
          colorList.add(fixedColors[fixedCount]);
          fixedCount++;
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
      height: 230,
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
//                                          pointColorMapper:
//                                              (PortfolioDataPoint data, _) =>
//                                                  data.color,
            xValueMapper:
                (PortfolioDataPoint data, _) {
              if (data.instrumentType == InstrumentType.cash) {
                return data.instrumentType.toString().tr() +
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
            ),
          ),
        ],
      ),
    );
  }
}