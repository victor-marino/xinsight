import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;

// Header of the expanded view of each asset tile for landscape orientation

class ExpandedAssetTileHeaderLandscape extends StatelessWidget {
  const ExpandedAssetTileHeaderLandscape({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitleTextStyle = text_styles.robotoBold(15);
    TextStyle headerSubtitleTextStyle = text_styles.roboto(14);
    TextStyle assetAmountTextStyle = text_styles.ubuntuBold(16);

    return Expanded(
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assetData.instrumentName,
                  style: headerTitleTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              Text(assetData.instrumentCompany!,
                  style: headerSubtitleTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                style: assetAmountTextStyle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Text("(" + getPLAsString(assetData.profitLoss!) + ")",
                style: assetData.profitLoss! < 0
                    ? headerSubtitleTextStyle.copyWith(
                        //color: Colors.red[800])
                        color: Theme.of(context).colorScheme.error)
                    : headerSubtitleTextStyle.copyWith(color: Colors.green[600])),
          ],
        ),
      ]),
    );
  }
}
