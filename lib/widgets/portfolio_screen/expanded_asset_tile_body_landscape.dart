import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart';

// Body of the expanded view of each asset tile for landscape orientation
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
      instrumentType = "asset_details.instrument_type_equity".tr();
    } else if (assetData.instrumentType == InstrumentType.fixed) {
      instrumentType = "asset_details.instrument_type_fixed".tr();
    } else if (assetData.instrumentType == InstrumentType.cash) {
      instrumentType = "asset_details.instrument_type_cash".tr();
    } else {
      instrumentType = "asset_details.instrument_type_other".tr();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: assetData.instrumentCodeType! + ': ',
                  style: roboto15Bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: assetData.instrumentCode,
                  style: roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.asset_class'.tr() + ': ',
                  style: roboto15Bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: instrumentType,
                  style: roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.titles'.tr() + ': ',
                  style: roboto15Bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getNumberAsStringWithMaxDecimals(assetData.titles),
                  style: roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.cost'.tr() + ': ',
                  style: roboto15Bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getInvestmentAsString(assetData.cost!),
                  style: roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.current_value'.tr() + ': ',
                  style: roboto15Bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getInvestmentAsString(assetData.amount),
                  style: roboto15.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.profit_loss'.tr() + ': ',
                  style: roboto15Bold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getPLAsString(assetData.profitLoss!),
                  style: roboto14.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        if (assetData.instrumentDescription !=
            'asset_details.description_not_available'.tr()) ...[
          Divider(),
          Text('asset_details.description'.tr() + ': ',
              style: roboto15Bold.copyWith(
                  color: Theme.of(context).colorScheme.onSurface)),
          Text(
            assetData.instrumentDescription!,
            style: roboto15.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
