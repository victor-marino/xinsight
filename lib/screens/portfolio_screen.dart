import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:indexax/widgets/portfolio_screen/asset_list.dart';
import 'package:indexax/models/account.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    super.key,
    required this.accountData,
    required this.userAccounts,
    required this.landscapeOrientation,
    required this.availableWidth,
    required this.refreshData,
    required this.currentAccountIndex,
  });
  final Account accountData;
  final List<Map<String, String>> userAccounts;
  final bool landscapeOrientation;
  final double availableWidth;
  final Function refreshData;
  final int currentAccountIndex;

  @override
  PortfolioScreenState createState() => PortfolioScreenState();
}

class PortfolioScreenState extends State<PortfolioScreen>
    with AutomaticKeepAliveClientMixin<PortfolioScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Couldn't refresh data");
        print(e);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
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
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AssetList(
                                portfolioData: widget.accountData.portfolioData,
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
