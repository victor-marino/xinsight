import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'chart_data.dart';

class SummaryScreen extends StatelessWidget {
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: <Widget>[
                                Text(
                                  '2.444',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ',17€',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
