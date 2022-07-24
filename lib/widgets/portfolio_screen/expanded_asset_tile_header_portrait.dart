import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';

class ExpandedAssetTileHeaderPortrait extends StatelessWidget {
  const ExpandedAssetTileHeaderPortrait({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Expanded(
          child: Text(assetData.instrumentName!, style: kAssetListMainTextStyle),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                getInvestmentAsString(assetData.amount!),
                style: kAssetListAmountTextStyle,
              ),
            ),
            Text("(" + getPLAsString(assetData.profitLoss!) + ")",
                style: assetData.profitLoss! < 0
                    ? kAssetListSecondaryTextStyle.copyWith(
                        color: Colors.red[800])
                    : kAssetListSecondaryTextStyle.copyWith(
                        color: Colors.green[600])),
          ],
        ),
      ]),
    );
  }
}
