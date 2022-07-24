class PortfolioDataPoint {
  final InstrumentType? instrumentType;
  final String? instrumentName;
  final String? instrumentCodeType;
  final String? instrumentCode;
  final String? instrumentCompany;
  final String? instrumentDescription;
  final double? titles;
  final double? amount;
  final double? cost;
  final double? profitLoss;
  final double? percentage;

  PortfolioDataPoint({this.instrumentType, this.instrumentName, this.instrumentCodeType, this.instrumentCode, this.instrumentCompany, this.instrumentDescription, this.titles, this.amount, this.cost, this.profitLoss, this.percentage});

  @override
  String toString() {
    return instrumentType.toString() + ", " + instrumentName.toString() + ", " + instrumentCodeType.toString() + ", " + instrumentCode.toString() + ", " + instrumentCompany.toString() + ", " + instrumentDescription.toString() + ", " + titles.toString() + ", " + amount.toString() + ", " + cost.toString() + ", " + profitLoss.toString() + ", " + percentage.toString();
  }
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