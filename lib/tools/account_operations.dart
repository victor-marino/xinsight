import 'package:flutter/material.dart';
import 'package:indexax/models/amounts_datapoint.dart';
import 'package:indexax/models/returns_datapoint.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/models/performance_datapoint.dart';
import 'package:indexax/models/transaction.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/sorting.dart';
import 'package:easy_localization/easy_localization.dart';

/* This file groups all the functions that process the raw account data
and create the final data structures stored in the Account class, to be used
throughout the app. */

/* The settings below add a fake emergency fund for testing purposes.
To use it, set 'addTestEmergencyFund' to 'true' and fill out the fund details.
Do NOT use if the real account already has an emergency fund! */
bool addTestEmergencyFund = false;
double testEmergencyFundAmount = 1200.055863;
double testEmergencyFundCostAmount = 1000;
double testEmergencyFundTitles = 205.31;
String testEmergencyFundName = "BlackRock ICS Euro Liquidity";
String testEmergencyFundISIN = "IE00B44QSK78";
String testEmergencyFundCompany = "";
String testEmergencyFundDescription =
    "Es un fondo monetario de 1 día de horizonte temporal cuyo objetivo es la conservación de capital invirtiendo en activos de alta liquidez, de corto plazo y de bajo riesgo y obtener una rentabilidad acorde con los tipos del mercado monetario (€STR index).";
/* End of test settings for emergency fund */

List<AmountsDataPoint> createAmountsSeries(netAmountsList, totalAmountsList) {
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

List<ReturnsDataPoint> createReturnsSeries(returnsList) {
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

List<PortfolioDataPoint> createPortfolioData(portfolio, instruments) {
  // Creates a list with all the assets in the portfolio
  List<PortfolioDataPoint> newPortfolioData = [];
  for (var instrument in instruments) {
    InstrumentType currentInstrumentType;
    if (instrument['instrument']['asset_class'].contains('equity')) {
      currentInstrumentType = InstrumentType.equity;
    } else if (instrument['instrument']['asset_class'].contains('fixed')) {
      currentInstrumentType = InstrumentType.fixed;
    } else if (instrument['instrument']['asset_class'].contains('cash_euro')) {
      currentInstrumentType = InstrumentType.moneymarket;
    } else {
      currentInstrumentType = InstrumentType.other;
    }

    double? currentInstrumentPercentage =
        instrument['amount'].toDouble() / portfolio['total_amount'].toDouble();
    double? currentInstrumentProfitLoss =
        instrument['amount'].toDouble() - instrument['cost_amount'].toDouble();
    String? currentInstrumentDescription;

    // Filter out hyperlinks from descriptions
    if (instrument['instrument']['description'] == "" ||
        instrument['instrument']['description'] == null) {
      currentInstrumentDescription =
          'asset_details.description_not_available'.tr();
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

  if (addTestEmergencyFund) {
    // Add test money market fund for testing purposes
    PortfolioDataPoint newPoint = PortfolioDataPoint(
        instrumentType: InstrumentType.moneymarket,
        instrumentName: testEmergencyFundName,
        instrumentCodeType: "ISIN",
        instrumentCode: testEmergencyFundISIN,
        instrumentCompany: testEmergencyFundCompany,
        instrumentDescription: testEmergencyFundDescription,
        titles: testEmergencyFundTitles,
        amount: testEmergencyFundAmount,
        cost: testEmergencyFundCostAmount,
        profitLoss: testEmergencyFundAmount - testEmergencyFundCostAmount,
        percentage:
            testEmergencyFundAmount / portfolio['total_amount'].toDouble());

    newPortfolioData.add(newPoint);
  }

  newPortfolioData.add(PortfolioDataPoint(
      instrumentType: InstrumentType.cash,
      instrumentName: 'cash',
      amount:
          getDoubleWithTwoDecimalPlaces(portfolio['cash_amount'].toDouble()),
      percentage: portfolio['cash_amount'].toDouble() /
          portfolio['total_amount'].toDouble()));

  newPortfolioData.sort(compareInstruments);

  return (newPortfolioData);
}

Map<InstrumentType, Map<ValueType, double>> createPortfolioDistribution(
    portfolio, instruments) {
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
  if (instruments.any((element) =>
      element['instrument']['asset_class'].toString().contains('cash_euro'))) {
    portfolioDistribution[InstrumentType.moneymarket] = {};
    portfolioDistribution[InstrumentType.moneymarket]![ValueType.percentage] =
        0;
    portfolioDistribution[InstrumentType.moneymarket]![ValueType.amount] = 0;
  }
  if (instruments.any((element) => (!(element['instrument']['asset_class']
          .toString()
          .contains('equity')) &&
      !(element['instrument']['asset_class'].toString().contains('fixed')) &&
      !(element['instrument']['asset_class']
          .toString()
          .contains('cash_euro'))))) {
    portfolioDistribution[InstrumentType.other] = {};
    portfolioDistribution[InstrumentType.other]![ValueType.amount] = 0;
    portfolioDistribution[InstrumentType.other]![ValueType.percentage] = 0;
  }

  if (addTestEmergencyFund) {
    // Add fake money market category for testing
    portfolioDistribution[InstrumentType.moneymarket] = {};
    portfolioDistribution[InstrumentType.moneymarket]![ValueType.amount] = 0;
    portfolioDistribution[InstrumentType.moneymarket]![ValueType.percentage] =
        0;
  }

  portfolioDistribution[InstrumentType.cash] = {};
  portfolioDistribution[InstrumentType.cash]![ValueType.amount] = 0;
  portfolioDistribution[InstrumentType.cash]![ValueType.percentage] = 0;

  for (var instrument in instruments) {
    double? currentInstrumentAmount = instrument['amount'].toDouble();
    double? currentInstrumentPercentage =
        instrument['amount'].toDouble() / portfolio['total_amount'].toDouble();

    if (instrument['instrument']['asset_class'].contains('equity')) {
      portfolioDistribution[InstrumentType.equity]![ValueType.amount] =
          portfolioDistribution[InstrumentType.equity]![ValueType.amount]! +
              currentInstrumentAmount!;
      portfolioDistribution[InstrumentType.equity]![ValueType.percentage] =
          portfolioDistribution[InstrumentType.equity]![ValueType.percentage]! +
              currentInstrumentPercentage!;
    } else if (instrument['instrument']['asset_class'].contains('fixed')) {
      portfolioDistribution[InstrumentType.fixed]![ValueType.amount] =
          portfolioDistribution[InstrumentType.fixed]![ValueType.amount]! +
              currentInstrumentAmount!;
      portfolioDistribution[InstrumentType.fixed]![ValueType.percentage] =
          portfolioDistribution[InstrumentType.fixed]![ValueType.percentage]! +
              currentInstrumentPercentage!;
    } else if (instrument['instrument']['asset_class'].contains('cash_euro')) {
      portfolioDistribution[InstrumentType.moneymarket]![ValueType.amount] =
          portfolioDistribution[InstrumentType.moneymarket]![
                  ValueType.amount]! +
              currentInstrumentAmount!;
      portfolioDistribution[InstrumentType.moneymarket]![ValueType.percentage] =
          portfolioDistribution[InstrumentType.moneymarket]![
                  ValueType.percentage]! +
              currentInstrumentPercentage!;
    } else {
      portfolioDistribution[InstrumentType.other]![ValueType.amount] =
          portfolioDistribution[InstrumentType.other]![ValueType.amount]! +
              currentInstrumentAmount!;
      portfolioDistribution[InstrumentType.other]![ValueType.percentage] =
          portfolioDistribution[InstrumentType.other]![ValueType.percentage]! +
              currentInstrumentPercentage!;
    }
  }

  if (addTestEmergencyFund) {
    // Add fake money market fund for testing
    portfolioDistribution[InstrumentType.moneymarket]![ValueType.amount] =
        portfolioDistribution[InstrumentType.moneymarket]![ValueType.amount]! +
            testEmergencyFundAmount;
    portfolioDistribution[InstrumentType.moneymarket]![ValueType.percentage] =
        portfolioDistribution[InstrumentType.moneymarket]![
                ValueType.percentage]! +
            testEmergencyFundAmount / portfolio['total_amount'];
  }

  portfolioDistribution[InstrumentType.cash]![ValueType.amount] =
      portfolioDistribution[InstrumentType.cash]![ValueType.amount]! +
          portfolio['cash_amount'];
  portfolioDistribution[InstrumentType.cash]![ValueType.percentage] =
      portfolioDistribution[InstrumentType.cash]![ValueType.percentage]! +
          portfolio['cash_amount'] / portfolio['total_amount'];

  return (portfolioDistribution);
}

List<PerformanceDataPoint> createPerformanceSeries(
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
      currentRealReturn = (realPerformanceList[currentPeriod] - 100).toDouble();
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

Map<int, List<List>> createProfitLossSeries(
    performancePeriodList, realPerformanceList, cashReturnsSeries) {
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

  for (int year in years) {
    profitLossSeries.putIfAbsent(year, () => []);
    profitLossSeries[year] =
        List<List>.generate(13, (index) => ["", null, null]);
    profitLossSeries[year]!.asMap().forEach((index, value) {
      profitLossSeries[year]![index][0] = monthList[index];
    });
  }

  for (int i = 0; i < realPerformanceList.length; i++) {
    profitLossSeries[DateTime.parse(performancePeriodList[i]).year]![
            DateTime.parse(performancePeriodList[i]).month - 1][1] =
        realPerformanceList[i].toDouble();
  }

  for (int year in years) {
    double totalProfit = 1;
    for (int i = 0; i < profitLossSeries[year]!.length - 1; i++) {
      if (profitLossSeries[year]![i][1] != null) {
        totalProfit *= (profitLossSeries[year]![i][1]) + 1;
      }
    }
    profitLossSeries[year]![12][1] = totalProfit - 1;
  }

  for (int year in years) {
    for (int i = 0; i < profitLossSeries[year]!.length; i++) {
      if (profitLossSeries[year]![i][1] != null) {
        profitLossSeries[year]![i][1] =
            num.parse((profitLossSeries[year]![i][1] * 100).toStringAsFixed(1));
      }
    }
  }

  // Add the cash return values to each month
  cashReturnsSeries.keys.forEach((k) {
    int year = DateTime.parse(k).year;
    int month = DateTime.parse(k).month;
    if (profitLossSeries[year]![month - 1][2] == null) {
      profitLossSeries[year]![month - 1][2] = cashReturnsSeries[k].toDouble();
    } else {
      profitLossSeries[year]![month - 1][2] += cashReturnsSeries[k].toDouble();
    }
  });

  print(profitLossSeries.toString());
  
  return (profitLossSeries);
}

List<Transaction> createTransactionList(
    accountInstrumentTransactionData, accountCashTransactionData) {
  // Creates a merged list including all cash and securities transactions
  List<Transaction> newTransactionList = [];
  for (var transaction in accountInstrumentTransactionData) {
    String operationType;
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

    String operationStatus;
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

    final Uri pdfDownloadLink = Uri(
        scheme: 'https',
        host: 'indexacapital.com',
        path:
            'es/u/view-document/${transaction['document']['name']}/${transaction['document']['clean_show_name']}',
        fragment: 'settings-apps');

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
        status: operationStatus,
        downloadLink: pdfDownloadLink);
    newTransactionList.add(newTransaction);
  }

  // Reformat the text for some typical strings to improve readability
  for (var transaction in accountCashTransactionData) {
    String operationType;
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

    String operationStatus;
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

  newTransactionList.sort(compareTransactions);
  return (newTransactionList);
}

bool checkPendingTransactions(accountPendingTransactionData) {
  // Returns true if there are pending transactions. Checked at build time
  // to show the relevant indicator to the user if needed.
  bool hasPendingTransactions = false;

  if (accountPendingTransactionData['orders'].isNotEmpty ||
      accountPendingTransactionData['transfers'].isNotEmpty ||
      accountPendingTransactionData['transfers_request'].isNotEmpty ||
      accountPendingTransactionData['cash_requests'].isNotEmpty) {
    hasPendingTransactions = true;
  }

  return (hasPendingTransactions);
}

bool isReconciledToday(accountInfo) {
  // Returns false if the account isn't reconciled with the latest data yet.
  // Checked at build time to show the relevant indicator to the user if needed.
  DateTime today = DateTime.now();
  DateTime todayAtMidnight = DateTime(today.year, today.month, today.day);
  DateTime yesterday = todayAtMidnight.subtract(const Duration(days: 1));
  DateTime reconciledUntil = DateTime.parse(accountInfo['reconciled_until']);

  return (reconciledUntil == yesterday);
}

double getCashNeededToTrade(portfolioExtraInfo) {
  double additionalCashNeededToTrade =
      portfolioExtraInfo['additional_cash_needed_to_trade'].toDouble();

  return (additionalCashNeededToTrade);
}
