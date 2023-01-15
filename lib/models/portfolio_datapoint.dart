class PortfolioDataPoint {
  // Datapoint model for the list containing all portfolio assets
  final InstrumentType instrumentType;
  final String instrumentName;
  final String? instrumentCodeType;
  final String? instrumentCode;
  final String? instrumentCompany;
  final String? instrumentDescription;
  final double? titles;
  final double amount;
  final double? cost;
  final double? profitLoss;
  final double percentage;

  PortfolioDataPoint({required this.instrumentType, required this.instrumentName, this.instrumentCodeType, this.instrumentCode, this.instrumentCompany, this.instrumentDescription, this.titles, required this.amount, this.cost, this.profitLoss, required this.percentage});

  @override
  String toString() {
    // Override toString() method for easier printing and troubleshooting
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