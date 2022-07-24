import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:easy_localization/easy_localization.dart';

class ExpandedAssetTileBodyLandscape extends StatelessWidget {
  const ExpandedAssetTileBodyLandscape({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    String instrumentType;

    if (assetData.instrumentType == InstrumentType.equity) {
      instrumentType = "asset_details_popup.instrument_type_equity".tr();
    } else if (assetData.instrumentType == InstrumentType.fixed) {
      instrumentType = "asset_details_popup.instrument_type_fixed".tr();
    } else if (assetData.instrumentType == InstrumentType.cash) {
      instrumentType = "asset_details_popup.instrument_type_cash".tr();
    } else {
      instrumentType = "asset_details_popup.instrument_type_other".tr();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: assetData.instrumentCodeType! + ': ', style: kTransactionListTitleTextStyle),
              TextSpan(
                  text: assetData.instrumentCode,
                  style: kTransactionDetailValueTextStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.asset_class'.tr() + ': ',
                  style: kTransactionListTitleTextStyle),
              TextSpan(
                  text: instrumentType,
                  style: kTransactionDetailValueTextStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.titles'.tr() + ': ',
                  style: kTransactionListTitleTextStyle),
              TextSpan(
                  text: getNumberAsStringWithMaxDecimals(assetData.titles),
                  style: kTransactionDetailValueTextStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'asset_details_popup.cost'.tr() + ': ', style: kTransactionListTitleTextStyle),
              TextSpan(
                  text: getInvestmentAsString(assetData.cost!),
                  style: kTransactionDetailValueTextStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.current_value'.tr() + ': ',
                  style: kTransactionListTitleTextStyle),
              TextSpan(
                  text: getInvestmentAsString(assetData.amount!),
                  style: kTransactionDetailValueTextStyle),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.profit_loss'.tr() + ': ',
                  style: kTransactionListTitleTextStyle),
              TextSpan(
                  text: getPLAsString(assetData.profitLoss!),
                  style: kAssetListSecondaryTextStyle),
            ],
          ),
        ),
        if (assetData.instrumentDescription !=
            'asset_details_popup.description_not_available'.tr()) ...[
          Divider(),
          Text('asset_details_popup.description'.tr() + ': ',
              style: kTransactionListTitleTextStyle),
          Text(
            assetData.instrumentDescription!,
            style: kTransactionDetailValueTextStyle,
          ),
        ],
      ],
    );
  }
}