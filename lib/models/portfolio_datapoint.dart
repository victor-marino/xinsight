import 'package:flutter/material.dart';

class PortfolioDataPoint {
  final InstrumentType instrumentType;
  final String instrumentName;
  final String instrumentID;
  final String instrumentCompany;
  final String instrumentDescription;
  final double amount;
  final double percentage;

  PortfolioDataPoint({this.instrumentType, this.instrumentName, this.instrumentID, this.instrumentCompany, this.instrumentDescription, this.amount, this.percentage});
}

enum InstrumentType {
  fixed,
  equity,
  cash,
  other,
}