import "package:indexax/tools/networking.dart";
import "package:indexax/models/account.dart";
import "package:flutter/material.dart";

const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
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
        userAccounts.add({"number": "Test", "type": "pension"});
        return userAccounts;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> getAccountInfo({required String accountNumber}) async {
    String url = '$indexaURL/accounts/FHGNB6LM';
    //String url = '$indexaURL/accounts/$accountNumber';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountInfo = await networkHelper.getData();
      //print('performanceData: ' + accountPerformanceData.toString());
      if (accountInfo != null && accountNumber != "Test") {
        //print(accountPerformanceData);
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
    String url = '$indexaURL/accounts/FHGNB6LM/performance';
    //String url = '$indexaURL/accounts/$accountNumber/performance';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountPerformanceData = await networkHelper.getData();
      //print('performanceData: ' + accountPerformanceData.toString());
      if (accountPerformanceData != null && accountNumber != "Test") {
        //print(accountPerformanceData);
        return accountPerformanceData;
      } else if (accountPerformanceData != null && accountNumber == "Test") {
        accountPerformanceData['return']['total_amount'] = 9999.99;
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
    String url = '$indexaURL/accounts/FHGNB6LM/portfolio';
    //String url = '$indexaURL/accounts/$accountNumber/portfolio';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountPortfolioData = await networkHelper.getData();
      //print('portfolioData: ' + accountPortfolioData.toString());
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
    String url = '$indexaURL/accounts/FHGNB6LM/instrument-transactions';
    //String url = '$indexaURL/accounts/$accountNumber/instrument-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountInstrumentTransactionData = await networkHelper.getData();
      //print('accountInstrumentTransactionData: ' + accountInstrumentTransactionData.toString());
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
    String url = '$indexaURL/accounts/FHGNB6LM/cash-transactions';
    //String url = '$indexaURL/accounts/$accountNumber/cash-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountCashTransactionData = await networkHelper.getData();
      //print('accountCashTransactionData: ' + accountCashTransactionData.toString());
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
    String url = '$indexaURL/accounts/FHGNB6LM/pending-transactions';
    //String url = '$indexaURL/accounts/$accountNumber/pending-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token!);
    try {
      var accountPendingTransactionData = await networkHelper.getData();
      //print('accountPendingTransactionData: ' + accountPendingTransactionData.toString());
      if (accountPendingTransactionData != null) {
        return accountPendingTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Account> populateAccountData(
      {required BuildContext context, required int accountIndex}) async {
    Account currentAccount;
    try {
      var userAccounts = await getUserAccounts();
      var currentAccountInfo = await getAccountInfo(
          accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountPerformanceData = await getAccountPerformanceData(
          accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountPortfolioData = await getAccountPortfolioData(
          accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountInstrumentTransactionData =
          await getAccountInstrumentTransactionData(
              accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountCashTransactionData =
          await getAccountCashTransactionData(
              accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountPendingTransactionData =
          await getAccountPendingTransactionData(
              accountNumber: userAccounts[accountIndex]['number']);
      currentAccount = Account(
          accountInfo: currentAccountInfo,
          accountPerformanceData: currentAccountPerformanceData,
          accountPortfolioData: currentAccountPortfolioData,
          accountInstrumentTransactionData:
              currentAccountInstrumentTransactionData,
          accountCashTransactionData: currentAccountCashTransactionData,
          accountPendingTransactionData: currentAccountPendingTransactionData);

      //print(currentAccount);

    } on Exception catch (e) {
      throw (e);
    }
    return currentAccount;
  }
}
