import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import 'package:easy_localization/easy_localization.dart';

class PortfolioChartLegend extends StatelessWidget {
  const PortfolioChartLegend({
    Key key,
    @required this.portfolioData,
  }) : super(key: key);
  final List<PortfolioDataPoint> portfolioData;

  @override
  Widget build(BuildContext context) {
    List<Widget> legendItems = [];

    if (portfolioData.any((element) => element.instrumentType == InstrumentType.equity)) {
      legendItems.add(
        Row(
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: equityColors[0],
            ),
            Text(
              InstrumentType.equity.toString().tr(),
              style: TextStyle(
                  fontSize: 12
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioData.any((element) => element.instrumentType == InstrumentType.fixed)) {
      legendItems.add(
        Row(
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: fixedColors[0],
            ),
            Text(
              InstrumentType.fixed.toString().tr(),
              style: TextStyle(
                  fontSize: 12
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioData.any((element) => element.instrumentType == InstrumentType.other)) {
      legendItems.add(
        Row(
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: otherColor,
            ),
            Text(
              InstrumentType.other.toString().tr(),
              style: TextStyle(
                  fontSize: 12
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioData.any((element) => element.instrumentType == InstrumentType.cash)) {
      legendItems.add(
        Row(
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: cashColor,
            ),
            Text(
              InstrumentType.cash.toString().tr(),
              style: TextStyle(
                  fontSize: 12
              ),
            ),
          ],
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: legendItems,
    );
  }
}