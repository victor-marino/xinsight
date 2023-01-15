import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';

// Header of the expanded view of each asset tile for landscape orientation

class ExpandedAssetTileHeaderLandscape extends StatelessWidget {
  const ExpandedAssetTileHeaderLandscape({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assetData.instrumentName, style: kAssetListMainTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              Text(assetData.instrumentCompany!,
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
      ]),
    );
  }
}
