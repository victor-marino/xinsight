import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;

// Collapsed view of each asset tile
class CollapsedAssetTileView extends StatelessWidget {
  const CollapsedAssetTileView({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitleTextStyle = text_styles.robotoBold(15);
    TextStyle headerSubtitleTextStyle = text_styles.roboto(14);
    TextStyle assetPercentageTextStyle = text_styles.robotoBold(17);
    TextStyle assetAmountTextStyle = text_styles.ubuntuBold(16);

    return Row(
      children: [
        Container(
          width: 40,
          child: Text(
              getWholePercentWithoutPercentSignAsString(assetData.percentage) +
                  "%",
              textAlign: TextAlign.center,
              style: assetPercentageTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                  style: headerTitleTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                Text(
                    assetData.instrumentCodeType! +
                        ": " +
                        assetData.instrumentCode!,
                    style: headerSubtitleTextStyle.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                getInvestmentAsString(assetData.amount),
                style: assetAmountTextStyle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface),
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
      ],
    );
  }
}
