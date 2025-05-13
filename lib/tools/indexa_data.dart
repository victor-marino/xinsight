import "dart:convert";

import 'package:flutter/foundation.dart';
import "package:flutter/services.dart";
import "package:indexax/tools/networking.dart";
import "package:indexax/models/account.dart";
import "package:flutter/material.dart";

const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
  // Class that fetches account data from API endpoint

  /* If you want to test support for multiple accounts, set 'addTestAccounts' to
  true and populate the 'testAccounts' map below with the desired account numbers and types.
  Valid types are 'mutual', 'pension', 'epsv' or 'employment_plan'. These accounts will be added after
  the normal accounts that are present under your user.

  If you want to load the data from local .json files instead, use 'local' as account number.
  The 'Local' functions below will be used for this.

  Any account number not named "local" must be a real account number under your user,
  as the data will be fetched from Indexa servers. */
  final bool addTestAccounts = true;
  final testAccounts = [
    {"number": "FHGNB6LM", "type": "pension"},
    {"number": "local", "type": "mutual"}
  ];
  
  Future getLocalAccounts() async {
    final String response =
        await rootBundle.loadString('assets/test_json/test_me.json');
    final data = await json.decode(response);
    return data;
  }

  Future getLocalAccountInfo() async {
    final String response =
        await rootBundle.loadString('assets/test_json/test_account_info.json');
    final data = await json.decode(response);
    return data;
  }

  Future getLocalPerformanceData() async {
    final String response =
        await rootBundle.loadString('assets/test_json/test_performance.json');
    final data = await json.decode(response);
    return data;
  }

  Future getLocalPortfolioData() async {
    final String response =
        await rootBundle.loadString('assets/test_json/test_portfolio.json');
    final data = await json.decode(response);
    return data;
  }

  Future getLocalInstrumentTransactions() async {
    final String response = await rootBundle
        .loadString('assets/test_json/test_instrument_transactions.json');
    final data = await json.decode(response);
    return data;
  }

    Future getLocalCashTransactions() async {
    final String response = await rootBundle
        .loadString('assets/test_json/test_cash_transactions.json');
    final data = await json.decode(response);
    return data;
  }

  Future getLocalPendingTransactions() async {
    final String response = await rootBundle
        .loadString('assets/test_json/test_pending_transactions.json');
    final data = await json.decode(response);
    return data;
  }
  /* End of test code */

  final String token;

  static const validAccountStatus = [
    "active",
    "init",
    "pending-contract",
    "pending-pbc",
    "pending-provider",
    "cancel-request"
  ];

  IndexaData({required this.token});

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<Map<String, String>> userAccounts = [];
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var userData = await networkHelper.getData();
      // var userData = await getLocalAccounts();
      if (userData != null) {
        for (var account in userData['accounts']) {
          // if (account['status'].toString() == "active") {
          if (validAccountStatus.contains(account['status'])) {
            userAccounts.add({
              "number": account['account_number'].toString(),
              "type": account['type'].toString()
            });
          }
        }
        // If 'addTestAccounts' has been set, we add them here.
        if (addTestAccounts) {
          for (var testAccount in testAccounts) {
            userAccounts.add(testAccount);
          }
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

  Future<dynamic> getAccountInfo({required String accountNumber}) async {
    dynamic accountInfo;
    if (accountNumber.contains("local")) {
      accountInfo = await getLocalAccountInfo();
    } else {
      String url = '$indexaURL/accounts/$accountNumber';
      NetworkHelper networkHelper = NetworkHelper(url, token);
      try {
        accountInfo = await networkHelper.getData();
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    }
    return accountInfo;
  }

  Future<dynamic> getAccountPerformanceData(
      {required String accountNumber}) async {
    dynamic accountPerformanceData;
    if (accountNumber.contains("local")) {
      accountPerformanceData = await getLocalPerformanceData();
    } else {
      String url = '$indexaURL/accounts/$accountNumber/performance';
      NetworkHelper networkHelper = NetworkHelper(url, token);
      try {
        accountPerformanceData = await networkHelper.getData();
        // // var accountPerformanceData = await getLocalPerformanceData();
        // if (accountPerformanceData != null && !accountNumber.contains("Test")) {
        //   return accountPerformanceData;
        // } else if (accountPerformanceData != null &&
        //     accountNumber.contains("Test")) {
        //   /* We use fake, time-bound numbers as balance for the test accounts.
        // This can be useful to check if reload/refresh functions are actually
        // reloading the data when triggered (e.g.: pulling down to refresh),
        // as the values keep changing every second. */
        //   accountPerformanceData['return']['total_amount'] =
        //       DateTime.now().second;
        //   accountPerformanceData['return']['investment'] = 1000.00;
        //   return accountPerformanceData;
        // }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    }
    if (accountPerformanceData != null) {
      return accountPerformanceData;
    }
  }

  Future<dynamic> getAccountPortfolioData(
      {required String accountNumber}) async {
    dynamic accountPortfolioData;
    if (accountNumber.contains("local")) {
      accountPortfolioData = await getLocalPortfolioData();
    } else {
      String url = '$indexaURL/accounts/$accountNumber/portfolio';
      NetworkHelper networkHelper = NetworkHelper(url, token);
      try {
        accountPortfolioData = await networkHelper.getData();
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    }
    if (accountPortfolioData != null) {
      return accountPortfolioData;
    }
  }

  Future<dynamic> getAccountInstrumentTransactionData(
      {required String accountNumber}) async {
    dynamic accountInstrumentTransactionData;
    if (accountNumber.contains("local")) {
      accountInstrumentTransactionData = await getLocalInstrumentTransactions();
    } else {
      String url = '$indexaURL/accounts/$accountNumber/instrument-transactions';
      NetworkHelper networkHelper = NetworkHelper(url, token);
      try {
        accountInstrumentTransactionData = await networkHelper.getData();
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    }
    if (accountInstrumentTransactionData != null) {
      return accountInstrumentTransactionData;
    }
  }

  Future<dynamic> getAccountCashTransactionData(
      {required String accountNumber}) async {
    dynamic accountCashTransactionData;
    if (accountNumber.contains("local")) {
      accountCashTransactionData = await getLocalCashTransactions();
    } else {
      String url = '$indexaURL/accounts/$accountNumber/cash-transactions';

      NetworkHelper networkHelper = NetworkHelper(url, token);
      try {
        accountCashTransactionData = await networkHelper.getData();
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    }
    if (accountCashTransactionData != null) {
      return accountCashTransactionData;
    }
  }

  Future<dynamic> getAccountPendingTransactionData(
      {required String accountNumber}) async {
    dynamic accountPendingTransactionData;
    if (accountNumber.contains("local")) {
      accountPendingTransactionData = await getLocalPendingTransactions();
    } else {
      String url = '$indexaURL/accounts/$accountNumber/pending-transactions';
      NetworkHelper networkHelper = NetworkHelper(url, token);
      try {
        accountPendingTransactionData = await networkHelper.getData();
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    }
    if (accountPendingTransactionData != null) {
      return accountPendingTransactionData;
    }
  }

  Future<Account> populateAccountData(
      {required BuildContext context, required String accountNumber}) async {
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
