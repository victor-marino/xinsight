import 'package:flutter/material.dart';

class PortfolioDataPoint {
  final InstrumentType instrumentType;
  final String instrumentName;
  final String instrumentID;
  final String instrumentCompany;
  final String instrumentDescription;
  final double titles;
  final double amount;
  final double cost;
  final double profitLoss;
  final double percentage;

  PortfolioDataPoint({this.instrumentType, this.instrumentName, this.instrumentID, this.instrumentCompany, this.instrumentDescription, this.titles, this.amount, this.cost, this.profitLoss, this.percentage});
}

enum InstrumentType {
  fixed,
  equity,
  cash,
  other,
}

enum ValueType {
  amount,
  percentage,
}