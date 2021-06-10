import 'package:flutter/material.dart';
import 'amounts_datapoint.dart';
import 'portfolio_datapoint.dart';
import 'performance_datapoint.dart';

class Account {
  final accountPerformanceData;
  final accountPortfolioData;
  final accountInfo;
  final int _selectedRisk;
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
  final bool _hasActiveRewards;
  final double _feeFreeAmount;
  final List<AmountsDataPoint> _amountsSeries;
  final List<PortfolioDataPoint> _portfolioData;
  final Map<InstrumentType, double> _portfolioDistribution;
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

  static Map<InstrumentType, double> _createPortfolioDistribution (portfolio, instruments) {
    Map<InstrumentType, double> portfolioDistribution = {};

    if (instruments.any((element) => element['instrument']['asset_class'].toString().contains('equity'))) {
      portfolioDistribution[InstrumentType.equity] = 0;
    }
    if (instruments.any((element) => element['instrument']['asset_class'].toString().contains('fixed'))) {
      portfolioDistribution[InstrumentType.fixed] = 0;
    } else {
      portfolioDistribution[InstrumentType.other] = 0;
    }

    portfolioDistribution[InstrumentType.cash] = 0;

    for (var instrument in instruments) {
      double currentInstrumentPercentage = instrument['amount'] /
          portfolio['total_amount'];

      if (instrument['instrument']['asset_class'].contains('equity')) {
        portfolioDistribution[InstrumentType.equity] += currentInstrumentPercentage;
      } else if (instrument['instrument']['asset_class'].contains('fixed')) {
        portfolioDistribution[InstrumentType.fixed] += currentInstrumentPercentage;
      } else {
        portfolioDistribution[InstrumentType.other] += currentInstrumentPercentage;
      }
    }
    portfolioDistribution[InstrumentType.cash] += portfolio['cash_amount'] / portfolio['total_amount'];
    return(portfolioDistribution);
  }

  static List<PerformanceDataPoint> _createPerformanceSeries(performancePeriodList, bestPerformanceList, worstPerformanceList, expectedPerformanceList, realPerformanceList) {
    List<PerformanceDataPoint> newPerformanceSeries = [];
    int currentPeriod = 0;
    double currentRealReturn;
    double currentRealMonthlyReturn;
    for (var period in performancePeriodList) {
      if (currentPeriod < realPerformanceList.length) {
        currentRealReturn = (realPerformanceList[currentPeriod] - 100).toDouble();
        if (currentPeriod == 0) {
          currentRealMonthlyReturn = 0.00;
        } else {
          currentRealMonthlyReturn = ((realPerformanceList[currentPeriod] - realPerformanceList[currentPeriod - 1]) / 100).toDouble();
        }
      } else {
        currentRealMonthlyReturn = null;
        currentRealReturn = null;
      }
      PerformanceDataPoint newPoint = PerformanceDataPoint(date: DateTime.parse(period), bestReturn: (bestPerformanceList[currentPeriod] - 100).toDouble(), worstReturn: (worstPerformanceList[currentPeriod] - 100).toDouble(), expectedReturn: (expectedPerformanceList[currentPeriod] - 100).toDouble(), realReturn: currentRealReturn, realMonthlyReturn: currentRealMonthlyReturn);
      newPerformanceSeries.add(newPoint);
      currentPeriod++;
    }
    return(newPerformanceSeries);
  }

  Account({@required this.accountInfo, @required this.accountPerformanceData, @required this.accountPortfolioData})
      : _selectedRisk = accountInfo['profile']['selected_risk'],
        _totalAmount = accountPerformanceData['return']['total_amount'].toDouble(),
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
        _hasActiveRewards = accountInfo['has_active_rewards'],
        _feeFreeAmount = accountInfo['fee_free_amount'].toDouble(),
        _amountsSeries = _createAmountsSeries(accountPerformanceData['return']['net_amounts'], accountPerformanceData['return']['total_amounts']),
        _portfolioData = _createPortfolioData(accountPortfolioData['portfolio'], accountPortfolioData['comparison']),
        _portfolioDistribution = _createPortfolioDistribution(accountPortfolioData['portfolio'], accountPortfolioData['comparison']),
        _performanceSeries = _createPerformanceSeries(accountPerformanceData['performance']['period'], accountPerformanceData['performance']['best_return'], accountPerformanceData['performance']['worst_return'], accountPerformanceData['performance']['expected_return'], accountPerformanceData['performance']['real']);

  int get selectedRisk => _selectedRisk;
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
  bool get hasActiveRewards => _hasActiveRewards;
  double get feeFreeAmount => _feeFreeAmount;
  List<AmountsDataPoint> get amountsSeries => _amountsSeries;
  List<PortfolioDataPoint> get portfolioData => _portfolioData;
  Map<InstrumentType, double> get portfolioDistribution => _portfolioDistribution;
  List<PerformanceDataPoint> get performanceSeries => _performanceSeries;
}
