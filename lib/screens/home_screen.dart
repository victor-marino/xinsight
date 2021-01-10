import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import '../models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/account_summary.dart';
import 'package:indexa_dashboard/widgets/account_summary_primary.dart';
import 'package:indexa_dashboard/widgets/account_summary_secondary.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/reusable_secondary_card.dart';
import 'package:indexa_dashboard/widgets/portfolio_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_legend.dart';
import 'package:indexa_dashboard/widgets/profit_popup.dart';
import 'package:indexa_dashboard/widgets/build_account_switcher.dart';
import 'package:indexa_dashboard/models/account_dropdown_items.dart';
import 'package:indexa_dashboard/widgets/settings_button.dart';

const int nbsp = 0x00A0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  Account accountData;
  Function refreshData;
  int currentAccountNumber;
  List<DropdownMenuItem> dropdownItems = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    accountData = await refreshData(currentAccountNumber);
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
  
  @override
  void initState() {
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    dropdownItems = AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Inicio',
                    style: kTitleTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  buildAccountSwitcher(currentAccountNumber: currentAccountNumber, currentPage: currentPage, accountDropdownItems: dropdownItems, reloadPage: widget.reloadPage),
                  SettingsButton(),
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      verticalDirection: VerticalDirection.up,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
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
                        SizedBox(
                          height: 20,
                        ),
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              PortfolioChart(
                                  portfolioData: accountData.portfolioData),
                              PortfolioChartLegend(
                                  portfolioData: accountData.portfolioData),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ReusableSecondaryCard(
                            childWidget: AccountSummarySecondary(accountData: accountData),
                          ),
                        ),
//                        SizedBox(
//                          height: 10.0,
//                        ),
                        ReusableCard(
                          childWidget: AccountSummaryPrimary(accountData: accountData),
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
