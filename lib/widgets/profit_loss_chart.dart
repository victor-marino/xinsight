import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:indexa_dashboard/models/performance_datapoint.dart';
import 'package:indexa_dashboard/models/account.dart';

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    Key key,
    @required this.profitLossSeries,
    @required this.currentYear,
  }) : super(key: key);

  final Map<int, List<List>> profitLossSeries;
  final int currentYear;

  @override
  Widget build(BuildContext context) {

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      axes: [],
      primaryXAxis: CategoryAxis(
        //labelStyle: TextStyle(fontSize: 0),
        interval: 1,
        crossesAt: 0,
        placeLabelsNearAxisLine: false,
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        labelStyle: kProfitLossChartLabelTextStyle,
        //edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat("#0.0"),
        labelFormat: ' {value}%',
        isVisible: false,
        crossesAt: 0,
      ),
      series: <
          ChartSeries<List,
              String>>[
        // Renders column chart
        ColumnSeries<List, String>(
          spacing: 0,
          width: 0.7,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
          textStyle: kChartLabelTextStyle,
          ),
          enableTooltip: false,
          dataSource: profitLossSeries[currentYear],
          xValueMapper:
              (List month, _) =>
          month[0],
          yValueMapper:
              (List month, _) =>
    //num.parse((month[1] * 100).toStringAsFixed(1)),
              month[1],
          //borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ],
    );
  }
}