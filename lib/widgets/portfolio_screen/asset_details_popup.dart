import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/constants.dart';

class AssetDetailsPopup extends StatelessWidget {
  const AssetDetailsPopup({
    Key key,
    @required this.assetData,
  }) : super(key: key);

  final PortfolioDataPoint assetData;

  @override
  Widget build(BuildContext context) {
    List<Widget> assetDetails = [];
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

    assetDetails.add(Text(
      'asset_details_popup.name'.tr() + ':',
      style: kTransactionDetailTitleTextStyle,
    ));
    assetDetails.add(SelectableText(
      assetData.instrumentName,
      style: kTransactionDetailValueTextStyle,
    ));
    assetDetails.add(Text(
      'asset_details_popup.management_company'.tr() + ':',
      style: kTransactionListTitleTextStyle,
    ));
    assetDetails.add(SelectableText(
      assetData.instrumentCompany,
      style: kTransactionDetailValueTextStyle,
    ));
    assetDetails.add(Text(
      'asset_details_popup.asset_class'.tr() + ':',
      style: kTransactionListTitleTextStyle,
    ));
    assetDetails.add(SelectableText(
      instrumentType,
      style: kTransactionDetailValueTextStyle,
    ));
    assetDetails.add(
      Text(
        'ISIN:',
        style: kTransactionListTitleTextStyle,
      ),
    );
    assetDetails.add(
      SelectableText(
        assetData.instrumentID,
        style: kTransactionDetailValueTextStyle,
      ),
    );
    assetDetails.add(
      Divider(),
    );
    assetDetails.add(
      Text(
        'asset_details_popup.description'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ),
    );
    assetDetails.add(
      SelectableText(
        assetData.instrumentDescription,
        style: kTransactionDetailValueTextStyle,
      ),
    );


    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      title: Text(
        'transaction_details_popup.details'.tr(),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: assetDetails,
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}