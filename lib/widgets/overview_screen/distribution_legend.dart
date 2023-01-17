import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/radiant_linear_mask.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;

// Legend for the distribution chart in overview screen

class DistributionChartLegend extends StatelessWidget {
  const DistributionChartLegend({
    Key? key,
    required this.portfolioDistribution,
  }) : super(key: key);
  final Map<InstrumentType, Map<ValueType, double>> portfolioDistribution;

  @override
  Widget build(BuildContext context) {
    List<Widget> legendItems = [];
    TextStyle legendTextStyle = text_styles.roboto(12);

    if (portfolioDistribution.containsKey(InstrumentType.equity)) {
      legendItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadiantLinearMask(
              child: Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Colors.white,
              ),
              color1: text_styles.equityColors[0],
              color2: text_styles.equityColors[7],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_equity'.tr(),
                      style: legendTextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(
                      text: " (" +
                          getPercentAsString(portfolioDistribution[
                              InstrumentType.equity]![ValueType.percentage]) +
                          ")",
                      style: legendTextStyle.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))
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
              child: Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Colors.white,
              ),
              color1: text_styles.fixedColors[0],
              color2: text_styles.fixedColors[7],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'distribution_legend.instrument_type_fixed'.tr(),
                      style: legendTextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(
                      text: " (" +
                          getPercentAsString(portfolioDistribution[
                              InstrumentType.fixed]![ValueType.percentage]) +
                          ")",
                      style: legendTextStyle.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))
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
                      style: legendTextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(
                      text: " (" +
                          getPercentAsString(portfolioDistribution[
                              InstrumentType.other]![ValueType.percentage]) +
                          ")",
                      style: legendTextStyle.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))
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
                      style: legendTextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                  TextSpan(
                      text: " (" +
                          getPercentAsString(portfolioDistribution[
                              InstrumentType.cash]![ValueType.percentage]) +
                          ")",
                      style: legendTextStyle.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Wrap(
      children: legendItems,
      spacing: 10,
      runSpacing: 5,
    );
  }
}
