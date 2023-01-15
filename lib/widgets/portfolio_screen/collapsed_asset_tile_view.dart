import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/constants.dart';

// Collapsed view of each asset tile
class CollapsedAssetTileView extends StatelessWidget {
  const CollapsedAssetTileView({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          child: Text(
              getWholePercentWithoutPercentSignAsString(assetData.percentage) +
                  "%",
              textAlign: TextAlign.center,
              style: kAssetListPercentageTextStyle),
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
                  style: kAssetListMainTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                Text(assetData.instrumentCodeType! + ": " + assetData.instrumentCode!,
                    style: kAssetListSecondaryTextStyle),
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
                style: kAssetListAmountTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Text("(" + getPLAsString(assetData.profitLoss!) + ")",
                style: assetData.profitLoss! < 0
                    ? kAssetListSecondaryTextStyle.copyWith(
                    //color: Colors.red[800])
                    color: Theme.of(context).colorScheme.error)
                    : kAssetListSecondaryTextStyle.copyWith(
                    color: Colors.green[600])),
          ],
        ),
      ],
    );
  }
}