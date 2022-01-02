import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexa_dashboard/widgets/account_summary.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/portfolio_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_legend.dart';
import 'package:indexa_dashboard/widgets/profit_popup.dart';
import 'package:indexa_dashboard/models/account_dropdown_items.dart';
import 'package:indexa_dashboard/widgets/minimum_transfer_card.dart';
import 'package:indexa_dashboard/widgets/fee_free_amount_card.dart';

const int nbsp = 0x00A0;

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    Key key,
    this.accountData,
    this.userAccounts,
    this.refreshData,
    this.reloadPage,
    this.currentAccountNumber,
  }) : super(key: key);
  final Account accountData;
  final List<String> userAccounts;
  final Function refreshData;
  final Function reloadPage;
  final int currentAccountNumber;

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int currentPage = 0;
  Account accountData;
  Function refreshData;
  int currentAccountNumber;
  List<DropdownMenuItem> dropdownItems = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    try {
      accountData = await refreshData(currentAccountNumber);
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    dropdownItems =
        AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        ReusableCard(
                          childWidget: AccountSummary(accountData: accountData),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'portfolio_screen.distribution'.tr(),
                                style: kCardTitleTextStyle,
                              ),
                              PortfolioChart(
                                  portfolioData: accountData.portfolioData),
                              PortfolioChartLegend(
                                  portfolioDistribution:
                                      accountData.portfolioDistribution),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MinimumTransferCard(additionalCashNeededToTrade: widget.accountData.additionalCashNeededToTrade),
                                SizedBox(height: 5),
                                FeeFreeAmountCard(feeFreeAmount: widget.accountData.feeFreeAmount),
                              ],
                            ),
                            MaterialButton(
                              height: 40,
                              minWidth: 40,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              color: Colors.blue[600],
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ProfitPopUp());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}