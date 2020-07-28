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
import 'package:syncfusion_flutter_charts/charts.dart';

const int nbsp = 0x00A0;

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Future<Account> accountData;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
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

  @override
  void initState() {
    super.initState();
  }

  static Future<Account> getAccountData() async {
    IndexaDataModel indexaData = IndexaDataModel();
    var userAccounts = await indexaData.getUserAccounts();
    var currentAccountData = await indexaData.getAccountData(userAccounts[0]);
    Account currentAccount = Account(accountData: currentAccountData);
    return currentAccount;
  }

  @override
  Widget build(BuildContext context) {
    final List<PortfolioDataPoint> chartData = [
      PortfolioDataPoint(
          instrumentName: 'Vanguard Global Stk Idx Eur -Ins',
          amount: 1249.73,
          color: Colors.redAccent),
      PortfolioDataPoint(
          instrumentName: 'Vanguard Global Bnd Idx Eur -Ins',
          amount: 1171.96,
          color: Colors.blue),
      PortfolioDataPoint(
          instrumentName: 'Efectivo', amount: 17.00, color: Colors.grey),
    ];
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
                                  childWidget: AccountSummary(
                                      accountData: snapshot.data),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ReusableCard(
                                  childWidget: AmountsChart(
                                      amountsSeries:
                                          snapshot.data.amountsSeries),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ReusableCard(
                                  childWidget: Container(
                                    height: 300,
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        // Renders doughnut chart
                                        DoughnutSeries<PortfolioDataPoint,
                                            String>(
                                          dataSource: chartData,
                                          pointColorMapper:
                                              (PortfolioDataPoint data, _) =>
                                                  data.color,
                                          xValueMapper:
                                              (PortfolioDataPoint data, _) =>
                                                  data.instrumentName,
                                          yValueMapper:
                                              (PortfolioDataPoint data, _) =>
                                                  data.amount,
                                        ),
                                      ],
                                    ),
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
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
