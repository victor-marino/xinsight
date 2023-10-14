import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Collapsed view of each asset tile
class CollapsedAssetTileView extends StatelessWidget {
  const CollapsedAssetTileView({
    Key? key,
    required this.assetData,
  }) : super(key: key);

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
                protectValue(getInvestmentAsString(assetData.amount), context),
                style: assetAmountTextStyle,
              ),
            ),
            Text("(${protectValue(getPLAsString(assetData.profitLoss!), context)})",
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
