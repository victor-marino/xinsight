import '../services/networking.dart';
const indexaURL = 'https://api.indexacapital.com';

class IndexaData {
  final String token;

  IndexaData({this.token});

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<String> userAccounts = List<String>();
    NetworkHelper networkHelper = NetworkHelper(url, token);
    var userData = await networkHelper.getData();
    for (var account in userData['accounts']) {
      userAccounts.add(account['account_number'].toString());
    }
    return userAccounts;
  }

  Future<dynamic> getAccountPerformanceData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber/performance';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    var accountPerformanceData = await networkHelper.getData();
    //print('performanceData: ' + accountPerformanceData.toString());
    return accountPerformanceData;
  }

  Future<dynamic> getAccountPortfolioData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber/portfolio';
    NetworkHelper networkHelper = NetworkHelper(url, token);
    var accountPortfolioData = await networkHelper.getData();
    //print('portfolioData: ' + accountPortfolioData.toString());
    return accountPortfolioData;
  }
}