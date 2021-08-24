import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:indexa_dashboard/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key key,
    @required this.transactionData,
  }) : super(key: key);
  final Transaction transactionData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: DateFormat("dd/MM/yyyy").format(transactionData.date),
              //textAlign: TextAlign.left,
              style: kCardSubTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ]),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          transactionData.operationType,
          textAlign: TextAlign.left,
          style: kCardSubTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            transactionData.amount.toString() + " €",
            textAlign: TextAlign.right,
            style: kCardSubTextStyle,
          ),
        ),
      ],
    );
  }
}
