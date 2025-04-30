
import 'package:flutter/material.dart';
import 'package:indexax/models/profit_loss_datapoint.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


// Plots the profit-loss chart with the monthly returns
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class ProfitLossChart extends StatelessWidget {
  const ProfitLossChart({
    super.key,
    required this.profitLossSeries,
  });

  final ({
    Map<int, List<ProfitLossDataPoint?>> monthlySeries,
    List<ProfitLossDataPoint> annualSeries
  }) profitLossSeries;

  @override
  Widget build(BuildContext context) {
    // Text styles for the chart

    return SfCartesianChart(
        primaryXAxis: const CategoryAxis(
            crossesAt: 0,
            placeLabelsNearAxisLine: false),
        primaryYAxis: const NumericAxis(
            isVisible: false,
            ),
        series: <CartesianSeries>[
          // Initialize line series
          ColumnSeries<ChartData, String>(
              dataSource: [
                // Bind data source
                ChartData('Jan', 35),
                ChartData('Feb', -28),
                ChartData('Mar', 34),
                ChartData('Apr', -32),
                ChartData('May', 40)
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ]);
  }
}
