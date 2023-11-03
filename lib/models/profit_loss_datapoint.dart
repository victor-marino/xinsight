import 'package:flutter/material.dart';

class ProfitLossDataPoint {
  // Datapoint model for profit-loss series
  // The color is calculated when the datapoint is instantiated
  ProfitLossDataPoint(
      {required this.periodName,
      required this.percentReturn,
      required this.cashReturn})
      : color = cashReturn != null
            ? cashReturn > 0
                ? Colors.green[500]
                : Colors.red[900]
            : null;

  final String? periodName;
  final double? percentReturn, cashReturn;
  final Color? color;
}
