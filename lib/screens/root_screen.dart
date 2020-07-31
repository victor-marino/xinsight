import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/screens/projection_screen.dart';
import 'summary_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import '../services/indexa_data.dart';

int _selectedIndex = 0;

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  PageController _pageController;
  Future<Account> accountData;

  Future<void> loadData() {
    setState(() {
      accountData = getAccountData();
    });
    return accountData;
  }

  static Future<Account> getAccountData() async {
    IndexaDataModel indexaData = IndexaDataModel();
    var userAccounts = await indexaData.getUserAccounts();
    var currentAccountPerformanceData =
        await indexaData.getAccountPerformanceData(userAccounts[0]);
    var currentAccountPortfolioData =
        await indexaData.getAccountPortfolioData(userAccounts[0]);
    Account currentAccount = Account(
        accountPerformanceData: currentAccountPerformanceData,
        accountPortfolioData: currentAccountPortfolioData);
    return currentAccount;
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SyncfusionLicense.registerLicense(SYNCFUSION_LICENSE);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).canvasColor,
          statusBarBrightness: Brightness.light, // iOS
          statusBarIconBrightness: Brightness.dark), // Android
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Inicio')),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), title: Text('Proyección')),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.compare_arrows), title: Text('Transactions'))
          ],
          onTap: _onTappedBar,
//          selectedItemColor: Colors.orange,
          currentIndex: _selectedIndex,

        ),
        body: FutureBuilder<Account>(
          future: accountData,
          builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = PageView(
                controller: _pageController,
                children: <Widget>[
                  SummaryScreen(accountData: snapshot.data, loadData: loadData),
                  ProjectionScreen(
                      accountData: snapshot.data, loadData: loadData),
                ],
                onPageChanged: (page) {
                  //print(page);
                  setState(() {
                    _selectedIndex = page;
                  });
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              child = Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.cloud_off,
                  ),
                  Text("Error loading data"),
                ],
              ));
            } else {
              child = Center(child: CircularProgressIndicator());
            }
            return child;
          },
        ),
      ),
    );
  }
  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.animateToPage(value, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}
