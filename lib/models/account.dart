import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'amounts_datapoint.dart';
import 'performance_datapoint.dart';
import 'portfolio_datapoint.dart';
import 'returns_datapoint.dart';
import 'transaction.dart';
import 'package:indexax/tools/number_formatting.dart';

// Main class that stores and processes all account data
class Account {
  final accountPerformanceData;
  final accountPortfolioData;
  final accountInfo;
  final accountInstrumentTransactionData;
  final accountCashTransactionData;
  final accountPendingTransactionData;
  final String accountNumber;
  final String accountType;
  final int risk;
  final double totalAmount;
  final double investment;
  final double timeReturn;
  final Color timeReturnColor;
  final double timeReturnAnnual;
  final double moneyReturn;
  final Color moneyReturnColor;
  final double moneyReturnAnnual;
  final double volatility;
  final double sharpe;
  final double profitLoss;
  final Color profitLossColor;
  final double expectedReturn;
  final double bestReturn1yr;
  final double worstReturn1yr;
  final double bestReturn10yr;
  final double worstReturn10yr;
  final bool hasActiveRewards;
  final bool hasPendingTransactions;
  final double feeFreeAmount;
  final double additionalCashNeededToTrade;
  final List<AmountsDataPoint> amountsSeries;
  final List<ReturnsDataPoint> returnsSeries;
  final List<PortfolioDataPoint> portfolioData;
  final Map<InstrumentType, Map<ValueType, double>> portfolioDistribution;
  final List<PerformanceDataPoint> performanceSeries;
  final Map<int, List<List>> profitLossSeries;
  final List<Transaction> transactionList;

  static List<AmountsDataPoint> _createAmountsSeries(
      netAmountsList,
      totalAmountsList) {
      // Creates a time series with the value of the portfolio overtime
    List<AmountsDataPoint> newAmountSeries = [];
    netAmountsList.keys.forEach((k) {
      AmountsDataPoint newPoint = AmountsDataPoint(
          date: DateTime.parse(k),
          netAmount: netAmountsList[k].toDouble(),
          totalAmount: totalAmountsList[k].toDouble());
      newAmountSeries.add(newPoint);
    });
    return (newAmountSeries);
  }

  static List<ReturnsDataPoint> _createReturnsSeries(returnsList) {
  // Creates a time series with the returns of the portfolio overtime
    List<ReturnsDataPoint> newReturnSeries = [];
    returnsList.keys.forEach((k) {
      ReturnsDataPoint newPoint = ReturnsDataPoint(
        date: DateTime.parse(k),
        totalReturn: (returnsList[k].toDouble() - 1) * 100,
      );
      newReturnSeries.add(newPoint);
    });
    return (newReturnSeries);
  }

  static List<PortfolioDataPoint> _createPortfolioData(portfolio, instruments) {
    // Contains a list with all the assets in the portfolio
    List<PortfolioDataPoint> newPortfolioData = [];
    for (var instrument in instruments) {
      InstrumentType currentInstrumentType;
      double? currentInstrumentPercentage = instrument['amount'].toDouble() /
          portfolio['total_amount'].toDouble();
      double? currentInstrumentProfitLoss = instrument['amount'].toDouble() -
          instrument['cost_amount'].toDouble();
      String? currentInstrumentDescription;

      if (instrument['instrument']['asset_class'].contains('equity')) {
        currentInstrumentType = InstrumentType.equity;
      } else if (instrument['instrument']['asset_class'].contains('fixed')) {
        currentInstrumentType = InstrumentType.fixed;
      } else {
        currentInstrumentType = InstrumentType.other;
      }

      // Filter out hyperlinks from descriptions
      if (instrument['instrument']['description'] == "" ||
          instrument['instrument']['description'] == null) {
        currentInstrumentDescription =
            'asset_details_popup.description_not_available'.tr();
      } else if (instrument['instrument']['description']
          .contains(' Código ISIN')) {
        currentInstrumentDescription =
            instrument['instrument']['description'].split(' Código ISIN')[0];
      } else if (instrument['instrument']['description'].contains(' <a href')) {
        currentInstrumentDescription =
            instrument['instrument']['description'].split(' <a href')[0];
      } else {
        currentInstrumentDescription = instrument['instrument']['description'];
      }

      // Exclude 'phantom' funds when building portfolio data
      if ((instrument['amount'].toDouble != 0.0) &&
          (instrument['cost_amount'].toDouble() != 0.0) &&
          instrument['titles'].toDouble() != 0.0) {
        PortfolioDataPoint newPoint = PortfolioDataPoint(
            instrumentType: currentInstrumentType,
            instrumentName: instrument['instrument']['name'],
            instrumentCodeType: instrument['instrument']['identifier_name'],
            instrumentCode: instrument['instrument']['identifier'],
            instrumentCompany: instrument['instrument']
                ['management_company_description'],
            instrumentDescription: currentInstrumentDescription,
            titles: instrument['titles'].toDouble(),
            amount:
                getDoubleWithTwoDecimalPlaces(instrument['amount'].toDouble()),
            cost: getDoubleWithTwoDecimalPlaces(
                instrument['cost_amount'].toDouble()),
            profitLoss: currentInstrumentProfitLoss!.toDouble(),
            percentage: currentInstrumentPercentage!.toDouble());

        newPortfolioData.add(newPoint);
      }
    }

    newPortfolioData.add(PortfolioDataPoint(
        instrumentType: InstrumentType.cash,
        instrumentName: 'cash',
        amount:
            getDoubleWithTwoDecimalPlaces(portfolio['cash_amount'].toDouble()),
        percentage: portfolio['cash_amount'].toDouble() /
            portfolio['total_amount'].toDouble()));

    int compareInstruments(
        PortfolioDataPoint instrumentA, PortfolioDataPoint instrumentB) {
          // Sorts assets by type first, held amount second.
      if (instrumentA.instrumentType != instrumentB.instrumentType) {
        return instrumentA.instrumentType
            .toString()
            .compareTo(instrumentB.instrumentType.toString());
      } else {
        return instrumentB.amount!.compareTo(instrumentA.amount!);
      }
    }
    newPortfolioData.sort(compareInstruments);
    return (newPortfolioData);
  }

  static Map<InstrumentType, Map<ValueType, double>>
      _createPortfolioDistribution(portfolio, instruments) {
        // Creates a map with the portfolio distribution (equity, fixed, cash)
    Map<InstrumentType, Map<ValueType, double>> portfolioDistribution = {};

    if (instruments.any((element) =>
        element['instrument']['asset_class'].toString().contains('equity'))) {
      portfolioDistribution[InstrumentType.equity] = {};
      portfolioDistribution[InstrumentType.equity]![ValueType.percentage] = 0;
      portfolioDistribution[InstrumentType.equity]![ValueType.amount] = 0;
    }
    if (instruments.any((element) =>
        element['instrument']['asset_class'].toString().contains('fixed'))) {
      portfolioDistribution[InstrumentType.fixed] = {};
      portfolioDistribution[InstrumentType.fixed]![ValueType.percentage] = 0;
      portfolioDistribution[InstrumentType.fixed]![ValueType.amount] = 0;
    }
    if (instruments.any((element) => (!(element['instrument']['asset_class']
            .toString()
            .contains('equity')) &&
        !(element['instrument']['asset_class']
            .toString()
            .contains('fixed'))))) {
      portfolioDistribution[InstrumentType.other] = {};
      portfolioDistribution[InstrumentType.other]![ValueType.amount] = 0;
      portfolioDistribution[InstrumentType.other]![ValueType.percentage] = 0;
    }

    portfolioDistribution[InstrumentType.cash] = {};
    portfolioDistribution[InstrumentType.cash]![ValueType.amount] = 0;
    portfolioDistribution[InstrumentType.cash]![ValueType.percentage] = 0;

    for (var instrument in instruments) {
      double? currentInstrumentAmount = instrument['amount'].toDouble();
      double? currentInstrumentPercentage = instrument['amount'].toDouble() /
          portfolio['total_amount'].toDouble();

      if (instrument['instrument']['asset_class'].contains('equity')) {
        portfolioDistribution[InstrumentType.equity]![ValueType.amount] =
            portfolioDistribution[InstrumentType.equity]![ValueType.amount]! +
                currentInstrumentAmount!;
        portfolioDistribution[InstrumentType.equity]![ValueType.percentage] =
            portfolioDistribution[InstrumentType.equity]![
                    ValueType.percentage]! +
                currentInstrumentPercentage!;
      } else if (instrument['instrument']['asset_class'].contains('fixed')) {
        portfolioDistribution[InstrumentType.fixed]![ValueType.amount] =
            portfolioDistribution[InstrumentType.fixed]![ValueType.amount]! +
                currentInstrumentAmount!;
        portfolioDistribution[InstrumentType.fixed]![ValueType.percentage] =
            portfolioDistribution[InstrumentType.fixed]![
                    ValueType.percentage]! +
                currentInstrumentPercentage!;
      } else {
        portfolioDistribution[InstrumentType.other]![ValueType.amount] =
            portfolioDistribution[InstrumentType.other]![ValueType.amount]! +
                currentInstrumentAmount!;
        portfolioDistribution[InstrumentType.other]![ValueType.percentage] =
            portfolioDistribution[InstrumentType.other]![
                    ValueType.percentage]! +
                currentInstrumentPercentage!;
      }
    }
    portfolioDistribution[InstrumentType.cash]![ValueType.amount] =
        portfolioDistribution[InstrumentType.cash]![ValueType.amount]! +
            portfolio['cash_amount'];
    portfolioDistribution[InstrumentType.cash]![ValueType.percentage] =
        portfolioDistribution[InstrumentType.cash]![ValueType.percentage]! +
            portfolio['cash_amount'] / portfolio['total_amount'];

    return (portfolioDistribution);
  }

  static List<PerformanceDataPoint> _createPerformanceSeries(
    // Creates a time series with the real and estimated performance overtime
      performancePeriodList,
      bestPerformanceList,
      worstPerformanceList,
      expectedPerformanceList,
      realPerformanceList) {
    List<PerformanceDataPoint> newPerformanceSeries = [];
    int currentPeriod = 0;
    double? currentRealReturn;
    double? currentRealMonthlyReturn;
    for (var period in performancePeriodList) {
      if (currentPeriod < realPerformanceList.length) {
        currentRealReturn =
            (realPerformanceList[currentPeriod] - 100).toDouble();
        if (currentPeriod == 0) {
          currentRealMonthlyReturn = 0.00;
        } else {
          currentRealMonthlyReturn = ((realPerformanceList[currentPeriod] -
                      realPerformanceList[currentPeriod - 1]) /
                  100)
              .toDouble();
        }
      } else {
        currentRealMonthlyReturn = null;
        currentRealReturn = null;
      }
      PerformanceDataPoint newPoint = PerformanceDataPoint(
          date: DateTime.parse(period),
          bestReturn: (bestPerformanceList[currentPeriod] - 100).toDouble(),
          worstReturn: (worstPerformanceList[currentPeriod] - 100).toDouble(),
          expectedReturn:
              (expectedPerformanceList[currentPeriod] - 100).toDouble(),
          realReturn: currentRealReturn,
          realMonthlyReturn: currentRealMonthlyReturn);
      newPerformanceSeries.add(newPoint);
      currentPeriod++;
    }
    return (newPerformanceSeries);
  }

  static Map<int, List<List>> _createProfitLossSeries(
      performancePeriodList, realPerformanceList) {
        // Creates the profit-loss time series for the monthly chart
    Map<int, List<List>> profitLossSeries = {};
    List<String> monthList = [
      'months_short.january'.tr(),
      'months_short.february'.tr(),
      'months_short.march'.tr(),
      'months_short.april'.tr(),
      'months_short.may'.tr(),
      'months_short.june'.tr(),
      'months_short.july'.tr(),
      'months_short.august'.tr(),
      'months_short.september'.tr(),
      'months_short.october'.tr(),
      'months_short.november'.tr(),
      'months_short.december'.tr(),
      "YTD"
    ];

    performancePeriodList =
        performancePeriodList.sublist(0, realPerformanceList.length);

    for (int i = realPerformanceList.length - 1; i > 0; i--) {
      realPerformanceList[i] =
          (realPerformanceList[i] / realPerformanceList[i - 1]) - 1;
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
      profitLossSeries[year]!.asMap().forEach((index, value) {
        profitLossSeries[year]![index][0] = monthList[index];
      });
    });

    for (int i = 0; i < realPerformanceList.length; i++) {
      profitLossSeries[DateTime.parse(performancePeriodList[i]).year]![
              DateTime.parse(performancePeriodList[i]).month - 1][1] =
          realPerformanceList[i].toDouble();
    }

    years.forEach((year) {
      double totalProfit = 1;
      for (int i = 0; i < profitLossSeries[year]!.length - 1; i++) {
        if (profitLossSeries[year]![i][1] != null) {
          totalProfit *= (profitLossSeries[year]![i][1]) + 1;
        }
      }
      profitLossSeries[year]![12][1] = totalProfit - 1;
    });

    years.forEach((year) {
      for (int i = 0; i < profitLossSeries[year]!.length; i++) {
        if (profitLossSeries[year]![i][1] != null) {
          profitLossSeries[year]![i][1] = num.parse(
              (profitLossSeries[year]![i][1] * 100).toStringAsFixed(1));
        }
      }
    });
    return (profitLossSeries);
  }

  static List<Transaction> _createTransactionList(
      accountInstrumentTransactionData, accountCashTransactionData) {
        // Creates a merged list including all cash and securities transactions 
    List<Transaction> newTransactionList = [];
    for (var transaction in accountInstrumentTransactionData) {
      String? operationType;
      IconData icon = Icons.pie_chart;
      
      // Reformat the text for some typical strings to improve readability
      switch (transaction['operation_code']) {
        case 20:
          {
            operationType = 'transaction_info.fund_purchase'.tr();
          }
          break;

        case 21:
          {
            operationType = 'transaction_info.fund_reimbursement'.tr();
          }
          break;

        case 67:
          {
            operationType = 'transaction_info.fund_purchase_by_transfer'.tr();
          }
          break;

        case 72:
          {
            operationType =
                'transaction_info.fund_reimbursement_by_transfer'.tr();
          }
          break;

        case 300:
          {
            operationType = 'transaction_info.pension_plan_purchase'.tr();
          }
          break;

        case 1371:
          {
            operationType = 'transaction_info.iic_purchase_switch'.tr();
          }
          break;

        case 1372:
          {
            operationType = 'transaction_info.iic_sale_switch'.tr();
          }
          break;

        case 302:
          {
            operationType =
                'transaction_info.subscription_transfer_internal_plan'.tr();
          }
          break;

        case 304:
          {
            operationType = 'transaction_info.sale_transfer_internal_plan'.tr();
          }
          break;

        default:
          {
            operationType = transaction['operation_type'][0].toUpperCase() +
                transaction['operation_type'].substring(1).toLowerCase();
          }
          break;
      }

      String? operationStatus;
      switch (transaction['status']) {
        case 'closed':
          {
            operationStatus = 'transaction_info.completed'.tr();
          }
          break;

        default:
          {
            operationStatus = transaction['status'];
          }
          break;
      }
      Transaction newTransaction = Transaction(
          date: DateTime.parse(transaction['date']),
          valueDate: DateTime.parse(transaction['value_date']),
          fiscalDate: DateTime.parse(transaction['fiscal_date']),
          accountType: 'transaction_info.securities_account'.tr(),
          operationCode: transaction['operation_code'],
          operationType: operationType,
          icon: icon,
          instrumentCodeType: transaction['instrument']['identifier_name'],
          instrumentCode: transaction['instrument']['identifier'],
          instrumentName: transaction['instrument']['name'],
          titles: transaction['titles'].toDouble(),
          price: transaction['price'].toDouble(),
          amount: transaction['amount'].toDouble(),
          status: operationStatus);
      newTransactionList.add(newTransaction);
    }

    // Reformat the text for some typical strings to improve readability
    for (var transaction in accountCashTransactionData) {
      String? operationType;
      IconData icon = Icons.toll;
      switch (transaction['operation_code']) {
        case 9200:
          {
            operationType = 'transaction_info.securities_operation'.tr();
          }
          break;

        case 285:
          {
            operationType = 'transaction_info.custodial_fee'.tr();
          }
          break;

        case 8152:
          {
            operationType = "transaction_info.management_fee".tr();
          }

          break;
        case 4589:
          {
            operationType = "transaction_info.money_deposit_by_transfer".tr();
          }
          break;

        case 4597:
          {
            operationType =
                "transaction_info.money_reimbursement_by_transfer".tr();
          }
          break;

        case 7944:
          {
            operationType = "transaction_info.interest_settlement".tr();
          }
          break;

        case 8111:
          {
            operationType = "transaction_info.transfer_in_other_bank".tr();
          }
          break;

        case 5185:
          {
            operationType = "transaction_info.inversis_custody".tr();
          }
          break;

        case 4547:
          {
            operationType = "transaction_info.management_fee_charge".tr();
          }
          break;

        default:
          {
            operationType = transaction['operation_type'][0].toUpperCase() +
                transaction['operation_type'].substring(1).toLowerCase();
          }
          break;
      }

      String? operationStatus;
      switch (transaction['status']) {
        case 'closed':
          {
            operationStatus = "transaction_info.completed".tr();
          }
          break;

        default:
          {
            operationStatus = transaction['status'];
          }
          break;
      }
      Transaction newTransaction = Transaction(
          date: DateTime.parse(transaction['date']),
          valueDate: null,
          fiscalDate: null,
          accountType: 'transaction_info.cash_account'.tr(),
          operationCode: transaction['operation_code'],
          operationType: operationType,
          icon: icon,
          instrumentCodeType: null,
          instrumentCode: null,
          instrumentName: null,
          titles: null,
          price: null,
          amount: transaction['amount'].toDouble(),
          status: operationStatus);
      newTransactionList.add(newTransaction);
    }

    int compareTransactions(
        Transaction transactionA, Transaction transactionB) {
          // Sorts transactions by date, amount and account type.
      if (transactionA.date != transactionB.date) {
        return transactionB.date!.compareTo(transactionA.date!);
      } else if (transactionA.amount!.abs() != transactionB.amount!.abs()) {
        return transactionB.amount!.abs().compareTo(transactionA.amount!.abs());
      } else {
        return transactionB.accountType
            .toString()
            .compareTo(transactionA.accountType.toString());
      }
    }
    newTransactionList.sort(compareTransactions);
    return (newTransactionList);
  }

  static bool _checkPendingTransactions(accountPendingTransactionData) {
    bool hasPendingTransactions = false;

    if (accountPendingTransactionData['orders'].isNotEmpty ||
        accountPendingTransactionData['transfers'].isNotEmpty ||
        accountPendingTransactionData['transfers_request'].isNotEmpty ||
        accountPendingTransactionData['cash_requests'].isNotEmpty) {
      hasPendingTransactions = true;
    }

    return (hasPendingTransactions);
  }

  static double _getCashNeededToTrade(portfolioExtraInfo) {
    double additionalCashNeededToTrade =
        portfolioExtraInfo['additional_cash_needed_to_trade'].toDouble();

    return (additionalCashNeededToTrade);
  }

  Account(
      {required this.accountInfo,
      required this.accountPerformanceData,
      required this.accountPortfolioData,
      required this.accountInstrumentTransactionData,
      required this.accountCashTransactionData,
      required this.accountPendingTransactionData})
      : accountNumber = accountInfo['account_number'],
        accountType = accountInfo['type'],
        risk = accountInfo['risk'],
        totalAmount =
            accountPerformanceData['return']['total_amount'].toDouble(),
        // The two commented lines below allow for some quick data tests
        // totalAmount = new DateTime.now().second.toDouble(),
        // totalAmount = 999999.99,
        investment = accountPerformanceData['return']['investment'].toDouble(),
        timeReturn = accountPerformanceData['return']['time_return'].toDouble(),
        timeReturnColor = getNumberColor(
            accountPerformanceData['return']['time_return'].toDouble()),
        timeReturnAnnual =
            accountPerformanceData['return']['time_return_annual'].toDouble(),
        moneyReturn =
            accountPerformanceData['return']['money_return'].toDouble(),
        moneyReturnColor = getNumberColor(
            accountPerformanceData['return']['money_return'].toDouble()),
        moneyReturnAnnual =
            accountPerformanceData['return']['money_return_annual'].toDouble(),
        volatility = accountPerformanceData['return']['volatility'].toDouble(),
        sharpe =
            accountPerformanceData['return']['time_return_annual'].toDouble() /
                accountPerformanceData['return']['volatility'].toDouble(),
        expectedReturn =
            accountPerformanceData['plan_expected_return'].toDouble(),
        bestReturn1yr =
            (accountPerformanceData['performance']['best_pl'][13] / 100)
                .toDouble(),
        worstReturn1yr =
            (accountPerformanceData['performance']['worst_pl'][13] / 100)
                .toDouble(),
        bestReturn10yr =
            (accountPerformanceData['performance']['best_pl'][120] / 100)
                .toDouble(),
        worstReturn10yr =
            (accountPerformanceData['performance']['worst_pl'][120] / 100)
                .toDouble(),
        profitLoss = accountPerformanceData['return']['pl'].toDouble(),
        profitLossColor =
            getNumberColor(accountPerformanceData['return']['pl'].toDouble()),
        hasActiveRewards = accountInfo['has_active_rewards'],
        feeFreeAmount = accountInfo['fee_free_amount'].toDouble(),
        amountsSeries = _createAmountsSeries(
            accountPerformanceData['return']['net_amounts'],
            accountPerformanceData['return']['total_amounts']),
        returnsSeries =
            _createReturnsSeries(accountPerformanceData['return']['index']),
        portfolioData = _createPortfolioData(accountPortfolioData['portfolio'],
            accountPortfolioData['instrument_accounts'][0]['positions']),
        portfolioDistribution = _createPortfolioDistribution(
            accountPortfolioData['portfolio'],
            accountPortfolioData['instrument_accounts'][0]['positions']),
        performanceSeries = _createPerformanceSeries(
            accountPerformanceData['performance']['period'],
            accountPerformanceData['performance']['best_return'],
            accountPerformanceData['performance']['worst_return'],
            accountPerformanceData['performance']['expected_return'],
            accountPerformanceData['performance']['real']),
        profitLossSeries = _createProfitLossSeries(
            accountPerformanceData['performance']['period'],
            accountPerformanceData['performance']['real']),
        transactionList = _createTransactionList(
            accountInstrumentTransactionData, accountCashTransactionData),
        additionalCashNeededToTrade =
            _getCashNeededToTrade(accountPortfolioData['extra']),
        hasPendingTransactions =
            _checkPendingTransactions(accountPendingTransactionData);

  @override
  String toString() {
    // Override toString() method for quick troubleshooting
    return "accountNumber: " +
        accountNumber.toString() +
        "type: " +
        accountType.toString() +
        "risk: " +
        risk.toString() +
        "\n" +
        "totalAmount: " +
        totalAmount.toString() +
        "\n" +
        "investment: " +
        investment.toString() +
        "\n" +
        "timeReturn: " +
        timeReturn.toString() +
        "\n" +
        "timeReturnColor: " +
        timeReturnColor.toString() +
        "\n" +
        "timeReturnAnnual: " +
        timeReturnAnnual.toString() +
        "\n" +
        "moneyReturn: " +
        moneyReturn.toString() +
        "\n" +
        "moneyReturnColor: " +
        moneyReturnColor.toString() +
        "\n" +
        "moneyReturnAnnual: " +
        moneyReturnAnnual.toString() +
        "\n" +
        "volatility: " +
        volatility.toString() +
        "\n" +
        "sharpe: " +
        sharpe.toString() +
        "\n" +
        "expectedReturn: " +
        expectedReturn.toString() +
        "\n" +
        "bestReturn1yr: " +
        bestReturn1yr.toString() +
        "\n" +
        "worstReturn1yr: " +
        worstReturn1yr.toString() +
        "\n" +
        "bestReturn10yr: " +
        bestReturn10yr.toString() +
        "\n" +
        "worstReturn10yr: " +
        worstReturn10yr.toString() +
        "\n" +
        "profitLoss: " +
        profitLoss.toString() +
        "\n" +
        "profitLossColor: " +
        profitLossColor.toString() +
        "\n" +
        "hasActiveRewards: " +
        hasActiveRewards.toString() +
        "\n" +
        "feeFreeAmount: " +
        feeFreeAmount.toString() +
        "\n" +
        "amountsSeries: " +
        amountsSeries.toString() +
        "\n" +
        "portfolioData: " +
        portfolioData.toString() +
        "\n" +
        "portfolioDistribution: " +
        portfolioDistribution.toString() +
        "\n" +
        "performanceSeries: " +
        performanceSeries.toString() +
        "\n" +
        "profitLossSeries: " +
        profitLossSeries.toString() +
        "\n" +
        "transactionList: " +
        transactionList.toString() +
        "\n" +
        "additionalCashNeededToTrade: " +
        additionalCashNeededToTrade.toString() +
        "\n" +
        "hasPendingTransactions: " +
        hasPendingTransactions.toString();
  }
}
