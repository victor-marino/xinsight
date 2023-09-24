import 'package:flutter/foundation.dart';
import "package:flutter/services.dart";
import "package:indexax/tools/networking.dart";
import "package:indexax/models/account.dart";
import "package:flutter/material.dart";

import 'dart:convert';

const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
  // Class that fetches account data from API endpoint

  /* If you want to test support for multiple accounts, set 'addTestAccounts' to
  true and enter a real account number in the 'testAccountNumber' variable.
  This will load the same account data every time. */
  final bool addTestAccounts = false;
  final String testAccountNumber = "";
  /* End of test account parameters */

  final String token;

  IndexaData({required this.token});

  Future getLocalAccounts() async {
    final String response =
        await rootBundle.loadString('assets/test_json/me_vacio.json');
    final data = await json.decode(response);
    return data;
  }

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<Map<String, String>> userAccounts = [];
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      // var userData = await networkHelper.getData();
      var userData = await getLocalAccounts();
      if (userData != null) {
        for (var account in userData['accounts']) {
          if (account['status'].toString() == "active") {
            userAccounts.add({
              "number": account['account_number'].toString(),
              "type": account['type'].toString()
            });
          }
        }
        /* If 'addTestAccounts' has been set, we add the fake accounts here.
        You can add as many as you want. Just make sure their names contain
        the string "Test", and that you enter a valid account type ('mutual',
        'pension', 'epsv' or 'employment_plan'). */
        if (addTestAccounts) {
          userAccounts.add({"number": "Test1", "type": "pension"});
          userAccounts.add({"number": "Test2", "type": "employment_plan"});
        }

        return userAccounts;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future getLocalAccountInfo() async {
    final String response = await rootBundle
        .loadString('assets/test_json/account_info_vacio.json');
    final data = await json.decode(response);
    return data;
  }

  Future<dynamic> getAccountInfo({required String accountNumber}) async {
    String url;
    if (addTestAccounts) {
      url = '$indexaURL/accounts/$testAccountNumber';
    } else {
      url = '$indexaURL/accounts/$accountNumber';
    }
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      // var accountInfo = await networkHelper.getData();
      var accountInfo = await getLocalAccountInfo();
      return accountInfo;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future getLocalPerformanceData() async {
    final String response = await rootBundle
        .loadString('assets/test_json/performance_cuenta_sin_inversiones.json');
    final data = await json.decode(response);
    return data;
  }

  Future<dynamic> getAccountPerformanceData(
      {required String accountNumber}) async {
    String url;
    if (addTestAccounts) {
      url = '$indexaURL/accounts/$testAccountNumber/performance';
    } else {
      url = '$indexaURL/accounts/$accountNumber/performance';
    }
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      //var accountPerformanceData = await networkHelper.getData();
      var accountPerformanceData = await getLocalPerformanceData();
      if (accountPerformanceData != null && !accountNumber.contains("Test")) {
        return accountPerformanceData;
      } else if (accountPerformanceData != null &&
          accountNumber.contains("Test")) {
        /* We use fake, time-bound numbers as balance for the test accounts.
        This can be useful to check if reload/refresh functions are actually
        reloading the data when triggered (e.g.: pulling down to refresh),
        as the values keep changing every second. */
        accountPerformanceData['return']['total_amount'] =
            DateTime.now().second;
        accountPerformanceData['return']['investment'] = 1000.00;
        return accountPerformanceData;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future getLocalPortfolioData() async {
    final String response = await rootBundle
        .loadString('assets/test_json/portfolio_cuenta_sin_inversiones.json');
    final data = await json.decode(response);
    return data;
  }

  Future<dynamic> getAccountPortfolioData(
      {required String accountNumber}) async {
    String url;
    if (addTestAccounts) {
      url = '$indexaURL/accounts/$testAccountNumber/portfolio';
    } else {
      url = '$indexaURL/accounts/$accountNumber/portfolio';
    }
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      // var accountPortfolioData = await networkHelper.getData();
      var accountPortfolioData = await getLocalPortfolioData();

      if (accountPortfolioData != null) {
        return accountPortfolioData;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future getLocalInstrumentTransactions() async {
    final String response = await rootBundle
        .loadString('assets/test_json/instrument_transactions_vacio.json');
    final data = await json.decode(response);
    return data;
  }

  Future<dynamic> getAccountInstrumentTransactionData(
      {required String accountNumber}) async {
    String url;
    if (addTestAccounts) {
      url = '$indexaURL/accounts/$testAccountNumber/instrument-transactions';
    } else {
      url = '$indexaURL/accounts/$accountNumber/instrument-transactions';
    }
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      //var accountInstrumentTransactionData = await networkHelper.getData();
      var accountInstrumentTransactionData = await getLocalInstrumentTransactions();
      if (accountInstrumentTransactionData != null) {
        return accountInstrumentTransactionData;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future getLocalCashTransactions() async {
    final String response = await rootBundle
        .loadString('assets/test_json/cash_transactions_vacio.json');
    final data = await json.decode(response);
    return data;
  }

  Future<dynamic> getAccountCashTransactionData(
      {required String accountNumber}) async {
    String url;
    if (addTestAccounts) {
      url = '$indexaURL/accounts/$testAccountNumber/cash-transactions';
    } else {
      url = '$indexaURL/accounts/$accountNumber/cash-transactions';
    }
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      // var accountCashTransactionData = await networkHelper.getData();
      var accountCashTransactionData = await getLocalCashTransactions();
      if (accountCashTransactionData != null) {
        return accountCashTransactionData;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<dynamic> getAccountPendingTransactionData(
      {required String accountNumber}) async {
    String url;
    if (addTestAccounts) {
      url = '$indexaURL/accounts/$testAccountNumber/pending-transactions';
    } else {
      url = '$indexaURL/accounts/$accountNumber/pending-transactions';
    }
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountPendingTransactionData = await networkHelper.getData();
      if (accountPendingTransactionData != null) {
        return accountPendingTransactionData;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<Account> populateAccountData(
      {required BuildContext context, required String accountNumber}) async {
    // Populates a new Account object with all fetched data
    Account currentAccount;
    try {
      var currentAccountInfo =
          await getAccountInfo(accountNumber: accountNumber);
      var currentAccountPerformanceData =
          await getAccountPerformanceData(accountNumber: accountNumber);
      var currentAccountPortfolioData =
          await getAccountPortfolioData(accountNumber: accountNumber);
      var currentAccountInstrumentTransactionData =
          await getAccountInstrumentTransactionData(
              accountNumber: accountNumber);
      var currentAccountCashTransactionData =
          await getAccountCashTransactionData(accountNumber: accountNumber);
      var currentAccountPendingTransactionData =
          await getAccountPendingTransactionData(accountNumber: accountNumber);
      currentAccount = Account(
          accountInfo: currentAccountInfo,
          accountPerformanceData: currentAccountPerformanceData,
          accountPortfolioData: currentAccountPortfolioData,
          accountInstrumentTransactionData:
              currentAccountInstrumentTransactionData,
          accountCashTransactionData: currentAccountCashTransactionData,
          accountPendingTransactionData: currentAccountPendingTransactionData);
    } on Exception {
      rethrow;
    }
    return currentAccount;
  }
}
