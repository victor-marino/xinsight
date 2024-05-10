import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';

// Collapsed view of each asset tile
class CollapsedAssetTileView extends StatelessWidget {
  const CollapsedAssetTileView({
    super.key,
    required this.assetData,
  });

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitleTextStyle = text_styles.robotoBold(context, 15);
    TextStyle headerSubtitleTextStyle = text_styles.robotoLighter(context, 14);
    TextStyle assetPercentageTextStyle =
        text_styles.robotoBoldLighter(context, 17);
    TextStyle assetAmountTextStyle = text_styles.ubuntuBold(context, 16);

    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
              "${getWholePercentWithoutPercentSignAsString(assetData.percentage)}%",
              textAlign: TextAlign.center,
              style: assetPercentageTextStyle),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assetData.instrumentName,
                  maxLines: 1,
                  style: headerTitleTextStyle,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                Text(
                    "${assetData.instrumentCodeType!}: ${assetData.instrumentCode!}",
                    style: headerSubtitleTextStyle),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                getInvestmentAsString(assetData.amount, maskValue: context.watch<PrivateModeProvider>().privateModeEnabled),
                style: assetAmountTextStyle,
              ),
            ),
            Text("(${getPLAsString(assetData.profitLoss!, maskValue: context.watch<PrivateModeProvider>().privateModeEnabled)})",
                style: assetData.profitLoss! < 0
                    ? headerSubtitleTextStyle.copyWith(
                        color: Theme.of(context).colorScheme.error)
                    : headerSubtitleTextStyle.copyWith(
                        color: Colors.green[600])),
          ],
        ),
      ],
    );
  }
}
