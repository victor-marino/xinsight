import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import '../models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/account_summary.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/portfolio_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_legend.dart';
import 'package:indexa_dashboard/widgets/profit_popup.dart';

const int nbsp = 0x00A0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
    this.accountData,
    this.userAccounts,
    this.loadData,
  }) : super(key: key);
  final Account accountData;
  final List<String> userAccounts;
  final Function loadData;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentAccountNumber = 0;
  List<DropdownMenuItem> accountDropdownItems = [];


  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void manualRefresh(int accountNumber) {
    currentAccountNumber = accountNumber;
    setState(() {
      _refreshController.requestRefresh();
    });
    //_onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    await widget.loadData(currentAccountNumber);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    for(var account in widget.userAccounts) {
      accountDropdownItems.add(
        DropdownMenuItem(
          child: Text((accountDropdownItems.length + 1).toString() + ". " + account),
          value: accountDropdownItems.length,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inicio',
                    style: kTitleTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  DropdownButton(
                      value: 1,
                      items: accountDropdownItems,
                      onChanged: (value) {
                        manualRefresh(value);
                        accountDropdownItems = [];
                      }),
                  MaterialButton(
                      child: Text("Manual refresh"),
                      onPressed: () {
                        manualRefresh(0);
                      }),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
//                        SizedBox(
//                          height: 10.0,
//                        ),
                        ReusableCard(
                          childWidget:
                              AccountSummary(accountData: widget.accountData),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              PortfolioChart(
                                  portfolioData:
                                      widget.accountData.portfolioData),
                              PortfolioChartLegend(
                                  portfolioData:
                                      widget.accountData.portfolioData),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
