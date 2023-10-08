import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/models/transaction.dart';
import 'package:url_launcher/url_launcher.dart';

// Pop-up showing the details of an individual transaction in portrait mode

class TransactionDetailsPopup extends StatelessWidget {
  const TransactionDetailsPopup({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  final Transaction transactionData;

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionDetails = [];
    TextStyle detailNameTextStyle = text_styles.robotoBold(context, 15);
    TextStyle detailValueTextStyle = text_styles.robotoLighter(context, 15);

    transactionDetails.add(Text(
      '${'transaction_details_popup.account'.tr()}:',
      style: detailNameTextStyle,
    ));
    transactionDetails.add(Text(
      transactionData.accountType,
      style: detailValueTextStyle,
    ));
    transactionDetails.add(Text(
      '${'transaction_details_popup.concept'.tr()}:',
      style: detailNameTextStyle,
    ));
    transactionDetails.add(Text(
      transactionData.operationType,
      style: detailValueTextStyle,
    ));
    transactionDetails.add(
      Text(
        '${'transaction_details_popup.operation_date'.tr()}:',
        style: detailNameTextStyle,
      ),
    );
    transactionDetails.add(
      Text(
        DateFormat("dd/MM/yyyy").format(transactionData.date),
        style: detailValueTextStyle,
      ),
    );
    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        '${'transaction_details_popup.value_date'.tr()}:',
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.valueDate!),
        style: detailValueTextStyle,
      ));
      transactionDetails.add(Text(
        '${'transaction_details_popup.fiscal_date'.tr()}:',
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate!),
        style: detailValueTextStyle,
      ));
    }

    transactionDetails.add(
      Divider(color: Theme.of(context).colorScheme.onBackground),
    );

    if (transactionData.accountType ==
        'transaction_info.securities_account'.tr()) {
      transactionDetails.add(Text(
        '${'transaction_details_popup.fund'.tr()}:',
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.instrumentName!,
        style: detailValueTextStyle,
      ));
      transactionDetails.add(Text(
        "${transactionData.instrumentCodeType}:",
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.instrumentCode!,
        style: detailValueTextStyle,
      ));
      transactionDetails.add(Text(
        '${'transaction_details_popup.fund_shares'.tr()}:',
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        getNumberAsStringWithMaxDecimals(transactionData.titles),
        style: detailValueTextStyle,
      ));
      transactionDetails.add(Text(
        '${'transaction_details_popup.fund_nav'.tr()}:',
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        getAmountAsStringWithMaxDecimals(transactionData.price),
        style: detailValueTextStyle,
      ));
      transactionDetails.add(Text(
        '${'transaction_details_popup.cost'.tr()}:',
        style: detailNameTextStyle,
      ));
      transactionDetails.add(Text(
        getAmountAsStringWithTwoDecimals(transactionData.amount),
        style: detailValueTextStyle,
      ));
      transactionDetails.add(
        Divider(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
    }
    transactionDetails.add(
      Text(
        '${'transaction_details_popup.status'.tr()}:',
        style: detailNameTextStyle,
      ),
    );
    transactionDetails.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            transactionData.status,
            style: detailValueTextStyle,
          ),
        ],
      ),
    );
    return AlertDialog(
      actionsAlignment: transactionData.downloadLink != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
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
        if (transactionData.downloadLink != null) ...[
          TextButton(
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_sharp),
                Text('PDF'),
              ],
            ),
            onPressed: () => launchUrl(transactionData.downloadLink!),
          ),
        ],
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
