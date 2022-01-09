import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/portfolio_datapoint.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:indexa_dashboard/models/transaction.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/asset_details_popup.dart';

class AssetTile extends StatelessWidget {
  const AssetTile({
    Key key,
    @required this.assetData,
  }) : super(key: key);
  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    assetData.instrumentName,
                    style: kAssetListMainTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    getInvestmentAsString(assetData.amount),
                    style: kAssetListAmountTextStyle,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(assetData.instrumentID != null) Text(("ISIN: " + assetData.instrumentID), style: kAssetListSecondaryTextStyle),
                Text(getPercentAsString(assetData.percentage),
                  style: kAssetListSecondaryTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AssetDetailsPopup(assetData: assetData),
        );
      },
    );
  }
}
