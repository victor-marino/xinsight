import '../services/networking.dart';
const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
  final String token;

  IndexaData({this.token});

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<String> userAccounts = [];
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var userData = await networkHelper.getData();
      if (userData != null) {
        for (var account in userData['accounts']) {
          if (account['status'].toString() == "active") {
            userAccounts.add(account['account_number'].toString());
          }
        }
        //userAccounts.add("Test");
        return userAccounts;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
      return null;
    }
  }

  Future<dynamic> getAccountInfo(accountNumber) async {
    //String url = '$indexaURL/accounts/FHGNB6LM';
    String url = '$indexaURL/accounts/$accountNumber';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountInfo = await networkHelper.getData();
      //print('performanceData: ' + accountPerformanceData.toString());
      if (accountInfo != null) {
        //print(accountPerformanceData);
        return accountInfo;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }

  Future<dynamic> getAccountPerformanceData(accountNumber) async {
    //String url = '$indexaURL/accounts/FHGNB6LM/performance';
    String url = '$indexaURL/accounts/$accountNumber/performance';
    NetworkHelper networkHelper = NetworkHelper(url, token);
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
      throw(e);
    }
  }

  Future<dynamic> getAccountPortfolioData(accountNumber) async {
    //String url = '$indexaURL/accounts/FHGNB6LM/portfolio';
    String url = '$indexaURL/accounts/$accountNumber/portfolio';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountPortfolioData = await networkHelper.getData();
      //print('portfolioData: ' + accountPortfolioData.toString());
      if (accountPortfolioData != null) {
        return accountPortfolioData;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }

  Future<dynamic> getAccountInstrumentTransactionData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber/instrument-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountInstrumentTransactionData = await networkHelper.getData();
      //print('accountInstrumentTransactionData: ' + accountInstrumentTransactionData.toString());
      if (accountInstrumentTransactionData != null) {
        return accountInstrumentTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }

  Future<dynamic> getAccountCashTransactionData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber/cash-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountCashTransactionData = await networkHelper.getData();
      //print('accountCashTransactionData: ' + accountCashTransactionData.toString());
      if (accountCashTransactionData != null) {
        return accountCashTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }

  Future<dynamic> getAccountPendingTransactionData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber/pending-transactions';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountPendingTransactionData = await networkHelper.getData();
      //print('accountPendingTransactionData: ' + accountPendingTransactionData.toString());
      if (accountPendingTransactionData != null) {
        return accountPendingTransactionData;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }

  Future<dynamic> getPerformanceStatsData(product, risk, size) async {
    String url = '$indexaURL/stats/performance?product=$product&risk=$risk&size=$size';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var performanceStatsData = await networkHelper.getData();
      print('performanceStatsData: ' + performanceStatsData.toString());
      if (performanceStatsData != null) {
        return performanceStatsData;
      }
    } on Exception catch (e) {
      print(e);
      throw(e);
    }
  }
}