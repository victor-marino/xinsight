import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'account_data_10k.dart' as account10k;
import 'package:indexax/models/account.dart' as account;
import 'dart:convert';

void main() {
  final accountInfo10k = jsonDecode(File('test/test_data_10k/account_info.json').readAsStringSync());
  final accountPerformanceData10k = jsonDecode(File('test/test_data_10k/account_performance_data.json').readAsStringSync());
  final accountPortfolioData10k = jsonDecode(File('test/test_data_10k/account_portfolio_data.json').readAsStringSync());
  final accountInstrumentTransactionData10k = jsonDecode(File('test/test_data_10k/account_instrument_transaction_data.json').readAsStringSync());
  final accountCashTransactionData10k = jsonDecode(File('test/test_data_10k/account_cash_transaction_data.json').readAsStringSync());
  final accountPendingTransactionData10k = jsonDecode(File('test/test_data_10k/account_pending_transaction_data.json').readAsStringSync());

  final testAccount10k = account.Account(accountInfo: accountInfo10k, accountPerformanceData: accountPerformanceData10k, accountPortfolioData: accountPortfolioData10k, accountInstrumentTransactionData: accountInstrumentTransactionData10k, accountCashTransactionData: accountCashTransactionData10k, accountPendingTransactionData: accountPendingTransactionData10k);

  group('Test Account data', ()
  {
    test('Test totalAmount', () {
      expect(testAccount10k.totalAmount.toString(), account10k.totalAmount);
    });
    test('Test investment', () {
      expect(testAccount10k.investment.toString(), account10k.investment);
    });
    test('Test timeReturn', () {
      expect(testAccount10k.timeReturn.toString(), account10k.timeReturn);
    });
    test('Test timeReturnColor', () {
      expect(testAccount10k.timeReturnColor.toString(), account10k.timeReturnColor);
    });
    test('Test moneyReturn', () {
      expect(testAccount10k.moneyReturn.toString(), account10k.moneyReturn);
    });
    test('Test moneyReturnColor', () {
      expect(testAccount10k.moneyReturnColor.toString(), account10k.moneyReturnColor);
    });
    test('Test expectedReturn', () {
      expect(testAccount10k.expectedReturn.toString(), account10k.expectedReturn);
    });
    test('Test bestReturn1yr', () {
      expect(testAccount10k.bestReturn1yr.toString(), account10k.bestReturn1yr);
    });
    test('Test worstReturn1yr', () {
      expect(testAccount10k.worstReturn1yr.toString(), account10k.worstReturn1yr);
    });
    test('Test bestReturn10yr', () {
      expect(testAccount10k.bestReturn10yr.toString(), account10k.bestReturn10ry);
    });
    test('Test worstReturn10y', () {
      expect(testAccount10k.worstReturn10yr.toString(), account10k.worstReturn10yr);
    });
    test('Test profitLoss', () {
      expect(testAccount10k.profitLoss.toString(), account10k.profitLoss);
    });
    test('Test profitLossColor', () {
      expect(testAccount10k.profitLossColor.toString(), account10k.profitLossColor);
    });
    test('Test hasActiveRewards', () {
      expect(testAccount10k.hasActiveRewards.toString(), account10k.hasActiveRewards);
    });
    test('Test feeFreeAmount', () {
      expect(testAccount10k.feeFreeAmount.toString(), account10k.feeFreeAmount);
    });
    test('Test createAmountSeries function', () {
      expect(testAccount10k.amountsSeries.toString(), account10k.amountSeries);
    });
    test('Test createPortfolioData function', () {
      expect(testAccount10k.portfolioData.toString(), account10k.portfolioData);
    });
    test('Test createPortfolioDistribution function', () {
      expect(testAccount10k.portfolioDistribution.toString(), account10k.portfolioDistribution);
    });
    test('Test createPerformanceSeries function', () {
      expect(testAccount10k.performanceSeries.toString(), account10k.performanceSeries);
    });
    test('Test createProfitLossSeries function', () {
      expect(testAccount10k.profitLossSeries.toString(), account10k.profitLossSeries);
    });
    test('Test createTransactionList function', () {
      expect(testAccount10k.transactionList.toString(), account10k.transactionList);
    });
    test('Test checkPendingTransactions function', () {
      expect(testAccount10k.hasPendingTransactions.toString(), account10k.pendingTransactions);
    });
    test('Test checkGetCashNeededToTrade function', () {
      expect(testAccount10k.additionalCashNeededToTrade.toString(), account10k.additionalCashNeededToTrade);
    });
  });
}