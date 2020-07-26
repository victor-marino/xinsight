import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../chart_data.dart';
import '../services/indexa_data.dart';
import '../services/account.dart';
import '../services/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const int nbsp = 0x00A0;

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Future<Account> accountData;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  void _onRefresh() async{
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

  static final data = [
    new AccountBalance('2018', 2000),
    new AccountBalance('2019', 2020),
    new AccountBalance('2020', 2040),
  ];

  static final series = [
    new charts.Series(
      id: 'Balance',
      domainFn: (AccountBalance balanceData, _) => balanceData.date,
      measureFn: (AccountBalance balanceData, _) => balanceData.amount,
      data: data,
    ),
  ];

  final chart = new charts.BarChart(
    series,
    animate: true,
  );

  @override
  void initState() {
    super.initState();
    accountData = getAccountData();
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
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SafeArea(
          child: FutureBuilder<Account>(
              future: accountData,
              builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  child = Container(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Card(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.lightBlueAccent,
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Text(
                                          'VALOR',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.ideographic,
                                          children: <Widget>[
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: getNumberAsString(
                                                        snapshot.data.totalAmount)
                                                    .split(',')[0],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 36,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ',' +
                                                    getNumberAsString(snapshot
                                                            .data.totalAmount)
                                                        .split(',')[1],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]))
                                          ],
                                        ),
                                        Text(
                                          getNumberAsString(
                                              snapshot.data.investment),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Card(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.lightBlueAccent,
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Text(
                                          'GANANCIA',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.ideographic,
                                          children: <Widget>[
                                            Text(
                                              getPercentAsString(
                                                      snapshot.data.moneyReturn)
                                                  .split(String.fromCharCode(
                                                      nbsp))[0],
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              getPercentAsString(
                                                      snapshot.data.moneyReturn)
                                                  .split(String.fromCharCode(
                                                      nbsp))[1],
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          getNumberAsString(
                                              snapshot.data.profitLoss),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.all(0),
                              color: Colors.lightBlueAccent,
                              elevation: 5,
                              child: chart,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  child =
                      Text("Error loading data");
                } else {
                  child = Container();
                }
                return child;
              }),
        ),
      ),
    );
  }
}
