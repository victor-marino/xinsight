import '../services/networking.dart';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdXRoX2J5IjoiYXBpK2luZGV4YV9vMiIsImVuZHBvaW50IjoiaHR0cDpcL1wvYXBpLmluZGV4YWNhcGl0YWwuY29tIiwiaWF0IjoxNTkzNTkxNTk3LCJpc3MiOiJJbmRleGEgQ2FwaXRhbCIsInN1YiI6InZpY3Rvcm1hcmlub0BnbWFpbC5jb20ifQ.w9uteOcIV15cX1kH8hzmCMBKvv5ufwqcC_jn58Vy0aA';
const indexaURL = 'https://api.indexacapital.com';

class IndexaDataModel {

  Future<dynamic> getUserAccounts() async {
    String url = '$indexaURL/users/me';
    List<String> userAccounts = List<String>();
    NetworkHelper networkHelper = NetworkHelper(url, token);
    var userData = await networkHelper.getData();
    for (var account in userData['accounts']) {
      userAccounts.add(account['account_number'].toString());
      //print(account['account_number']);
    }
    return userAccounts;
  }

  Future<dynamic> getAccountData(accountNumber) async {
    String url = '$indexaURL/accounts/$accountNumber';
    double totalAmount;
    NetworkHelper networkHelper = NetworkHelper(url, token);
    var accountData = await networkHelper.getData();
    totalAmount = accountData['total_amount'];
    return totalAmount;
  }
//
//  Future<dynamic> getLocationWeather() async {
//    Location location = Location();
//    await location.getCurrentLocation();
//
//    String url = '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric';
//
//    NetworkHelper networkHelper = NetworkHelper(url);
//    var weatherData = await networkHelper.getData();
//
//    return weatherData;
//  }

}