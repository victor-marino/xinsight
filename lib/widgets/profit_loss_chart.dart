import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:indexa_dashboard/models/performance_datapoint.dart';
import 'package:indexa_dashboard/models/account.dart';

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    Key key,
    @required this.performanceSeries,
  }) : super(key: key);

  final List<PerformanceDataPoint> performanceSeries;

  @override
  Widget build(BuildContext context) {
    List<PerformanceDataPoint> profitLossSeries = [];
    int lastElement = performanceSeries.lastIndexWhere((element) => element.realMonthlyReturn != null);
    profitLossSeries = performanceSeries.sublist(0, lastElement);
    List<int> years = [];

    profitLossSeries.forEach((element) {
      years.add(element.date.year);
    });

    years = years.toSet().toList();
    years.sort();

    //var profitLossYearSeries = {};

    Map<int, List<PerformanceDataPoint>> profitLossYearSeries = {};

    years.forEach((year) {
      profitLossYearSeries[year] = [];
    });

    profitLossSeries.forEach((element) {
      profitLossYearSeries[element.date.year].add(element) as PerformanceDataPoint;
    }
    );

    print(profitLossYearSeries[2020][7].realMonthlyReturn);

    return SfCartesianChart(
      axes: [],
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.months,
        minimum: DateTime(profitLossYearSeries[2020][0].date.year, 1),
        maximum: DateTime(profitLossYearSeries[2020][0].date.year, 12),
        dateFormat: DateFormat.MMM(),
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
          ChartSeries<PerformanceDataPoint,
              DateTime>>[
        // Renders column chart
        ColumnSeries<PerformanceDataPoint, DateTime>(
          dataSource: profitLossYearSeries[2020],
          xValueMapper:
              (PerformanceDataPoint performance, _) =>
          performance.date,
          yValueMapper:
              (PerformanceDataPoint performance, _) =>
          performance.realMonthlyReturn,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ],
    );
  }
}