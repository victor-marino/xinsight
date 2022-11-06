import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/tools/number_formatting.dart';

class TransactionDetailsPopup extends StatelessWidget {
  const TransactionDetailsPopup({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  final transactionData;

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionDetails = [];

    transactionDetails.add(Text(
      'transaction_details_popup.account'.tr() + ':',
      style: kTransactionDetailTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
    ));
    transactionDetails.add(Text(
      transactionData.accountType,
      style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    ));
    transactionDetails.add(Text(
      'transaction_details_popup.concept'.tr() + ':',
      style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
    ));
    transactionDetails.add(Text(
      transactionData.operationType,
      style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    ));
    transactionDetails.add(
      Text(
        'transaction_details_popup.operation_date'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
    transactionDetails.add(
      Text(
        DateFormat("dd/MM/yyyy").format(transactionData.date),
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        'transaction_details_popup.value_date'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fiscal_date'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate),
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
    }

    transactionDetails.add(
      Divider(color: Theme.of(context).colorScheme.onBackground),
    );

    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        'transaction_details_popup.fund'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        transactionData.instrumentName,
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        transactionData.instrumentCodeType + ":",
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        transactionData.instrumentCode,
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fund_shares'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        // transactionData.titles.toString(),
        getNumberAsStringWithMaxDecimals(transactionData.titles),
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fund_nav'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        // transactionData.price.toString() + " €",
        getAmountAsStringWithMaxDecimals(transactionData.price),
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.cost'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        // transactionData.amount.toStringAsFixed(2) + " €",
        getAmountAsStringWithTwoDecimals(transactionData.amount),
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(
        Divider(color: Theme.of(context).colorScheme.onBackground,),
      );
    }
    transactionDetails.add(
      Text(
        'transaction_details_popup.status'.tr() + ':',
        style: kTransactionListTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
    transactionDetails.add(
      Text(
        transactionData.status,
        style: kTransactionDetailValueTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'transaction_details_popup.details'.tr(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface
        ),
      ),
      content: Scrollbar(
        //isAlwaysShown: true,
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
