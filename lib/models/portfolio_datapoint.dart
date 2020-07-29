import 'package:flutter/material.dart';

class PortfolioDataPoint {
  final InstrumentType instrumentType;
  final String instrumentName;
  final double amount;
  final double percentage;

  PortfolioDataPoint({this.instrumentType, this.instrumentName, this.amount, this.percentage});
}

enum InstrumentType {
  fixed,
  equity,
  cash,
  other,
}