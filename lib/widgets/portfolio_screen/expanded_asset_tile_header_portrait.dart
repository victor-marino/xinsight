import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Header of the expanded view of each asset tile for portrait orientation

class ExpandedAssetTileHeaderPortrait extends StatelessWidget {
  const ExpandedAssetTileHeaderPortrait({
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
          child: Text(assetData.instrumentName, style: headerTitleTextStyle),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                getInvestmentAsString(assetData.amount),
                style: assetAmountTextStyle,
              ),
            ),
            Text("(" + getPLAsString(assetData.profitLoss!) + ")",
                style: assetData.profitLoss! < 0
                    ? headerSubtitleTextStyle.copyWith(
                        //color: Colors.red[800])
                        color: Theme.of(context).colorScheme.error)
                    : headerSubtitleTextStyle.copyWith(
                        color: Colors.green[600])),
          ],
        ),
      ]),
    );
  }
}
