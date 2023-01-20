class PerformanceDataPoint {
  // Datapoint model for the time series that tracks performance of the portfolio
  final DateTime date;
  final double bestReturn;
  final double worstReturn;
  final double expectedReturn;
  final double? realReturn;
  final double? realMonthlyReturn;

  PerformanceDataPoint({required this.date, required this.bestReturn, required this.worstReturn, required this.expectedReturn, required this.realReturn, required this.realMonthlyReturn});

}