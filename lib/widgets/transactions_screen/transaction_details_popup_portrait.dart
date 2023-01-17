import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;

// Pop-up showing the details of an individual transaction in portrait mode

class TransactionDetailsPopup extends StatelessWidget {
  const TransactionDetailsPopup({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  final transactionData;

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionDetails = [];
    TextStyle detailNameTextStyle = text_styles.robotoBold(15);
    TextStyle detailValueTextStyle = text_styles.roboto(15);

    transactionDetails.add(Text(
      'transaction_details_popup.account'.tr() + ':',
      style:
          detailNameTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
    ));
    transactionDetails.add(Text(
      transactionData.accountType,
      style: detailValueTextStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant),
    ));
    transactionDetails.add(Text(
      'transaction_details_popup.concept'.tr() + ':',
      style:
          detailNameTextStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
    ));
    transactionDetails.add(Text(
      transactionData.operationType,
      style: detailValueTextStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant),
    ));
    transactionDetails.add(
      Text(
        'transaction_details_popup.operation_date'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ),
    );
    transactionDetails.add(
      Text(
        DateFormat("dd/MM/yyyy").format(transactionData.date),
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        'transaction_details_popup.value_date'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fiscal_date'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate),
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
    }

    transactionDetails.add(
      Divider(color: Theme.of(context).colorScheme.onBackground),
    );

    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        'transaction_details_popup.fund'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        transactionData.instrumentName,
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        transactionData.instrumentCodeType + ":",
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        transactionData.instrumentCode,
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fund_shares'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        getNumberAsStringWithMaxDecimals(transactionData.titles),
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.fund_nav'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        getAmountAsStringWithMaxDecimals(transactionData.price),
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(Text(
        'transaction_details_popup.cost'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ));
      transactionDetails.add(Text(
        getAmountAsStringWithTwoDecimals(transactionData.amount),
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ));
      transactionDetails.add(
        Divider(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
    }
    transactionDetails.add(
      Text(
        'transaction_details_popup.status'.tr() + ':',
        style: detailNameTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface),
      ),
    );
    transactionDetails.add(
      Text(
        transactionData.status,
        style: detailValueTextStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
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
