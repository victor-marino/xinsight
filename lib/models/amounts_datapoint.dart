class AmountsDataPoint {
  final DateTime date;
  final double netAmount;
  final double totalAmount;

  AmountsDataPoint({this.date, this.netAmount, this.totalAmount});

  @override
  String toString() {
    return date.toString() + ", " + netAmount.toString() + ", " + totalAmount.toString();
  }
}