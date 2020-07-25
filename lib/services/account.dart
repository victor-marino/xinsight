class Account {
  final accountData;
  final double _totalAmount;
  final double _investment;
  final double _timeReturn;
  final double _moneyReturn;
  final double _profitLoss;

  Account({this.accountData})
      : _totalAmount = accountData['return']['total_amount'].toDouble(),
        _investment = accountData['return']['investment'].toDouble(),
        _timeReturn = accountData['return']['time_return'].toDouble(),
        _moneyReturn = accountData['return']['money_return'].toDouble(),
        _profitLoss = accountData['return']['pl'].toDouble();

  double get totalAmount => _totalAmount;
  double get investment => _investment;
  double get profitLoss => _profitLoss;
  double get moneyReturn => _moneyReturn;
  double get timeReturn => _timeReturn;
}
