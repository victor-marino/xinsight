import '../services/networking.dart';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdXRoX2J5IjoiYXBpK2luZGV4YV9vMiIsImVuZHBvaW50IjoiaHR0cDpcL1wvYXBpLmluZGV4YWNhcGl0YWwuY29tIiwiaWF0IjoxNTkzNTkxNTk3LCJpc3MiOiJJbmRleGEgQ2FwaXRhbCIsInN1YiI6InZpY3Rvcm1hcmlub0BnbWFpbC5jb20ifQ.w9uteOcIV15cX1kH8hzmCMBKvv5ufwqcC_jn58Vy0aA';
const indexaURL = 'https://api.indexacapital.com';

class IndexaData {

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