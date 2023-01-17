import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart';

// Header of the expanded view of each asset tile for portrait orientation

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
          child: Text(assetData.instrumentName,
              style: roboto15Bold.copyWith(
                  color: Theme.of(context).colorScheme.onSurface)),
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
                style: ubuntu16Bold.copyWith(
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Text("(" + getPLAsString(assetData.profitLoss!) + ")",
                style: assetData.profitLoss! < 0
                    ? roboto14.copyWith(
                        //color: Colors.red[800])
                        color: Theme.of(context).colorScheme.error)
                    : roboto14.copyWith(color: Colors.green[600])),
          ],
        ),
      ]),
    );
  }
}
