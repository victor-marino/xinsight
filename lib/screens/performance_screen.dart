import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/performance_chart.dart';
import 'package:indexa_dashboard/widgets/risk_chart.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({
    Key key,
    this.accountData,
    this.loadData,
  }) : super(key: key);
  final Account accountData;
  final Function loadData;

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await widget.loadData();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
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
                'Desempeño',
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'RIESGO',
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              RiskChart(risk: 6),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    'Rentabilidad anual esperada media: ${getPLPercentAsString(widget.accountData.expectedReturn)}.\n\nProbabilidad del 95 % de que la rentabilidad esté:\n· Entre ${getPLPercentAsString(widget.accountData.worstReturn1yr)} y ${getPLPercentAsString(widget.accountData.bestReturn1yr)} al cabo de 1 año.\n· Entre ${getPLPercentAsString(widget.accountData.worstReturn10yr)} y ${getPLPercentAsString(widget.accountData.bestReturn10yr)} al cabo de 10 años.'),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      child: SimpleDialog(
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: Text(
                                                'Recuerda que estos cálculos son expectativas, por lo que no hay ninguna garantía ni seguridad de que las rentabilidades acaben en el rango indicado.'),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ReusableCard(
                          childWidget: Column(
                            children: <Widget>[
                              PerformanceChart(
                                  performanceSeries:
                                      widget.accountData.performanceSeries),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Probabilidades:\n· Por encima del escenario negativo: 97,5%\n· Por encima del escenario positivo: 2,5%\n· Entre ambos escenarios: 95%.',
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      child: SimpleDialog(
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: Text(
                                                'Recuerda que los mercados pueden ser volátiles en el corto plazo, pero tienden a revertir a la media y crecer en el largo plazo.'),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
