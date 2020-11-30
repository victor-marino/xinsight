import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/screens/projection_screen.dart';
import 'evolution_screen.dart';
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

  bool reloading = false;

  Future<void> loadData() {
    setState(() {
      accountData = getAccountData(widget.token);
    });
    print(accountData);
    return accountData;
  }

  void reloadData() async {
    setState(() {
      reloading = true;
    });
    await loadData();
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = 0;
  }

  static Future<Account> getAccountData(String token) async {
    Account currentAccount;
    IndexaData indexaData = IndexaData(token: token);
    var userAccounts = await indexaData.getUserAccounts();
    var currentAccountPerformanceData =
        await indexaData.getAccountPerformanceData(userAccounts[0]);
    var currentAccountPortfolioData =
        await indexaData.getAccountPortfolioData(userAccounts[0]);
    currentAccount = Account(
        accountPerformanceData: currentAccountPerformanceData,
        accountPortfolioData: currentAccountPortfolioData);

    return currentAccount;
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.99);
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
            if (snapshot.connectionState == ConnectionState.done) {
              reloading = false;
            }
            if (snapshot.hasData) {
              child = PageView(
                controller: _pageController,
                //physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  HomeScreen(accountData: snapshot.data, loadData: loadData),
                  EvolutionScreen(
                      accountData: snapshot.data, loadData: loadData),
                  ProjectionScreen(
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
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = value;
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}
