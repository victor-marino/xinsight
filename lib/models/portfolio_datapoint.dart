class PortfolioDataPoint {
  // Datapoint model for the list containing all portfolio assets
  final InstrumentType instrumentType;
  final String instrumentName;
  final String? instrumentCodeType,
      instrumentCode,
      instrumentCompany,
      instrumentDescription;
  final double amount, percentage;
  final double? titles, cost, profitLoss;

  PortfolioDataPoint(
      {required this.instrumentType,
      required this.instrumentName,
      this.instrumentCodeType,
      this.instrumentCode,
      this.instrumentCompany,
      this.instrumentDescription,
      this.titles,
      required this.amount,
      this.cost,
      this.profitLoss,
      required this.percentage});
}

enum InstrumentType {
  fixed,
  equity,
  moneymarket,
  cash,
  other,
}

enum ValueType {
  amount,
  percentage,
}
