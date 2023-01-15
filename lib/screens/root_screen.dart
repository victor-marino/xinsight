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
import 'package:indexax/tools/indexa_data.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/theme_operations.dart' as theme_operations;
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/current_account_indicator.dart';
import '../widgets/page_header.dart';
import '../widgets/settings_popup_menu.dart';
import 'login_screen.dart';

// Base screen where all other screens are loaded after loggin in

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
  late final IndexaData indexaData = IndexaData(token: token);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  late PageController _pageController;

  List<Map<String, String>> _userAccounts = [];
  Future<Account>? _accountData;

  bool _reloading = false;

  bool landscapeOrientation = false;
  late double availableWidth;
  late double availableHeight;
  double topPadding = 0;

  Future<void> _loadData({required int accountIndex}) async {
    // Main function that is called when account data is loaded
    try {
        // Avoid loading the account list again if we already have it (e.g.: 
        // because we're reloading the screen after the user switches accounts)
      if (_userAccounts.length == 0) {
        _userAccounts = await widget.indexaData.getUserAccounts();
      }
      _accountData = widget.indexaData.populateAccountData(
          context: context,
          accountNumber: _userAccounts[accountIndex]['number']!);
      await _accountData;
      setState(() {});
    } on Exception catch (e) {
      print(e.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  LoginScreen(errorMessage: e.toString())),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> _refreshData({required int accountIndex}) async {
    // Called after account data is downloaded
    try {
      _accountData = widget.indexaData.populateAccountData(
          context: context,
          accountNumber: _userAccounts[accountIndex]['number']!);
      await _accountData;
      setState(() {});
    } on Exception catch (e) {
      snackbar.showInSnackBar(context, e.toString());
    }
  }

  void _retryLoadData() async {
    // Called when "retry" button is pushed after a loading error
    setState(() {
      _reloading = true;
    });
    await _loadData(accountIndex: widget.accountIndex);
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .currentIndex = widget.pageIndex;
  }

  void _reloadPage(int accountIndex, int pageIndex) async {
    // Called when the user switches to a different account
    pageIndex = _pageController.page!.toInt();
    print(pageIndex);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RootScreen(
                token: widget.token,
                accountIndex: accountIndex,
                pageIndex: pageIndex,
                previousUserAccounts: _userAccounts)));
  }

  void _onTappedBar(int value) {
    // Called when the user taps the bottom navigation bar
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    // Update theme based on system theme
    theme_operations.updateTheme(context);

    if (widget.previousUserAccounts != null) {
      // If we're just reloading the screen (e.g.: when the user switches
      // between accounts), we reuse the existing account list.
      _userAccounts = widget.previousUserAccounts!;
    }
    _loadData(accountIndex: widget.accountIndex);

    _pageController =
        PageController(initialPage: widget.pageIndex, viewportFraction: 1);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check if system theme has changed when app is resumed
      theme_operations.updateTheme(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    availableWidth = MediaQuery.of(context).size.width;
    availableHeight = MediaQuery.of(context).size.height;

    if (availableHeight <= availableWidth) {
      landscapeOrientation = true;
    } else {
      landscapeOrientation = false;
    }

    // Fix a bug in iOS where top padding isn't right in landscape mode
    if (landscapeOrientation && Platform.isIOS) {
      topPadding = 10;
    } else {
      topPadding = 0;
    }

    return FutureBuilder<Account>(
      future: _accountData,
      builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          _reloading = false;
        }
        if (snapshot.hasData) {
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
                          accountType: snapshot.data!.accountType)
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
                        accountType: snapshot.data!.accountType),
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
                      userAccounts: _userAccounts,
                      currentAccountIndex: widget.accountIndex,
                      currentPage: widget.pageIndex,
                      reloadPage: _reloadPage),
                ),
              ],
            ),
            body: PageView(
              controller: _pageController,
              children: <Widget>[
                OverviewScreen(
                    accountData: snapshot.data!,
                    userAccounts: _userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: _refreshData,
                    currentAccountIndex: widget.accountIndex),
                PortfolioScreen(
                    accountData: snapshot.data!,
                    userAccounts: _userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: _refreshData,
                    currentAccountIndex: widget.accountIndex),
                EvolutionScreen(
                    accountData: snapshot.data!,
                    userAccounts: _userAccounts,
                    refreshData: _refreshData,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    currentAccountIndex: widget.accountIndex),
                TransactionsScreen(
                    accountData: snapshot.data!,
                    userAccounts: _userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: _refreshData,
                    currentAccountIndex: widget.accountIndex),
                ProjectionScreen(
                    accountData: snapshot.data!,
                    userAccounts: _userAccounts,
                    landscapeOrientation: landscapeOrientation,
                    availableWidth: availableWidth,
                    refreshData: _refreshData,
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
          if (_reloading) {
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
                    onPressed: _retryLoadData,
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
