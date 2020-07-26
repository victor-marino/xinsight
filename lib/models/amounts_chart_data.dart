import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'amounts_datapoint.dart';

LineChartData amountsChartData(List<AmountsDataPoint> amountsSeries) {
  List<FlSpot> netAmountsSeries = [];
  List<FlSpot> totalAmountsSeries = [];

  for (AmountsDataPoint dataPoint in amountsSeries) {
    netAmountsSeries.add(FlSpot(dataPoint.date, dataPoint.netAmount));
    totalAmountsSeries.add(FlSpot(dataPoint.date, dataPoint.totalAmount));
  }

  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {},
      handleBuiltInTouches: true,
    ),
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        textStyle: const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
//        getTitles: (value) {
//          switch (value.toInt()) {
//            case 2:
//              return 'SEPT';
//            case 7:
//              return 'OCT';
//            case 12:
//              return 'DEC';
//          }
//          return '';
//        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
//        getTitles: (value) {
//          switch (value.toInt()) {
//            case 1:
//              return '1m';
//            case 2:
//              return '2m';
//            case 3:
//              return '3m';
//            case 4:
//              return '5m';
//          }
//          return '';
//        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(
          color: Color(0xff4e4965),
          width: 1,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
//    minX: 0,
//    maxX: 14,
//    maxY: 4,
//    minY: 0,
    lineBarsData: linesBarData(netAmountsSeries, totalAmountsSeries),
  );
}

List<LineChartBarData> linesBarData(List<FlSpot> netAmountsSeries, List<FlSpot> totalAmountsSeries) {
  final LineChartBarData lineChartBarData1 = LineChartBarData(
    spots: netAmountsSeries,
    isCurved: false,
    colors: [
      const Color(0xff4af699),
    ],
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData lineChartBarData2 = LineChartBarData(
    spots: totalAmountsSeries,
    isCurved: false,
    colors: [
      const Color(0xffaa4cfc),
    ],
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: false, colors: [
      const Color(0x00aa4cfc),
    ]),
  );

  return [
    lineChartBarData1,
    lineChartBarData2,
  ];
}