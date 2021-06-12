import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:indexa_dashboard/models/performance_datapoint.dart';
import 'package:indexa_dashboard/models/account.dart';

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    Key key,
    @required this.profitLossSeries,
  }) : super(key: key);

  final Map<int, List<List>> profitLossSeries;

  @override
  Widget build(BuildContext context) {
    List<String> monthList = ["E", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", "Σ"];

    return SfCartesianChart(
      axes: [],
      primaryXAxis: CategoryAxis(
        interval: 1,
        crossesAt: 0,
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        //edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        crossesAt: 0,
      ),
      series: <
          ChartSeries<List<List<dynamic>>,
              String>>[
        // Renders column chart
        ColumnSeries<List<List<double>>, String>(
          dataSource: profitLossSeries[2020],
          xValueMapper:
              (List datapoint, _) =>
          datapoint[0],
          yValueMapper:
              (List datapoint, _) =>
          datapoint[1],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ],
    );
  }
}