import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/screens/home_screen.dart';
import 'package:indexa_dashboard/screens/evolution_screen.dart';
import 'package:indexa_dashboard/screens/projection_screen.dart';
import 'package:indexa_dashboard/screens/planning_screen.dart';
import 'package:indexa_dashboard/screens/stats_screen.dart';
import 'settings_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import '../services/indexa_data.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';
import '../widgets/bottom_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  RootScreen({
    this.token,
    this.accountNumber,
    this.pageNumber,
  });
  final String token;
  final int accountNumber;
  final int pageNumber;

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  PageController _pageController;

  List<String> userAccounts = [];
  Future<Account> accountData;

  bool reloading = false;

  Future<void> loadData(int accountNumber) async {
    userAccounts = await getUserAccounts(widget.token);
    setState(() {
      accountData = getAccountData(widget.token, accountNumber);
    });
    return accountData;
  }

  Future<void> refreshData(int accountNumber) {
    //accountData = getAccountData(widget.token, accountNumber);
    accountData = getAccountData(widget.token, accountNumber);
    return accountData;
  }

  void reloadData() async {
    setState(() {
      reloading = true;
    });
    await loadData(widget.pageNumber);
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = widget.pageNumber;
  }

  void reloadPage(int accountNumber, int pageNumber) async {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) => RootScreen(token: widget.token, accountNumber: accountNumber, pageNumber: pageNumber)));
  }

  void loadSettings() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) => SettingsScreen())
    );
  }
  Future<List<String>> getUserAccounts(String token) async {
    IndexaData indexaData = IndexaData(token: token);
    var userAccounts = await indexaData.getUserAccounts();
    return userAccounts;
  }

  static Future<Account> getAccountData(String token, int accountNumber) async {
    Account currentAccount;
    IndexaData indexaData = IndexaData(token: token);
    var userAccounts = await indexaData.getUserAccounts();
    var currentAccountInfo =
    await indexaData.getAccountInfo(userAccounts[accountNumber]);
    var currentAccountPerformanceData =
        await indexaData.getAccountPerformanceData(userAccounts[accountNumber]);
    var currentAccountPortfolioData =
        await indexaData.getAccountPortfolioData(userAccounts[accountNumber]);
    currentAccount = Account(accountInfo: currentAccountInfo,
        accountPerformanceData: currentAccountPerformanceData,
        accountPortfolioData: currentAccountPortfolioData);
    return currentAccount;
  }

  @override
  void initState() {
    super.initState();
    loadData(widget.accountNumber);
    //_pageController = PageController(initialPage: widget.pageNumber, viewportFraction: 0.99);
    _pageController = PageController(initialPage: widget.pageNumber, viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SyncfusionLicense.registerLicense(SYNCFUSION_LICENSE);

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
            if (snapshot.connectionState == ConnectionState.done) {
              reloading = false;
            }
            if (snapshot.hasData) {
              print(userAccounts);
              child = PageView(
                controller: _pageController,
                //physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  HomeScreen(accountData: snapshot.data, userAccounts: userAccounts, refreshData: refreshData, reloadPage: reloadPage, currentAccountNumber: widget.accountNumber),
                  EvolutionScreen(
                      accountData: snapshot.data, userAccounts: userAccounts, refreshData: refreshData, reloadPage: reloadPage, currentAccountNumber: widget.accountNumber),
                  ProjectionScreen(
                      accountData: snapshot.data, userAccounts: userAccounts, refreshData: refreshData, reloadPage: reloadPage, currentAccountNumber: widget.accountNumber),
                  PlanningScreen(
                      accountData: snapshot.data, userAccounts: userAccounts, refreshData: refreshData, reloadPage: reloadPage, currentAccountNumber: widget.accountNumber),
                  StatsScreen(
                      accountData: snapshot.data, userAccounts: userAccounts, refreshData: refreshData, reloadPage: reloadPage, currentAccountNumber: widget.accountNumber),
                ],
                onPageChanged: (page) {
                  Provider.of<BottomNavigationBarProvider>(context,
                          listen: false)
                      .currentIndex = page;
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              if (reloading) {
                child = Center(child: CircularProgressIndicator());
              } else {
                child = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.cloud_off,
                      ),
                      Text("Error loading data"),
                      MaterialButton(
                        child: Text(
                          'REINTENTAR',
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: reloadData,
                      )
                    ],
                  ),
                );
              }
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
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}
