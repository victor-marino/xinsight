import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class TransactionDetailsPopup extends StatelessWidget {
  const TransactionDetailsPopup({
    Key key,
    @required this.transactionData,
  }) : super(key: key);

  final transactionData;

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionDetails = [];

    transactionDetails.add(Text(
      'transaction_details_popup.account'.tr() + ':',
      style: kTransactionDetailTitleTextStyle,
    ));
    transactionDetails.add(Text(
      transactionData.accountType,
      style: kTransactionDetailValueTextStyle,
    ));
    transactionDetails.add(Text(
      'transaction_details_popup.concept'.tr() + ':',
      style: kTransactionListTitleTextStyle,
    ));
    transactionDetails.add(Text(
      transactionData.operationType,
      style: kTransactionDetailValueTextStyle,
    ));
    transactionDetails.add(
      Text(
        'transaction_details_popup.operation_date'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ),
    );
    transactionDetails.add(
      Text(
        DateFormat("dd/MM/yyyy").format(transactionData.date),
        style: kTransactionDetailValueTextStyle,
      ),
    );
    if (transactionData.accountType == 'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        'transaction_details_popup.value_date'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fiscal_date'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate),
        style: kTransactionDetailValueTextStyle,
      ));
    }

    transactionDetails.add(
      Divider(),
    );

    if (transactionData.accountType == 'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        'transaction_details_popup.fund'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.instrumentName,
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        "ISIN:",
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.instrumentCode,
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fund_shares'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.titles.toString(),
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fund_nav'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.price.toString() + " €",
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.cost'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.amount.toStringAsFixed(2) + " €",
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(
        Divider(),
      );
    }
    transactionDetails.add(
      Text(
        'transaction_details_popup.status'.tr() + ':',
        style: kTransactionListTitleTextStyle,
      ),
    );
    transactionDetails.add(
      Text(
        transactionData.status,
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
        children: transactionDetails,
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