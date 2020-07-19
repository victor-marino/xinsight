import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../chart_data.dart';
import '../services/indexa_data.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Future<double> accountBalance = getAccountBalance();

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
    //getUserData();
  }

  static Future<double> getAccountBalance() async {
    IndexaDataModel indexaData = IndexaDataModel();
    var userAccounts = await indexaData.getUserAccounts();
    print(userAccounts);
    var currentAccountBalance =
        await indexaData.getAccountData(userAccounts[0]);
    return currentAccountBalance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account summary',
        ),
      ),
      body: SafeArea(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'VALOR',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            FutureBuilder<double>(
                                future: accountBalance,
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> snapshot) {
                                  Widget child;
                                  if (snapshot.hasData) {
                                    child = Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.ideographic,
                                      children: <Widget>[
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: snapshot.data.toStringAsFixed(2).split('.')[0],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: ',' + snapshot.data.toStringAsFixed(2).split('.')[1] + ' €',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]))
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    child = Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.ideographic,
                                      children: <Widget>[
                                        Text("Error loading data"),
                                      ],
                                    );
                                  } else {
                                    child = Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.ideographic,
                                      children: <Widget>[
                                        Text("Loading..."),
                                      ],
                                    );
                                  }
                                  return child;
                                }),
                            Text(
                              'Aportado: 2.400€',
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'GANANCIA',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: <Widget>[
                                Text(
                                  '+3,7',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '%',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '+44,17€',
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
      ),
    );
  }
}
