import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/screens/performance_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import '../services/indexa_data.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';
import '../widgets/bottom_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  RootScreen({this.token});
  final String token;

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  PageController _pageController;

  Future<Account> accountData;

  Future<void> loadData() {
    setState(() {
      accountData = getAccountData(widget.token);
    });
    return accountData;
  }

  static Future<Account> getAccountData(String token) async {
    IndexaData indexaData = IndexaData(token: token);
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
    _pageController = PageController(initialPage: 0, viewportFraction: 0.99);
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = 0;
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
        body: FutureBuilder<Account>(
          future: accountData,
          builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = PageView(
                controller: _pageController,
                //physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  HomeScreen(accountData: snapshot.data, loadData: loadData),
                  PerformanceScreen(
                      accountData: snapshot.data, loadData: loadData),
                  SettingsScreen(),
                ],
                onPageChanged: (page) {
                  Provider.of<BottomNavigationBarProvider>(context,
                          listen: false)
                      .currentIndex = page;
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              child = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.cloud_off,
                    ),
                    Text("Error loading data"),
                  ],
                ),
              );
            } else {
              child = Center(child: CircularProgressIndicator());
            }
            return child;
          },
        ),
        bottomNavigationBar: MyBottomNavigationBar(onTapped: _onTappedBar),
      ),
    );
  }

  void _onTappedBar(int value) {
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = value;
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}
