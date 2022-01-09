import 'package:flutter/material.dart';
import 'amounts_datapoint.dart';
import 'portfolio_datapoint.dart';
import 'performance_datapoint.dart';
import 'transaction.dart';
import 'package:easy_localization/easy_localization.dart';

class Account {
  final accountPerformanceData;
  final accountPortfolioData;
  final accountInfo;
  final accountInstrumentTransactionData;
  final accountCashTransactionData;
  final accountPendingTransactionData;
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
  final bool _hasPendingTransactions;
  final double _feeFreeAmount;
  final double _additionalCashNeededToTrade;
  final List<AmountsDataPoint> _amountsSeries;
  final List<PortfolioDataPoint> _portfolioData;
  final Map<InstrumentType, double> _portfolioDistribution;
  final List<PerformanceDataPoint> _performanceSeries;
  final Map<int, List<List>> _profitLossSeries;
  final List<Transaction> _transactionList;

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
      String currentInstrumentDescription;

      if (instrument['instrument']['asset_class'].contains('equity')) {
        currentInstrumentType = InstrumentType.equity;
      } else if (instrument['instrument']['asset_class'].contains('fixed')) {
        currentInstrumentType = InstrumentType.fixed;
      } else {
        currentInstrumentType = InstrumentType.other;
      }

      if (instrument['instrument']['description'] == "") {
        currentInstrumentDescription = 'asset_details_popup.description_not_available'.tr();
      } else if (instrument['instrument']['description'].contains(' Código ISIN')) {
        currentInstrumentDescription = instrument['instrument']['description'].split(' Código ISIN')[0];
      } else {
        currentInstrumentDescription = instrument['instrument']['description'];
      }

      PortfolioDataPoint newPoint = PortfolioDataPoint(instrumentType: currentInstrumentType, instrumentName: instrument['instrument']['name'], instrumentID: instrument['instrument']['identifier'], instrumentCompany: instrument['instrument']['management_company_description'], instrumentDescription: currentInstrumentDescription, amount: _doubleWithTwoDecimalPlaces(instrument['amount'].toDouble()), percentage: currentInstrumentPercentage);
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

  static Map<int, List<List>> _createProfitLossSeries(performancePeriodList, realPerformanceList) {
    Map<int, List<List>> profitLossSeries = {};
    List<String> monthList = ['months_short.january'.tr(), 'months_short.february'.tr(), 'months_short.march'.tr(), 'months_short.april'.tr(), 'months_short.may'.tr(), 'months_short.june'.tr(), 'months_short.july'.tr(), 'months_short.august'.tr(), 'months_short.september'.tr(), 'months_short.october'.tr(), 'months_short.november'.tr(), 'months_short.december'.tr(), "YTD"];

    performancePeriodList = performancePeriodList.sublist(0, realPerformanceList.length);

    for (int i=realPerformanceList.length-1; i>0; i--) {
      realPerformanceList[i] = (realPerformanceList[i] / realPerformanceList[i-1]) - 1;
    }
    realPerformanceList[0] = 0.0;

    List<int> years = [];
    performancePeriodList.forEach((element) {
      years.add(DateTime.parse(element).year);
    });

    years = years.toSet().toList();

    years.forEach((year) {
      profitLossSeries.putIfAbsent(year, () => []);
      profitLossSeries[year] = List<List>.generate(13, (index) => ["", null]);
      profitLossSeries[year].asMap().forEach((index, value) {
        profitLossSeries[year][index][0] = monthList[index];
      });
    });

    for (int i=0; i<realPerformanceList.length; i++) {
      profitLossSeries[DateTime
          .parse(performancePeriodList[i]).year][DateTime
          .parse(performancePeriodList[i]).month - 1][1] = realPerformanceList[i].toDouble();
    }

    years.forEach((year) {
      double totalProfit = 1;
      for (int i = 0; i<profitLossSeries[year].length-1; i++) {
        if (profitLossSeries[year][i][1] != null) {
          totalProfit *= (profitLossSeries[year][i][1]) + 1;
        }
      }
      profitLossSeries[year][12][1] = totalProfit - 1;
    });

    years.forEach((year) {
      for (int i = 0; i<profitLossSeries[year].length; i++) {
        if (profitLossSeries[year][i][1] != null) {
          profitLossSeries[year][i][1] = num.parse((profitLossSeries[year][i][1] * 100).toStringAsFixed(1));
        }
      }
    });

    return(profitLossSeries);

  }

  static List<Transaction> _createTransactionList(accountInstrumentTransactionData, accountCashTransactionData) {
    List<Transaction> newTransactionList = [];
    for (var transaction in accountInstrumentTransactionData) {
      String operationType;
      IconData icon;
      switch(transaction['operation_code']) {
        case 20: {
          operationType = 'transaction_info.fund_purchase'.tr();
          icon = Icons.trending_up;
        }
        break;

        case 21: {
          operationType = 'transaction_info.fund_reimbursement'.tr();
          icon = Icons.trending_down;
        }
        break;

        case 67: {
          operationType = 'transaction_info.fund_purchase_by_transfer'.tr();
          icon = Icons.sync_alt;
        }
        break;

        case 72: {
          operationType = 'transaction_info.fund_reimbursement_by_transfer'.tr();
          icon = Icons.sync_alt;
        }
        break;

        default: {
          operationType = transaction['operation_type'];
          icon = Icons.help_outline;
        }
        break;
      }

      String operationStatus;
      switch(transaction['status']) {
        case 'closed': {
          operationStatus = 'transaction_info.completed'.tr();
        }
        break;

        default: {
          operationStatus = transaction['status'];
        }
        break;
      }
      Transaction newTransaction = Transaction(date: DateTime.parse(transaction['date']), valueDate: DateTime.parse(transaction['value_date']), fiscalDate: DateTime.parse(transaction['fiscal_date']), accountType: 'transaction_info.securities_account'.tr(), operationCode: transaction['operation_code'], operationType: operationType, icon: icon, instrumentCode: transaction['instrument']['identifier'], instrumentName: transaction['instrument']['name'], titles: transaction['titles'].toDouble(), price: transaction['price'].toDouble(), amount: transaction['amount'].toDouble(), status: operationStatus);
      newTransactionList.add(newTransaction);
    }

    for (var transaction in accountCashTransactionData) {
      String operationType;
      IconData icon;
      switch(transaction['operation_code']) {
        case 9200: {
          operationType = 'transaction_info.securities_operation'.tr();
          icon = Icons.pie_chart;
        }
        break;

        case 285: {
          operationType = 'transaction_info.custodial_fee'.tr();
          icon = Icons.toll;
        }
        break;

        case 4589: {
          operationType = "transaction_info.money_deposit_by_transfer".tr();
          icon = Icons.download_outlined;
        }
        break;

        case 4597: {
          operationType = "transaction_info.money_reimbursement_by_transfer".tr();
          icon = Icons.upload_outlined;
        }
        break;

        default: {
          operationType = transaction['operation_type'];
          icon = Icons.help_outline;
        }
        break;
      }

      String operationStatus;
      switch(transaction['status']) {
        case 'closed': {
          operationStatus = "transaction_info.completed".tr();
        }
        break;

        default: {
          operationStatus = transaction['status'];
        }
        break;
      }
      Transaction newTransaction = Transaction(date: DateTime.parse(transaction['date']), valueDate: null, fiscalDate: null, accountType: 'transaction_info.cash_account'.tr(), operationCode: transaction['operation_code'], operationType: operationType, icon: icon, instrumentCode: null, instrumentName: null, titles: null, price: null, amount: transaction['amount'].toDouble(), status: operationStatus);
      newTransactionList.add(newTransaction);
    }

    newTransactionList.sort((a, b) => b.date.compareTo(a.date));

    return(newTransactionList);
  }

  static bool _checkPendingTransactions(accountPendingTransactionData) {
    bool hasPendingTransactions = false;

    if (accountPendingTransactionData['orders'].isNotEmpty ||
        accountPendingTransactionData['transfers'].isNotEmpty ||
        accountPendingTransactionData['transfers_request'].isNotEmpty ||
        accountPendingTransactionData['cash_requests'].isNotEmpty) {
      hasPendingTransactions = true;
    }

    return(hasPendingTransactions);
  }

  static double _getCashNeededToTrade(portfolioExtraInfo) {
    double additionalCashNeededToTrade = portfolioExtraInfo['additional_cash_needed_to_trade'].toDouble();

    return(additionalCashNeededToTrade);
  }

  Account({@required this.accountInfo, @required this.accountPerformanceData, @required this.accountPortfolioData, @required this.accountInstrumentTransactionData, @required this.accountCashTransactionData, @required this.accountPendingTransactionData})
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
        _performanceSeries = _createPerformanceSeries(accountPerformanceData['performance']['period'], accountPerformanceData['performance']['best_return'], accountPerformanceData['performance']['worst_return'], accountPerformanceData['performance']['expected_return'], accountPerformanceData['performance']['real']),
        _profitLossSeries = _createProfitLossSeries(accountPerformanceData['performance']['period'], accountPerformanceData['performance']['real']),
        _transactionList = _createTransactionList(accountInstrumentTransactionData, accountCashTransactionData),
        _additionalCashNeededToTrade = _getCashNeededToTrade(accountPortfolioData['extra']),
        _hasPendingTransactions = _checkPendingTransactions(accountPendingTransactionData);


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
  Map<int, List<List>> get profitLossSeries => _profitLossSeries;
  List<Transaction> get transactionList => _transactionList;
  bool get hasPendingTransactions => _hasPendingTransactions;
  double get additionalCashNeededToTrade => _additionalCashNeededToTrade;
}
