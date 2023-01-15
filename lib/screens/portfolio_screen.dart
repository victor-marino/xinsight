// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/widgets/portfolio_screen/asset_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/account.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    Key? key,
    required this.accountData,
    required this.userAccounts,
    required this.landscapeOrientation,
    required this.availableWidth,
    required this.refreshData,
    required this.currentAccountIndex,
  }) : super(key: key);
  final Account? accountData;
  final List<Map<String, String>>? userAccounts;
  final bool landscapeOrientation;
  final double availableWidth;
  final Function refreshData;
  final int currentAccountIndex;

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with AutomaticKeepAliveClientMixin<PortfolioScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
      _refreshController.refreshCompleted();
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: widget.landscapeOrientation && widget.availableWidth > 1000
                ? widget.availableWidth * 0.7
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AssetList(
                                portfolioData:
                                    widget.accountData!.portfolioData,
                                landscapeOrientation:
                                    widget.landscapeOrientation)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
