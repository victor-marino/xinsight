import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskChart extends StatelessWidget {
  const RiskChart({
    Key key,
    @required this.risk,
  }) : super(key: key);
  final double risk;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      title: GaugeTitle(
        text: 'Tu riesgo',
        textStyle: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        )
      ),
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
            NeedlePointer(value: risk)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Text(
                  '${risk.toStringAsFixed(0)}/10',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                angle: 90,
                positionFactor: 0.3)
          ],
        ),
      ],
    );
  }
}