import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:indexa_dashboard/models/amounts_datapoint.dart';
import '../services/indexa_data.dart';
import '../models/account.dart';
import '../tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:fl_chart/fl_chart.dart';
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
    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'Account summary',
//        ),
//      ),
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: FutureBuilder<Account>(
                future: accountData,
                builder:
                    (BuildContext context, AsyncSnapshot<Account> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //SizedBox(
                          //  height: 10.0,
                          //),
                          Text(
                            'Inicio',
                            style: kTitleTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Card(
                            margin: EdgeInsets.all(0),
                            color: Colors.white,
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: IntrinsicHeight(
                                child: Row(
//                                crossAxisAlignment:
//                                    CrossAxisAlignment.baseline,
//                                textBaseline: TextBaseline.ideographic,
                                  children: <Widget>[
                                    Expanded(
                                      //flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'VALOR',
                                            textAlign: TextAlign.left,
                                            style: kCardTitleTextStyle,
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: getBalanceAsString(snapshot
                                                        .data.totalAmount)
                                                    .split(',')[0],
                                                style:
                                                    kCardPrimaryContentTextStyle,
                                              ),
                                              TextSpan(
                                                text: ',' +
                                                    getBalanceAsString(snapshot
                                                            .data.totalAmount)
                                                        .split(',')[1],
                                                style:
                                                    kCardSecondaryContentTextStyle,
                                              ),
                                            ]),
                                          ),
                                          Text(
                                            'Aportado: ' +
                                                getInvestmentAsString(
                                                    snapshot.data.investment),
                                            textAlign: TextAlign.left,
                                            style: kCardSubTextStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 20,
                                      child: VerticalDivider(
                                        color: Colors.black12,
                                        thickness: 1,
                                        //width: 50,
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                    ),
                                    Expanded(
                                      //flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'RENTABILIDAD',
                                            textAlign: TextAlign.left,
                                            style: kCardTitleTextStyle,
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: getPLAsString(snapshot
                                                        .data.profitLoss)
                                                    .split(',')[0],
                                                style:
                                                    kCardPrimaryContentTextStyle
                                                        .copyWith(
                                                            color: snapshot.data
                                                                .profitLossColor,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: ',' +
                                                    getPLAsString(snapshot
                                                            .data.profitLoss)
                                                        .split(',')[1],
                                                style:
                                                    kCardSecondaryContentTextStyle
                                                        .copyWith(
                                                            color: snapshot.data
                                                                .profitLossColor,
                                                        ),
                                              ),
                                            ]),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.grey,
                                                size: 14.0,
                                              ),
                                              Text(
                                                getPLPercentAsString(
                                                    snapshot.data.timeReturn),
                                                textAlign: TextAlign.left,
                                                style:
                                                    kCardSubTextStyle.copyWith(
                                                        color: snapshot.data
                                                            .timeReturnColor),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Icon(
                                                Icons.euro_symbol,
                                                color: Colors.grey,
                                                size: 14.0,
                                              ),
                                              Text(
                                                getPLPercentAsString(
                                                    snapshot.data.moneyReturn),
                                                textAlign: TextAlign.left,
                                                style:
                                                    kCardSubTextStyle.copyWith(
                                                        color: snapshot.data
                                                            .moneyReturnColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.all(0),
                              color: Colors.white,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
//                                child: LineChart(
//                                  amountsChartData(snapshot.data.amountsSeries),
//                                ),
                              child: SfCartesianChart(
                                // Initialize category axis
                                  primaryXAxis: DateTimeAxis(),

                                  series: <LineSeries<AmountsDataPoint, DateTime>>[
                                    LineSeries<AmountsDataPoint, DateTime>(
                                      // Bind data source
                                        dataSource:  snapshot.data.amountsSeries,
                                        xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
                                        yValueMapper: (AmountsDataPoint amounts, _) => amounts.totalAmount,
                                    ),
                                    LineSeries<AmountsDataPoint, DateTime>(
                                      // Bind data source
                                      dataSource:  snapshot.data.amountsSeries,
                                      xValueMapper: (AmountsDataPoint amounts, _) => amounts.date,
                                      yValueMapper: (AmountsDataPoint amounts, _) => amounts.netAmount,
                                    ),
                                  ]
                              ),
                              ),
                            ),
                          )
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
    );
  }
}
