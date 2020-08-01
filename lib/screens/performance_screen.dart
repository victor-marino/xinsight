import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
  void initState() {
    // TODO: implement initState
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
                                  'La rentabilidad anual esperada media de tu plan de inversiones es del ${getPLPercentAsString(widget.accountData.expectedReturn)}.\n\nCalculamos que con un 95% de probabilidad, al cabo de un año la rentabilidad estará entre un ${getPLPercentAsString(widget.accountData.worstReturn1yr)} y un ${getPLPercentAsString(widget.accountData.bestReturn1yr)}, y al cabo de 10 años entre un ${getPLPercentAsString(widget.accountData.worstReturn10yr)} y un ${getPLPercentAsString(widget.accountData.bestReturn10yr)}.\n\nRecuerda que estos cálculos son expectativas, por lo que no hay ninguna garantía ni seguridad de que las rentabilidades acaben en el rango indicado.'
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
                                  performanceSeries: widget.accountData.performanceSeries),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Escenarios: hay una probabilidad estimada de 97,5% que la rentabilidad esté por encima del escenario negativo, de 2,5% que esté por encima del escenario positivo y de 95% que esté entre ambos escenarios.\n\nRecuerda que los mercados pueden ser volátiles en el corto plazo, pero tienden a revertir a la media y crecer en el largo plazo.',
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