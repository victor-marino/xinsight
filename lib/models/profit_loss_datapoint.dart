import 'package:flutter/material.dart';

class ProfitLossDataPoint {
  // Datapoint model for profit-loss series
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
  final double? percentReturn;
  final double? cashReturn;
  final Color? color;
}
