class ReturnsDataPoint {
  final DateTime? date;
  final double? totalReturn;

  ReturnsDataPoint({this.date, this.totalReturn});

  @override
  String toString() {
    return date.toString() + ", " + totalReturn.toString();
  }
}