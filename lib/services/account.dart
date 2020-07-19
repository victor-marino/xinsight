class Account {
  final accountData;
  final totalAmount;
  final investment;
  final timeReturn;
  final moneyReturn;

  Account({this.accountData})
      : totalAmount = accountData['return']['total_amount'],
        investment = accountData['return']['investment'],
        timeReturn = accountData['return']['time_return'],
        moneyReturn = accountData['return']['money_return'];

  double getTotalAmount() {
    return totalAmount;
  }
}
