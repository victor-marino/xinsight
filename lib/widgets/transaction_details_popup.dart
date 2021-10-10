import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

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
      "Cuenta:",
      style: kTransactionDetailTitleTextStyle,
    ));
    transactionDetails.add(Text(
      transactionData.accountType,
      style: kTransactionDetailValueTextStyle,
    ));
    transactionDetails.add(Text(
      "Concepto:",
      style: kTransactionListTitleTextStyle,
    ));
    transactionDetails.add(Text(
      transactionData.operationType,
      style: kTransactionDetailValueTextStyle,
    ));
    transactionDetails.add(
      Text(
        "Fecha operación:",
        style: kTransactionListTitleTextStyle,
      ),
    );

    transactionDetails.add(
      Text(
        DateFormat("dd/MM/yyyy").format(transactionData.date),
        style: kTransactionDetailValueTextStyle,
      ),
    );
    if (transactionData.accountType == "Cuenta de valores") {
      transactionDetails.add(Text(
        "Fecha valor:",
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        "Fecha fiscal:",
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

    if (transactionData.accountType == "Cuenta de valores") {
      transactionDetails.add(Text(
        "Fondo:",
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
        "Participaciones:",
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.titles.toString(),
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        "Valor liquidativo:",
        style: kTransactionListTitleTextStyle,
      ));
      transactionDetails.add(Text(
        transactionData.price.toString() + " €",
        style: kTransactionDetailValueTextStyle,
      ));
      transactionDetails.add(Text(
        "Importe:",
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
        "Estado:",
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
        "Detalles",
        //style: kTransactionListAmountTextStyle,
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