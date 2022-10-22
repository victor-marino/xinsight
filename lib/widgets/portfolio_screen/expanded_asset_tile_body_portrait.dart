import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:easy_localization/easy_localization.dart';

class ExpandedAssetTileBodyPortrait extends StatelessWidget {
  const ExpandedAssetTileBodyPortrait({
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
        Text(assetData.instrumentCompany!,
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Divider(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: assetData.instrumentCodeType! + ': ', style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: assetData.instrumentCode,
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.asset_class'.tr() + ': ',
                  style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: instrumentType,
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.titles'.tr() + ': ',
                  style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getNumberAsStringWithMaxDecimals(assetData.titles),
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'asset_details_popup.cost'.tr() + ': ', style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getInvestmentAsString(assetData.cost!),
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.current_value'.tr() + ': ',
                  style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getInvestmentAsString(assetData.amount!),
                  style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details_popup.profit_loss'.tr() + ': ',
                  style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getPLAsString(assetData.profitLoss!),
                  style: kTransactionDetailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        if (assetData.instrumentDescription !=
            'asset_details_popup.description_not_available'.tr()) ...[
          Divider(),
          Text('asset_details_popup.description'.tr() + ': ',
              style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          Text(
            assetData.instrumentDescription!,
            style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}