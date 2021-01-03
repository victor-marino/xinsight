import '../services/networking.dart';
const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
  final String token;

  IndexaData({this.token});

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<String> userAccounts = List<String>();
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var userData = await networkHelper.getData();
      if (userData != null) {
        for (var account in userData['accounts']) {
          userAccounts.add(account['account_number'].toString());
        }
        userAccounts.add(userAccounts.last);
        print(userAccounts);
        return userAccounts;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> getAccountPerformanceData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber/performance';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    try {
      var accountPerformanceData = await networkHelper.getData();
      //print('performanceData: ' + accountPerformanceData.toString());
      if (accountPerformanceData != null) {
        return accountPerformanceData;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> getAccountPortfolioData(accountNumber) async {
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
      return null;
    }
  }
}