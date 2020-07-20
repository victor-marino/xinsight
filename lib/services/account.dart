class Account {
  final accountData;
  final double totalAmount;
  final double investment;
  final double timeReturn;
  final double moneyReturn;
  final double profitLoss;

  Account({this.accountData})
      : totalAmount = accountData['return']['total_amount'].toDouble(),
        investment = accountData['return']['investment'].toDouble(),
        timeReturn = accountData['return']['time_return'].toDouble(),
        moneyReturn = accountData['return']['money_return'].toDouble(),
        profitLoss = accountData['return']['pl'].toDouble();

  double getTotalAmount() {
    return totalAmount;
  }
}
