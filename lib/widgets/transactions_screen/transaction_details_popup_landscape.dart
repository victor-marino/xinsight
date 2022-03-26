import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';

class TransactionDetailsPopupLandscape extends StatelessWidget {
  const TransactionDetailsPopupLandscape({
    Key key,
    @required this.transactionData,
  }) : super(key: key);

  final transactionData;

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionDetails = [];

    transactionDetails.add(RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'transaction_details_popup.account'.tr() + ': ',
          style: kTransactionDetailTitleTextStyle,
        ),
        TextSpan(
          text: transactionData.accountType,
          style: kTransactionDetailValueTextStyle,
        ),
      ]),
    ));

    transactionDetails.add(RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'transaction_details_popup.concept'.tr() + ': ',
          style: kTransactionDetailTitleTextStyle,
        ),
        TextSpan(
          text: transactionData.operationType,
          style: kTransactionDetailValueTextStyle,
        ),
      ]),
    ));

    transactionDetails.add(RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'transaction_details_popup.operation_date'.tr() + ': ',
          style: kTransactionDetailTitleTextStyle,
        ),
        TextSpan(
          text: DateFormat("dd/MM/yyyy").format(transactionData.date),
          style: kTransactionDetailValueTextStyle,
        ),
      ]),
    ));

    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'transaction_details_popup.value_date'.tr() + ': ',
            style: kTransactionDetailTitleTextStyle,
          ),
          TextSpan(
            text: DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
            style: kTransactionDetailValueTextStyle,
          ),
        ]),
      ));

      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'transaction_details_popup.value_date'.tr() + ': ',
            style: kTransactionDetailTitleTextStyle,
          ),
          TextSpan(
            text: DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
            style: kTransactionDetailValueTextStyle,
          ),
        ]),
      ));

      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'transaction_details_popup.fiscal_date'.tr() + ': ',
            style: kTransactionDetailTitleTextStyle,
          ),
          TextSpan(
            text: DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate),
            style: kTransactionDetailValueTextStyle,
          ),
        ]),
      ));

      transactionDetails.add(
        Divider(),
      );

      if (transactionData.accountType ==
          'transaction_info.securities_account'.tr()) {
        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'transaction_details_popup.fund'.tr() + ': ',
              style: kTransactionDetailTitleTextStyle,
            ),
            TextSpan(
              text: transactionData.instrumentName,
              style: kTransactionDetailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: transactionData.instrumentCodeType + ": ",
              style: kTransactionDetailTitleTextStyle,
            ),
            TextSpan(
              text: transactionData.instrumentCode,
              style: kTransactionDetailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'transaction_details_popup.fund_shares'.tr() + ': ',
              style: kTransactionDetailTitleTextStyle,
            ),
            TextSpan(
              text: transactionData.titles.toString(),
              style: kTransactionDetailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'transaction_details_popup.fund_nav'.tr() + ': ',
              style: kTransactionDetailTitleTextStyle,
            ),
            TextSpan(
              text: transactionData.price.toString() + " €",
              style: kTransactionDetailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'transaction_details_popup.cost'.tr() + ': ',
              style: kTransactionDetailTitleTextStyle,
            ),
            TextSpan(
              text: transactionData.amount.toStringAsFixed(2) + " €",
              style: kTransactionDetailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(
          Divider(),
        );
      }
      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'transaction_details_popup.status'.tr() + ': ',
            style: kTransactionDetailTitleTextStyle,
          ),
          TextSpan(
            text: transactionData.status,
            style: kTransactionDetailValueTextStyle,
          ),
        ]),
      ));
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'transaction_details_popup.details'.tr(),
      ),
      content: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: transactionDetails,
            ),
          ),
        ),
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
