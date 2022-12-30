class ReturnsDataPoint {
  // Datapoint model for the time series that tracks the portfolio returns
  final DateTime? date;
  final double? totalReturn;

  ReturnsDataPoint({this.date, this.totalReturn});

  @override
  String toString() {
    // Override toString() method for easier printing and troubleshooting
    return date.toString() + ", " + totalReturn.toString();
  }
}