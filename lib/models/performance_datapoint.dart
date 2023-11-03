class PerformanceDataPoint {
  // Datapoint model for the time series that tracks performance of the portfolio
  final DateTime date;
  final double bestReturn, worstReturn, expectedReturn;
  final double? realReturn, realMonthlyReturn;

  PerformanceDataPoint(
      {required this.date,
      required this.bestReturn,
      required this.worstReturn,
      required this.expectedReturn,
      required this.realReturn,
      required this.realMonthlyReturn});
}
