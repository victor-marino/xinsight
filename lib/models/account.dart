import 'package:flutter/material.dart';
import 'package:indexax/models/profit_loss_datapoint.dart';
import 'package:indexax/models/amounts_datapoint.dart';
import 'package:indexax/models/performance_datapoint.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/models/returns_datapoint.dart';
import 'package:indexax/models/transaction.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/account_operations.dart' as account_operations;

// Main class that stores all account data
class Account {
  final dynamic accountPerformanceData,
      accountPortfolioData,
      accountInfo,
      accountInstrumentTransactionData,
      accountCashTransactionData,
      accountPendingTransactionData;
  final String accountNumber, accountType;
  final int risk;
  final double totalAmount,
      investment,
      timeReturn,
      timeReturnAnnual,
      moneyReturn,
      moneyReturnAnnual,
      volatility,
      sharpe,
      profitLoss,
      expectedReturn,
      bestReturn1yr,
      worstReturn1yr,
      bestReturn10yr,
      worstReturn10yr,
      feeFreeAmount,
      additionalCashNeededToTrade;
  final Color timeReturnColor, moneyReturnColor, profitLossColor;
  final bool hasActiveRewards, hasPendingTransactions, isReconciledToday;
  final DateTime reconciledUntil;
  final List<AmountsDataPoint> amountsSeries;
  final List<ReturnsDataPoint> returnsSeries;
  final List<PortfolioDataPoint> portfolioData;
  final Map<InstrumentType, Map<ValueType, double>> portfolioDistribution;
  final List<PerformanceDataPoint> performanceSeries;
  final ({
    Map<int, List<ProfitLossDataPoint?>> monthlySeries,
    List<ProfitLossDataPoint> annualSeries
  }) profitLossSeries;
  final List<Transaction> transactionList;

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
            accountPerformanceData['return']['total_amount111'].toDouble(),
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
        reconciledUntil = DateTime.parse(accountInfo['reconciled_until']),
        isReconciledToday = account_operations.isReconciledToday(accountInfo),
        amountsSeries = account_operations.createAmountsSeries(
            accountPerformanceData['return']['net_amounts'],
            accountPerformanceData['return']['total_amounts']),
        returnsSeries = account_operations
            .createReturnsSeries(accountPerformanceData['return']['index']),
        portfolioData = account_operations.createPortfolioData(
            accountPortfolioData['portfolio'],
            accountPortfolioData['instrument_accounts'][0]['positions']),
        portfolioDistribution = account_operations.createPortfolioDistribution(
            accountPortfolioData['portfolio'],
            accountPortfolioData['instrument_accounts'][0]['positions']),
        performanceSeries = account_operations.createPerformanceSeries(
            accountPerformanceData['performance']['period'],
            accountPerformanceData['performance']['best_return'],
            accountPerformanceData['performance']['worst_return'],
            accountPerformanceData['performance']['expected_return'],
            accountPerformanceData['performance']['real']),
        profitLossSeries = account_operations.createProfitLossSeries(
            accountPerformanceData['performance']['period'],
            accountPerformanceData['performance']['real'],
            accountPerformanceData['return']['cash_returns']),
        transactionList = account_operations.createTransactionList(
            accountInstrumentTransactionData, accountCashTransactionData),
        additionalCashNeededToTrade = account_operations
            .getCashNeededToTrade(accountPortfolioData['extra']),
        hasPendingTransactions = account_operations
            .checkPendingTransactions(accountPendingTransactionData);
}
