import 'package:flutter/material.dart';
import 'amounts_datapoint.dart';
import 'portfolio_datapoint.dart';
import 'performance_datapoint.dart';

class Account {
  final accountPerformanceData;
  final accountPortfolioData;
  final double _totalAmount;
  final double _investment;
  final double _timeReturn;
  final Color _timeReturnColor;
  final double _moneyReturn;
  final Color _moneyReturnColor;
  final double _profitLoss;
  final Color _profitLossColor;
  final double _expectedReturn;
  final double _bestReturn1yr;
  final double _worstReturn1yr;
  final double _bestReturn10yr;
  final double _worstReturn10yr;
  final List<AmountsDataPoint> _amountsSeries;
  final List<PortfolioDataPoint> _portfolioData;
  final List<PerformanceDataPoint> _performanceSeries;

  static Color _obtainColor(double variable) {
    if (variable < 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  static double _doubleWithTwoDecimalPlaces(double number) {
    return (number * 100).toInt() / 100;
  }

  static List<AmountsDataPoint> _createAmountsSeries (netAmountsList, totalAmountsList) {
    List<AmountsDataPoint> newAmountSeries = [];
    netAmountsList.keys.forEach((k) {
      AmountsDataPoint newPoint = AmountsDataPoint(date: DateTime.parse(k), netAmount: netAmountsList[k].toDouble(), totalAmount: totalAmountsList[k].toDouble());
      newAmountSeries.add(newPoint);
    });
    return(newAmountSeries);
  }

  static List<PortfolioDataPoint> _createPortfolioData (portfolio, instruments) {
    List<PortfolioDataPoint> newPortfolioData = [];
    for (var instrument in instruments) {
      InstrumentType currentInstrumentType;
      double currentInstrumentPercentage = instrument['amount'] / portfolio['total_amount'];

      if (instrument['instrument']['asset_class'].contains('equity')) {
        currentInstrumentType = InstrumentType.equity;
      } else if (instrument['instrument']['asset_class'].contains('fixed')) {
        currentInstrumentType = InstrumentType.fixed;
      } else {
        currentInstrumentType = InstrumentType.other;
      }
      PortfolioDataPoint newPoint = PortfolioDataPoint(instrumentType: currentInstrumentType, instrumentName: instrument['instrument']['name'], amount: _doubleWithTwoDecimalPlaces(instrument['amount'].toDouble()), percentage: currentInstrumentPercentage);
      newPortfolioData.add(newPoint);
    }

    newPortfolioData.add(PortfolioDataPoint(instrumentType: InstrumentType.cash, instrumentName: 'cash', amount: _doubleWithTwoDecimalPlaces(portfolio['cash_amount'].toDouble()), percentage: portfolio['cash_amount'] / portfolio['total_amount']));

    return(newPortfolioData);
  }

  static List<PerformanceDataPoint> _createPerformanceSeries(performancePeriodList, bestPerformanceList, worstPerformanceList, expectedPerformanceList, realPerformanceList) {
    List<PerformanceDataPoint> newPerformanceSeries = [];
    int currentPeriod = 0;
    double currentRealReturn;
    for (var period in performancePeriodList) {
      if (currentPeriod < realPerformanceList.length) {
        currentRealReturn = (realPerformanceList[currentPeriod] - 100).toDouble();
      } else {
        currentRealReturn = null;
      }
      PerformanceDataPoint newPoint = PerformanceDataPoint(date: DateTime.parse(period), bestReturn: (bestPerformanceList[currentPeriod] - 100).toDouble(), worstReturn: (worstPerformanceList[currentPeriod] - 100).toDouble(), expectedReturn: (expectedPerformanceList[currentPeriod] - 100).toDouble(), realReturn: currentRealReturn);
      newPerformanceSeries.add(newPoint);
      currentPeriod++;
    }
    return(newPerformanceSeries);
  }

  Account({@required this.accountPerformanceData, @required this.accountPortfolioData})
      : _totalAmount = accountPerformanceData['return']['total_amount'].toDouble(),
        //_totalAmount = new DateTime.now().second.toDouble(),
        //_totalAmount = 999999.99,
        _investment = accountPerformanceData['return']['investment'].toDouble(),
        _timeReturn = accountPerformanceData['return']['time_return'].toDouble(),
        _expectedReturn = accountPerformanceData['plan_expected_return'].toDouble(),
        _bestReturn1yr = (accountPerformanceData['performance']['best_pl'][13] / 100).toDouble(),
        _worstReturn1yr = (accountPerformanceData['performance']['worst_pl'][13] / 100).toDouble(),
        _bestReturn10yr = (accountPerformanceData['performance']['best_pl'][120] / 100).toDouble(),
        _worstReturn10yr = (accountPerformanceData['performance']['worst_pl'][120] / 100).toDouble(),
        _timeReturnColor = _obtainColor(accountPerformanceData['return']['time_return'].toDouble()),
        _moneyReturn = accountPerformanceData['return']['money_return'].toDouble(),
        _moneyReturnColor = _obtainColor(accountPerformanceData['return']['money_return'].toDouble()),
        _profitLoss = accountPerformanceData['return']['pl'].toDouble(),
        _profitLossColor = _obtainColor(accountPerformanceData['return']['pl'].toDouble()),
        //_profitLoss = 9999.99
        _amountsSeries = _createAmountsSeries(accountPerformanceData['return']['net_amounts'], accountPerformanceData['return']['total_amounts']),
        _portfolioData = _createPortfolioData(accountPortfolioData['portfolio'], accountPortfolioData['comparison']),
        _performanceSeries = _createPerformanceSeries(accountPerformanceData['performance']['period'], accountPerformanceData['performance']['best_return'], accountPerformanceData['performance']['worst_return'], accountPerformanceData['performance']['expected_return'], accountPerformanceData['performance']['real']);

  double get totalAmount => _totalAmount;
  double get investment => _investment;
  double get profitLoss => _profitLoss;
  double get moneyReturn => _moneyReturn;
  double get timeReturn => _timeReturn;
  double get expectedReturn => _expectedReturn;
  double get bestReturn1yr => _bestReturn1yr;
  double get worstReturn1yr => _worstReturn1yr;
  double get bestReturn10yr => _bestReturn10yr;
  double get worstReturn10yr => _worstReturn10yr;
  Color get moneyReturnColor => _moneyReturnColor;
  Color get timeReturnColor => _timeReturnColor;
  Color get profitLossColor => _profitLossColor;
  List<AmountsDataPoint> get amountsSeries => _amountsSeries;
  List<PortfolioDataPoint> get portfolioData => _portfolioData;
  List<PerformanceDataPoint> get performanceSeries => _performanceSeries;
}
