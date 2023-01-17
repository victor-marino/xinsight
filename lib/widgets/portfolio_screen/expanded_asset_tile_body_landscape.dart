import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;

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
    TextStyle detailNameTextStyle = text_styles.robotoBold(15);
    TextStyle detailValueTextStyle = text_styles.roboto(15);

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
                  style: detailNameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: assetData.instrumentCode,
                  style: detailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.asset_class'.tr() + ': ',
                  style: detailNameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: instrumentType,
                  style: detailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.titles'.tr() + ': ',
                  style: detailNameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getNumberAsStringWithMaxDecimals(assetData.titles),
                  style: detailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.cost'.tr() + ': ',
                  style: detailNameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getInvestmentAsString(assetData.cost!),
                  style: detailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.current_value'.tr() + ': ',
                  style: detailNameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getInvestmentAsString(assetData.amount),
                  style: detailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'asset_details.profit_loss'.tr() + ': ',
                  style: detailNameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface)),
              TextSpan(
                  text: getPLAsString(assetData.profitLoss!),
                  style: detailValueTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        if (assetData.instrumentDescription !=
            'asset_details.description_not_available'.tr()) ...[
          Divider(),
          Text('asset_details.description'.tr() + ': ',
              style: detailNameTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface)),
          Text(
            assetData.instrumentDescription!,
            style: detailValueTextStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
