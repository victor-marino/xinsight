import 'package:flutter/foundation.dart';
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
import 'package:indexax/tools/profit_loss_chart_provider.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/theme_operations.dart' as theme_operations;
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';
import '../tools/private_mode_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/current_account_indicator.dart';
import '../widgets/page_header.dart';
import '../widgets/settings_popup_menu.dart';
import 'login_screen.dart';
import '../tools/local_authentication.dart';
import 'package:indexax/tools/evolution_chart_provider.dart';

// Base screen where all other screens are loaded after loggin in

class RootScreen extends StatefulWidget {
  RootScreen({
    Key? key,
    required this.token,
    required this.accountIndex,
    required this.pageIndex,
    this.previousUserAccounts,
  }) : super(key: key);

  final String token;
  final int accountIndex;
  final int pageIndex;
  final List<Map<String, String>>? previousUserAccounts;
  late final IndexaData indexaData = IndexaData(token: token);

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  late PageController _pageController;

  List<Map<String, String>> _userAccounts = [];
  Future<Account>? _accountData;

  bool _reloading = false;

  bool landscapeOrientation = false;
  late double availableWidth;
  late double availableHeight;
  double topPadding = 0;

  bool hiddenAmounts = false;

  Future<void> _loadData({required int accountIndex}) async {
    // Main function that is called when account data is loaded
    try {
      // Avoid loading the account list again if we already have it (e.g.:
      // because we're reloading the screen after the user switches accounts)
      if (_userAccounts.isEmpty) {
        _userAccounts = await widget.indexaData.getUserAccounts();
      }
      if (_userAccounts.isNotEmpty && context.mounted) {
        _accountData = widget.indexaData.populateAccountData(
            context: context,
            accountNumber: _userAccounts[accountIndex]['number']!);
        await _accountData;
        setState(() {});
      } else {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(
                      errorMessage: "login_screen.no_active_accounts".tr())),
              (Route<dynamic> route) => false);
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    LoginScreen(errorMessage: e.toString())),
            (Route<dynamic> route) => false);
      }
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
      if (context.mounted) snackbar.showInSnackBar(context, e.toString());
    }
  }

  void _retryLoadData() async {
    // Called when "retry" button is pushed after a loading error
    setState(() {
      _reloading = true;
    });
    await _loadData(accountIndex: widget.accountIndex);
    if (!mounted) return;
    context.read<BottomNavigationBarProvider>().currentIndex;
  }

  void _reloadPage(int accountIndex, int pageIndex) async {
    // Called when the user switches to a different account
    pageIndex = _pageController.page!.toInt();
    if (kDebugMode) {
      print(pageIndex);
    }
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
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _togglePrivateMode() async {
    if (context.read<PrivateModeProvider>().privateModeEnabled) {
      bool isAuthenticated = await authenticateUserLocally(context);
      if (isAuthenticated && context.mounted) {
        context.read<PrivateModeProvider>().privateModeEnabled = false;
        snackbar.showInSnackBar(
            context, "root_screen.private_mode_disabled".tr());
      }
    } else {
      context.read<PrivateModeProvider>().privateModeEnabled = true;
      snackbar.showInSnackBar(context, "root_screen.private_mode_enabled".tr());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

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
                    Row(
                      children: [
                        const PageHeader(),
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: IconButton(
                            onPressed: _togglePrivateMode,
                            icon: Icon(context
                                    .watch<PrivateModeProvider>()
                                    .privateModeEnabled
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded),
                            color: context
                                    .watch<PrivateModeProvider>()
                                    .privateModeEnabled
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withAlpha(150),
                            splashRadius: 20,
                            iconSize: 20,
                          ),
                        )
                      ],
                    ),
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
                    child: const SizedBox(width: 10),
                  ),
                ],
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 15),
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
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider<EvolutionChartProvider>(
                        create: (_) => EvolutionChartProvider()),
                    ChangeNotifierProvider<ProfitLossChartProvider>(
                        create: (_) => ProfitLossChartProvider()),
                  ],
                  child: EvolutionScreen(
                      accountData: snapshot.data!,
                      userAccounts: _userAccounts,
                      refreshData: _refreshData,
                      landscapeOrientation: landscapeOrientation,
                      availableWidth: availableWidth,
                      currentAccountIndex: widget.accountIndex),
                ),
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
                context.read<BottomNavigationBarProvider>().currentIndex = page;
              },
            ),
            bottomNavigationBar: MyBottomNavigationBar(onTapped: _onTappedBar),
          );
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          if (_reloading) {
            child = const Center(child: CircularProgressIndicator());
          } else {
            child = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.error_outline),
                  Text(snapshot.error.toString()),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _retryLoadData,
                    child: Text(
                      'retry'.tr(),
                    ),
                  )
                ],
              ),
            );
          }
        } else {
          child = Container(
              color: Theme.of(context).colorScheme.background,
              child: const Center(child: CircularProgressIndicator()));
        }
        return child;
      },
    );
  }
}
