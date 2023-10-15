import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';
import 'package:indexax/tools/private_mode_provider.dart';

// Header of the expanded view of each asset tile for landscape orientation

class ExpandedAssetTileHeaderLandscape extends StatelessWidget {
  const ExpandedAssetTileHeaderLandscape({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitleTextStyle = text_styles.robotoBold(context, 15);
    TextStyle headerSubtitleTextStyle = text_styles.robotoLighter(context, 14);
    TextStyle assetAmountTextStyle = text_styles.ubuntuBold(context, 16);

    return Expanded(
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assetData.instrumentName, style: headerTitleTextStyle),
              Text(assetData.instrumentCompany!,
                  style: headerSubtitleTextStyle),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                getInvestmentAsString(assetData.amount,
                    maskValue: context
                        .watch<PrivateModeProvider>()
                        .privateModeEnabled),
                style: assetAmountTextStyle,
              ),
            ),
            Text(
                "(${getPLAsString(assetData.profitLoss!, maskValue: context.watch<PrivateModeProvider>().privateModeEnabled)})",
                style: assetData.profitLoss! < 0
                    ? headerSubtitleTextStyle.copyWith(
                        color: Theme.of(context).colorScheme.error)
                    : headerSubtitleTextStyle.copyWith(
                        color: Colors.green[600])),
          ],
        ),
      ]),
    );
  }
}
