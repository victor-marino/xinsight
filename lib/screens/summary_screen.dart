import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import '../services/indexa_data.dart';
import '../models/account.dart';
import '../tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/account_summary.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/portfolio_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_legend.dart';

const int nbsp = 0x00A0;

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Future<Account> accountData;
  RefreshController _refreshController =
      RefreshController(
          initialRefresh: true);
  void _onRefresh() async {
    // monitor network fetch
    await loadData();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> loadData() {
    setState(() {
      accountData = getAccountData();
    });
    return accountData;
  }

  static Future<Account> getAccountData() async {
    IndexaDataModel indexaData = IndexaDataModel();
    var userAccounts = await indexaData.getUserAccounts();
    var currentAccountPerformanceData =
        await indexaData.getAccountPerformanceData(userAccounts[0]);
    var currentAccountPortfolioData =
        await indexaData.getAccountPortfolioData(userAccounts[0]);
    Account currentAccount = Account(
        accountPerformanceData: currentAccountPerformanceData,
        accountPortfolioData: currentAccountPortfolioData);
    return currentAccount;
  }

  @override
  void initState() {
    super.initState();
//    if (accountData == null) {
//      loadData();
//    }
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
              child: Text(
                'Inicio',
                style: kTitleTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: FutureBuilder<Account>(
                    future: accountData,
                    builder: (BuildContext context,
                        AsyncSnapshot<Account> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        child = Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              ReusableCard(
                                childWidget:
                                    AccountSummary(accountData: snapshot.data),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ReusableCard(
                                childWidget: AmountsChart(
                                    amountsSeries: snapshot.data.amountsSeries),
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
                                            snapshot.data.portfolioData),
                                    PortfolioChartLegend(
                                        portfolioData:
                                            snapshot.data.portfolioData),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        child = Text("Error loading data");
                      } else {
                        child = Container();
                      }
                      return child;
                    },
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
