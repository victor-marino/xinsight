import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskChart extends StatelessWidget {
  const RiskChart({
    Key? key,
    required this.risk,
  }) : super(key: key);
  final int? risk;

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
      animationDuration: 1000,
      minimum: 1,
      maximum: 10,

      interval: 1,
      minorTicksPerInterval: 0,
      ranges: <LinearGaugeRange>[
        LinearGaugeRange(
            startWidth: 5,
            endWidth: 5,
            startValue: 0,
            endValue: 4,
            rangeShapeType: LinearRangeShapeType.curve,
            position: LinearElementPosition.cross,
            color: Colors.green),
        LinearGaugeRange(
            startWidth: 5,
            endWidth: 5,
            startValue: 4,
            endValue: 7,
            rangeShapeType: LinearRangeShapeType.curve,
            position: LinearElementPosition.cross,
            color: Colors.orange),
        LinearGaugeRange(
            startWidth: 5,
            endWidth: 5,
            startValue: 7,
            endValue: 10,
            rangeShapeType: LinearRangeShapeType.curve,
            position: LinearElementPosition.cross,
            color: Colors.red)
      ],
      markerPointers: [LinearShapePointer(
          value: risk!.toDouble(),
        shapeType: LinearShapePointerType.invertedTriangle,
      )],
    );
  }
}
