import "package:indexax/tools/networking.dart";
import "package:indexax/models/account.dart";
import "package:flutter/material.dart";

const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
  // Class that fetches account data from API endpoint
  // Commented lines below can help test switching between multiple accounts.
  // They also make some values change every second, which allows for easier
  // testing of some reload/refresh functions as well.
  // You need to:
  // 1. Uncomment said lines
  // 2. Replace 'XXXXXXXX' with a valid account number (e.g.: yours)
  // 3. Comment out the real lines they
  
  final String? token;

  IndexaData({this.token});

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<Map<String, String>> userAccounts = [];
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var userData = await networkHelper.getData();
      if (userData != null) {
        for (var account in userData['accounts']) {
          if (account['status'].toString() == "active") {
            userAccounts.add({
              "number": account['account_number'].toString(),
              "type": account['type'].toString()
            });
          }
        }
        //userAccounts.add({"number": "Test", "type": "pension"});
        return userAccounts;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }
  
  Future<dynamic> getAccountInfo({required String accountNumber}) async {
    //String url = '$indexaURL/accounts/XXXXXXXX';
    String url = '$indexaURL/accounts/$accountNumber';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountInfo = await networkHelper.getData();
      if (accountInfo != null && accountNumber != "Test") {
        return accountInfo;
      } else if (accountInfo != null && accountNumber == "Test") {
        accountInfo['account_number'] = 'Test';
        accountInfo['type'] = 'pension';
        return accountInfo;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> getAccountPerformanceData(
      {required String accountNumber}) async {
    //String url = '$indexaURL/accounts/XXXXXXXX/performance';
    String url = '$indexaURL/accounts/$accountNumber/performance';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountPerformanceData = await networkHelper.getData();
      /* Provide fake, time-bound numbers if we're using a "Test" account.
      This can be useful to check if 'reload' functions are really reloading data */
      if (accountPerformanceData != null && accountNumber != "Test") {
        return accountPerformanceData;
      } else if (accountPerformanceData != null && accountNumber == "Test") {
        //accountPerformanceData['return']['total_amount'] = 9999.99;
        accountPerformanceData['return']['total_amount'] =
            DateTime.now().second;
        accountPerformanceData['return']['investment'] = 1000.00;
        return accountPerformanceData;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> getAccountPortfolioData(
      {required String accountNumber}) async {
    //String url = '$indexaURL/accounts/XXXXXXXX/portfolio';
    String url = '$indexaURL/accounts/$accountNumber/portfolio';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountPortfolioData = await networkHelper.getData();
      if (accountPortfolioData != null) {
        return accountPortfolioData;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> getAccountInstrumentTransactionData(
      {required String accountNumber}) async {
    //String url = '$indexaURL/accounts/XXXXXXXX/instrument-transactions';
    String url = '$indexaURL/accounts/$accountNumber/instrument-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountInstrumentTransactionData = await networkHelper.getData();
      if (accountInstrumentTransactionData != null) {
        return accountInstrumentTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> getAccountCashTransactionData(
      {required String accountNumber}) async {
    //String url = '$indexaURL/accounts/XXXXXXXX/cash-transactions';
    String url = '$indexaURL/accounts/$accountNumber/cash-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountCashTransactionData = await networkHelper.getData();
      if (accountCashTransactionData != null) {
        return accountCashTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> getAccountPendingTransactionData(
      {required String accountNumber}) async {
    //String url = '$indexaURL/accounts/XXXXXXXX/pending-transactions';
    String url = '$indexaURL/accounts/$accountNumber/pending-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountPendingTransactionData = await networkHelper.getData();
      if (accountPendingTransactionData != null) {
        return accountPendingTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
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
    } on Exception catch (e) {
      throw (e);
    }
    return currentAccount;
  }
}
