import 'package:flutter/material.dart';
import 'amounts_datapoint.dart';

class Account {
  final accountData;
  final double _totalAmount;
  final double _investment;
  final double _timeReturn;
  final Color _timeReturnColor;
  final double _moneyReturn;
  final Color _moneyReturnColor;
  final double _profitLoss;
  final Color _profitLossColor;
  final List<AmountsDataPoint> _amountsSeries;

  static Color _obtainColor(double variable) {
    if (variable < 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  static List<AmountsDataPoint> _createAmountsSeries (netAmountsList, totalAmountsList) {
    List<AmountsDataPoint> newAmountSeries = [];
    netAmountsList.keys.forEach((k) {
      AmountsDataPoint newPoint = AmountsDataPoint(date: double.parse(k), netAmount: netAmountsList[k].toDouble(), totalAmount: totalAmountsList[k].toDouble());
      newAmountSeries.add(newPoint);

    });
    return(newAmountSeries);
}

  Account({this.accountData})
      : _totalAmount = accountData['return']['total_amount'].toDouble(),
        //_totalAmount = new DateTime.now().second.toDouble(),
        //_totalAmount = 999999.99,
        _investment = accountData['return']['investment'].toDouble(),
        _timeReturn = accountData['return']['time_return'].toDouble(),
        _timeReturnColor = _obtainColor(accountData['return']['time_return'].toDouble()),
        _moneyReturn = accountData['return']['money_return'].toDouble(),
        _moneyReturnColor = _obtainColor(accountData['return']['money_return'].toDouble()),
        _profitLoss = accountData['return']['pl'].toDouble(),
        _profitLossColor = _obtainColor(accountData['return']['pl'].toDouble()),
        //_profitLoss = 9999.99
        _amountsSeries = _createAmountsSeries(accountData['return']['net_amounts'], accountData['return']['total_amounts']);

  double get totalAmount => _totalAmount;
  double get investment => _investment;
  double get profitLoss => _profitLoss;
  double get moneyReturn => _moneyReturn;
  double get timeReturn => _timeReturn;
  Color get moneyReturnColor => _moneyReturnColor;
  Color get timeReturnColor => _timeReturnColor;
  Color get profitLossColor => _profitLossColor;
  List<AmountsDataPoint> get amountsSeries => _amountsSeries;
}
