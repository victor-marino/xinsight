import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/models/transaction.dart';

// Pop-up showing the details of an individual transaction in landscape mode

class TransactionDetailsPopupLandscape extends StatelessWidget {
  const TransactionDetailsPopupLandscape({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  final Transaction transactionData;

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionDetails = [];
    TextStyle detailNameTextStyle = text_styles.robotoBold(context, 15);
    TextStyle detailValueTextStyle = text_styles.robotoLighter(context, 15);

    transactionDetails.add(RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '${'transaction_details_popup.account'.tr()}: ',
          style: detailNameTextStyle,
        ),
        TextSpan(
          text: transactionData.accountType,
          style: detailValueTextStyle,
        ),
      ]),
    ));

    transactionDetails.add(RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '${'transaction_details_popup.concept'.tr()}: ',
          style: detailNameTextStyle,
        ),
        TextSpan(
          text: transactionData.operationType,
          style: detailValueTextStyle,
        ),
      ]),
    ));

    transactionDetails.add(RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '${'transaction_details_popup.operation_date'.tr()}: ',
          style: detailNameTextStyle,
        ),
        TextSpan(
          text: DateFormat("dd/MM/yyyy").format(transactionData.date),
          style: detailValueTextStyle,
        ),
      ]),
    ));

    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${'transaction_details_popup.value_date'.tr()}: ',
            style: detailNameTextStyle,
          ),
          TextSpan(
            text: DateFormat("dd/MM/yyyy").format(transactionData.valueDate!),
            style: detailValueTextStyle,
          ),
        ]),
      ));

      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${'transaction_details_popup.value_date'.tr()}: ',
            style: detailNameTextStyle,
          ),
          TextSpan(
            text: DateFormat("dd/MM/yyyy").format(transactionData.valueDate!),
            style: detailValueTextStyle,
          ),
        ]),
      ));

      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${'transaction_details_popup.fiscal_date'.tr()}: ',
            style: detailNameTextStyle,
          ),
          TextSpan(
            text: DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate!),
            style: detailValueTextStyle,
          ),
        ]),
      ));

      transactionDetails.add(
        Divider(color: Theme.of(context).colorScheme.onBackground),
      );

      if (transactionData.accountType ==
          'transaction_info.securities_account'.tr()) {
        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '${'transaction_details_popup.fund'.tr()}: ',
              style: detailNameTextStyle,
            ),
            TextSpan(
              text: transactionData.instrumentName,
              style: detailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "${transactionData.instrumentCodeType}: ",
              style: detailNameTextStyle,
            ),
            TextSpan(
              text: transactionData.instrumentCode,
              style: detailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '${'transaction_details_popup.fund_shares'.tr()}: ',
              style: detailNameTextStyle,
            ),
            TextSpan(
              text: getNumberAsStringWithMaxDecimals(transactionData.titles),
              style: detailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '${'transaction_details_popup.fund_nav'.tr()}: ',
              style: detailNameTextStyle,
            ),
            TextSpan(
              text: getAmountAsStringWithMaxDecimals(transactionData.price),
              style: detailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '${'transaction_details_popup.cost'.tr()}: ',
              style: detailNameTextStyle,
            ),
            TextSpan(
              text: getAmountAsStringWithTwoDecimals(transactionData.amount),
              style: detailValueTextStyle,
            ),
          ]),
        ));

        transactionDetails.add(
          Divider(color: Theme.of(context).colorScheme.onBackground),
        );
      }
      transactionDetails.add(RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${'transaction_details_popup.status'.tr()}: ',
            style: detailNameTextStyle,
          ),
          TextSpan(
            text: transactionData.status,
            style: detailValueTextStyle,
          ),
        ]),
      ));
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'transaction_details_popup.details'.tr(),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      content: Scrollbar(
        thumbVisibility: true,
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
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
