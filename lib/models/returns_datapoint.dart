class ReturnsDataPoint {
  // Datapoint model for the time series that tracks the portfolio returns
  final DateTime date;
  final double totalReturn;

  ReturnsDataPoint({required this.date, required this.totalReturn});
}