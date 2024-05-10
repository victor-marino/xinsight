import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/radiant_linear_mask.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Legend for the distribution chart in overview screen

class DistributionChartLegend extends StatelessWidget {
  const DistributionChartLegend({
    super.key,
    required this.portfolioDistribution,
  });
  final Map<InstrumentType, Map<ValueType, double>> portfolioDistribution;

  @override
  Widget build(BuildContext context) {
    List<Widget> legendItems = [];
    TextStyle primaryLegendTextStyle = text_styles.roboto(context, 12);
    TextStyle secondaryLegendTextStyle = text_styles.robotoLighter(context, 12);

    if (portfolioDistribution.containsKey(InstrumentType.equity)) {
      legendItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadiantLinearMask(
              color1: text_styles.equityColors[0],
              color2: text_styles.equityColors[7],
              child: const Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Colors.white,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_equity'.tr(),
                      style: primaryLegendTextStyle),
                  TextSpan(
                      text: " (${getPercentAsString(portfolioDistribution[
                              InstrumentType.equity]![ValueType.percentage])})",
                      style: secondaryLegendTextStyle)
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadiantLinearMask(
              color1: text_styles.fixedColors[0],
              color2: text_styles.fixedColors[7],
              child: const Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Colors.white,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_fixed'.tr(),
                      style: primaryLegendTextStyle),
                  TextSpan(
                      text: " (${getPercentAsString(portfolioDistribution[
                              InstrumentType.fixed]![ValueType.percentage])})",
                      style: secondaryLegendTextStyle)
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioDistribution.containsKey(InstrumentType.moneymarket) &&
        portfolioDistribution[InstrumentType.moneymarket]![ValueType.amount] != 0) {
      legendItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: text_styles.moneyMarketColor,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_moneymarket'.tr(),
                      style: primaryLegendTextStyle),
                  TextSpan(
                      text:
                          " (${getPercentAsString(portfolioDistribution[InstrumentType.moneymarket]![ValueType.percentage])})",
                      style: secondaryLegendTextStyle)
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: text_styles.otherColor,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_other'.tr(),
                      style: primaryLegendTextStyle),
                  TextSpan(
                      text: " (${getPercentAsString(portfolioDistribution[
                              InstrumentType.other]![ValueType.percentage])})",
                      style: secondaryLegendTextStyle)
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (portfolioDistribution.containsKey(InstrumentType.cash) &&
        portfolioDistribution[InstrumentType.cash]![ValueType.amount] != 0) {
      legendItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.fiber_manual_record,
              size: 12,
              color: text_styles.cashColor,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_cash'.tr(),
                      style: primaryLegendTextStyle),
                  TextSpan(
                      text: " (${getPercentAsString(portfolioDistribution[
                              InstrumentType.cash]![ValueType.percentage])})",
                      style: secondaryLegendTextStyle)
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: legendItems,
    );
  }
}
