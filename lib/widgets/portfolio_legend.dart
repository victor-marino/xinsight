import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexa_dashboard/tools/RadiantLinearMask.dart';

class PortfolioChartLegend extends StatelessWidget {
  const PortfolioChartLegend({
    Key key,
    @required this.portfolioDistribution,
  }) : super(key: key);
  final Map<InstrumentType, double> portfolioDistribution;

  @override
  Widget build(BuildContext context) {
    List<Widget> legendItems = [];

    if (portfolioDistribution.containsKey(InstrumentType.equity)) {
      legendItems.add(
        Row(
          children: <Widget>[
            RadiantLinearMask(
              child: Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Colors.white,
              ),
              color1: equityColors[0],
              color2: equityColors[7],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: InstrumentType.equity.toString().tr(),
                      style: kLegendMainTextStyle),
                  TextSpan(
                      text:  " (" + (portfolioDistribution[InstrumentType.equity] * 100).toStringAsFixed(1) + "%)",
                      style: kLegendSecondaryTextStyle)
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioDistribution.containsKey(InstrumentType.fixed)) {
      legendItems.add(
        Row(
          children: <Widget>[
            RadiantLinearMask(
              child: Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Colors.white,
              ),
              color1: fixedColors[0],
              color2: fixedColors[7],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: InstrumentType.fixed.toString().tr(),
                      style: kLegendMainTextStyle),
                  TextSpan(
                    //text: "10.000€",
                      text:  " (" + (portfolioDistribution[InstrumentType.fixed] * 100).toStringAsFixed(1) + "%)",
                      style: kLegendSecondaryTextStyle)
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioDistribution.containsKey(InstrumentType.other)) {
      legendItems.add(
        Row(
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: otherColor,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: InstrumentType.other.toString().tr(),
                      style: kLegendMainTextStyle),
                  TextSpan(
                    //text: "10.000€",
                      text:  " (" + (portfolioDistribution[InstrumentType.other] * 100).toStringAsFixed(1) + "%)",
                      style: kLegendSecondaryTextStyle)
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioDistribution.containsKey(InstrumentType.cash)) {
      legendItems.add(
        Row(
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: cashColor,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: InstrumentType.cash.toString().tr(),
                      style: kLegendMainTextStyle),
                  TextSpan(
                    //text: "10.000€",
                      text:  " (" + (portfolioDistribution[InstrumentType.cash] * 100).toStringAsFixed(1) + "%)",
                      style: kLegendSecondaryTextStyle)
                ],
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