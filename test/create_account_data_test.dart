import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'test_data/account_data_10k.dart';
import 'package:indexax/models/account.dart' as account;
import 'dart:convert';

void main() {
  final accountInfo10k = jsonDecode(File('test/test_data/account_info_10k.json').readAsStringSync());
  final accountPerformanceData10k = jsonDecode(File('test/test_data/account_performance_data_10k.json').readAsStringSync());
  final accountPortfolioData10k = jsonDecode(File('test/test_data/account_portfolio_data_10k.json').readAsStringSync());
  final accountInstrumentTransactionData10k = jsonDecode(File('test/test_data/account_instrument_transaction_data_10k.json').readAsStringSync());
  final accountCashTransactionData10k = jsonDecode(File('test/test_data/account_cash_transaction_data_10k.json').readAsStringSync());
  final accountPendingTransactionData10k = jsonDecode(File('test/test_data/account_pending_transaction_data_10k.json').readAsStringSync());

  final testAccount10k = account.Account(accountInfo: accountInfo10k, accountPerformanceData: accountPerformanceData10k, accountPortfolioData: accountPortfolioData10k, accountInstrumentTransactionData: accountInstrumentTransactionData10k, accountCashTransactionData: accountCashTransactionData10k, accountPendingTransactionData: accountPendingTransactionData10k);

  group('Test Account data', ()
  {
    test('Test createAmountSeries function', () {
      expect(testAccount10k.amountsSeries.toString(), amountSeries10k);
    });
    test('Test createPortfolioData function', () {
      expect(testAccount10k.portfolioData.toString(), portfolioData10k);
    });
    test('Test createPortfolioDistribution function', () {
      expect(testAccount10k.portfolioDistribution.toString(), portfolioDistribution10k);
    });
    test('Test createPerformanceSeries function', () {
      expect(testAccount10k.performanceSeries.toString(), performanceSeries10k);
    });
    test('Test createProfitLossSeries function', () {
      expect(testAccount10k.profitLossSeries.toString(), profitLossSeries10k);
    });
    test('Test createTransactionList function', () {
      expect(testAccount10k.transactionList.toString(), transactionList10k);
    });
    test('Test checkPendingTransactions function', () {
      expect(testAccount10k.hasPendingTransactions.toString(), pendingTransactions10k);
    });
    test('Test checkGetCashNeededToTrade function', () {
      expect(testAccount10k.additionalCashNeededToTrade.toString(), additionalCashNeededToTrade10k);
    });
  });
}