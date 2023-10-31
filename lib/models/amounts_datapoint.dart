class AmountsDataPoint {
  // Datapoint model for the time series that tracks the value of the portfolio
  final DateTime date;
  final double netAmount;
  final double totalAmount;

  AmountsDataPoint({required this.date, required this.netAmount, required this.totalAmount});
}