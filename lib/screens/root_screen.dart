import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/screens/evolution_screen.dart';
import 'package:indexax/screens/overview_screen.dart';
import 'package:indexax/screens/portfolio_screen.dart';
import 'package:indexax/screens/projection_screen.dart';
import 'package:indexax/screens/transactions_screen.dart';
import 'package:indexax/tools/theme_operations.dart' as theme_operations;
import 'package:provider/provider.dart';
import 'package:indexax/tools/indexa_operations.dart' as indexa_operations;
import '../tools/bottom_navigation_bar_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/current_account_indicator.dart';
import '../widgets/page_header.dart';
import '../widgets/settings_popup_menu.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class RootScreen extends StatefulWidget {
  RootScreen({
    required this.token,
    required this.accountIndex,
    required this.pageIndex,
    this.previousUserAccounts,
  });

  final String token;
  final int accountIndex;
  final int pageIndex;
  final List<Map<String, String>>? previousUserAccounts;

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  PageController? _pageController;

  List<Map<String, String>>? userAccounts = [];
  Account? currentAccount;
  Future<Account>? accountData;

  // List<DropdownMenuItem> dropdownItems =
  //     AccountDropdownItems(userAccounts: [""]).dropdownItems;

  bool reloading = false;

  Future<Future<Account>?> loadData(int accountIndex) async {
    try {
      userAccounts = await getUserAccounts(widget.token);
      setState(() {
        accountData =
            getAccountData(context, widget.token, accountIndex, currentAccount);
      });
      return accountData;
    } on Exception catch (e) {
      print(e.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  LoginScreen(errorMessage: e.toString())),
          (Route<dynamic> route) => false);
    }
    return null;
  }

  Future<void>? refreshData(int accountIndex) {
    accountData =
        getAccountData(context, widget.token, accountIndex, currentAccount);
    return accountData;
  }

  void reloadData() async {
    setState(() {
      reloading = true;
    });
    await loadData(widget.pageIndex);
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = widget.pageIndex;
  }

  void reloadPage(int accountIndex, int pageIndex) async {
    pageIndex = _pageController!.page!.toInt();
    print(pageIndex);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RootScreen(
                token: widget.token,
                accountIndex: accountIndex,
                pageIndex: pageIndex,
                previousUserAccounts: userAccounts)));
  }

  void loadSettingsScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));
  }

  Future<List<Map<String, String>>> getUserAccounts(String token) async {
    var userAccounts = await indexa_operations.getUserAccounts(token: token);
    // dropdownItems =
    //     AccountDropdownItems(userAccounts: userAccounts).dropdownItems;
    return userAccounts;
  }

  static Future<Account> getAccountData(BuildContext context, String token,
      int accountIndex, Account? currentAccount) async {
    //Account currentAccount;
    try {
      var userAccounts = await indexa_operations.getUserAccounts(token: token);
      var currentAccountInfo =
          await indexa_operations
          .getAccountInfo(token: token, accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountPerformanceData = await indexa_operations
          .getAccountPerformanceData(token: token, accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountPortfolioData = await indexa_operations
          .getAccountPortfolioData(token: token, accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountInstrumentTransactionData =
          await indexa_operations.getAccountInstrumentTransactionData(token: token,
              accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountCashTransactionData = await indexa_operations
          .getAccountCashTransactionData(token: token, accountNumber: userAccounts[accountIndex]['number']);
      var currentAccountPendingTransactionData =
          await indexa_operations.getAccountPendingTransactionData(token: token,
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

      return currentAccount;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print("Couldn't fetch account data");
      print(e);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  LoginScreen(errorMessage: e.toString())),
          (Route<dynamic> route) => false);
      throw (e);
    }
  }

  void _onTappedBar(int value) {
    _pageController!.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    theme_operations.updateTheme(context);

    if (widget.previousUserAccounts != null) {
      userAccounts = widget.previousUserAccounts;
    }
    loadData(widget.accountIndex);
    _pageController =
        PageController(initialPage: widget.pageIndex, viewportFraction: 1);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      theme_operations.updateTheme(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool landscapeOrientation = false;
    double availableWidth = MediaQuery.of(context).size.width;
    double availableHeight = MediaQuery.of(context).size.height;
    double topPadding = 0;

    if (availableHeight <= availableWidth) {
      landscapeOrientation = true;
    }

    if (landscapeOrientation && Platform.isIOS) {
      topPadding = 10;
    }

    return FutureBuilder<Account>(
      future: accountData,
      builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          reloading = false;
        }
        if (snapshot.hasData) {
          // print(userAccounts.toString());
          // bool landscapeOrientation = false;
          // double availableWidth = MediaQuery.of(context).size.width;
          // double availableHeight = MediaQuery.of(context).size.height;

          // if (availableHeight <= availableWidth) {
          //   landscapeOrientation = true;
          // }
          child = Scaffold(
            appBar: AppBar(
              titleSpacing: 20,
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              toolbarHeight: landscapeOrientation ? 40 + topPadding : 100,
              centerTitle: false,
              title: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(),
                    if (!landscapeOrientation) ...[
                      CurrentAccountIndicator(
                          accountNumber: snapshot.data!.accountNumber,
                          accountType: snapshot.data!.type)
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                if (landscapeOrientation) ...[
                  Padding(
                    padding: EdgeInsets.only(top: topPadding),
                    child: CurrentAccountIndicator(
                        accountNumber: snapshot.data!.accountNumber,
                        accountType: snapshot.data!.type),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: topPadding),
                    child: SizedBox(width: 10),
                  ),
                ],
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 15),
                  child: SettingsPopupMenu(
                      userAccounts: userAccounts,
                      currentAccountIndex: widget.accountIndex,
                      currentPage: widget.pageIndex,
                      reloadPage: reloadPage),
                ),
                //SizedBox(width: 10)
              ],
            ),
            body: PageView(
              controller: _pageController,
              children: <Widget>[
                OverviewScreen(
                    accountData: snapshot.data,
                    userAccounts: userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: refreshData,
                    reloadPage: reloadPage,
                    currentAccountIndex: widget.accountIndex),
                PortfolioScreen(
                    accountData: snapshot.data,
                    userAccounts: userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: refreshData,
                    reloadPage: reloadPage,
                    currentAccountIndex: widget.accountIndex),
                EvolutionScreen(
                    accountData: snapshot.data,
                    userAccounts: userAccounts,
                    refreshData: refreshData,
                    reloadPage: reloadPage,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    currentAccountIndex: widget.accountIndex),
                TransactionsScreen(
                    accountData: snapshot.data,
                    userAccounts: userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: refreshData,
                    reloadPage: reloadPage,
                    currentAccountIndex: widget.accountIndex),
                ProjectionScreen(
                    accountData: snapshot.data,
                    userAccounts: userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: refreshData,
                    reloadPage: reloadPage,
                    currentAccountIndex: widget.accountIndex),
              ],
              onPageChanged: (page) {
                Provider.of<BottomNavigationBarProvider>(context, listen: false)
                    .currentIndex = page;
              },
            ),
            bottomNavigationBar: MyBottomNavigationBar(onTapped: _onTappedBar),
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
                  Icon(Icons.error_outline),
                  Text(snapshot.error.toString()),
                  MaterialButton(
                    child: Text(
                      'retry'.tr(),
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
    );
  }
}
