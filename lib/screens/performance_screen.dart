import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
                              SfRadialGauge(
                                enableLoadingAnimation: true,
                                animationDuration: 1000,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    startAngle: 180,
                                    endAngle: 0,
                                    radiusFactor: 0.8,
                                    minimum: 1,
                                    maximum: 10,
                                    labelsPosition: ElementsPosition.outside,
                                    ticksPosition: ElementsPosition.outside,
                                    interval: 1,
                                    canScaleToFit: true,
                                    minorTicksPerInterval: 0,
                                    majorTickStyle: MinorTickStyle(
                                        length: 0.05,
                                        lengthUnit: GaugeSizeUnit.factor,
                                        thickness: 0.5,
                                        color: Colors.black),
                                    axisLabelStyle: GaugeTextStyle(
                                      fontSize: 15,
                                    ),
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                          startWidth: 50,
                                          endWidth: 50,
                                          startValue: 0,
                                          endValue: 4,
                                          color: Colors.green),
                                      GaugeRange(
                                          startWidth: 50,
                                          endWidth: 50,
                                          startValue: 4,
                                          endValue: 7,
                                          color: Colors.orange),
                                      GaugeRange(
                                          startWidth: 50,
                                          endWidth: 50,
                                          startValue: 7,
                                          endValue: 10,
                                          color: Colors.red)
                                    ],
                                    pointers: <GaugePointer>[
                                      NeedlePointer(value: 6)
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                          widget: Text(
                                            '6/10',
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          angle: 90,
                                          positionFactor: 0.5)
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'La rentabilidad anual esperada media de tu plan de inversiones es del +2,3%.\n\nCalculamos que con un 95% de probabilidad, al cabo de un año la rentabilidad estará entre un -12,0% y un +19,5%, y al cabo de 10 años entre un -20,9% y un +100,7%.\n\nRecuerda que estos cálculos son expectativas, por lo que no hay ninguna garantía ni seguridad de que las rentabilidades acaben en el rango indicado.'
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ReusableCard(
                          childWidget: AmountsChart(
                              amountsSeries: widget.accountData.amountsSeries),
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
