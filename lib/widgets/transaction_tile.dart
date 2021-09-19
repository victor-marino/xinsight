import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:indexa_dashboard/models/transaction.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key key,
    @required this.transactionData,
    @required this.firstTransactionOfMonth,
    @required this.lastTransactionOfMonth,
  }) : super(key: key);
  final Transaction transactionData;
  final bool firstTransactionOfMonth;
  final bool lastTransactionOfMonth;

  @override
  Widget build(BuildContext context) {
    List<Widget> tileElements = [];
    // IconData tileIcon;

    if (firstTransactionOfMonth) {
      tileElements.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  DateFormat("MMMM y").format(transactionData.date).toUpperCase(),
                  style: kDividerTextStyle,
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
      );
    }

    // if (transactionData.accountType == "Cuenta de valores") {
    //   tileIcon = Icons.show_chart;
    // } else if (transactionData.accountType == "Cuenta de efectivo") {
    //   tileIcon = Icons.euro;
    // } else {
    //   tileIcon = Icons.help_outline;
    // }

    tileElements.add(
      ReusableCard(
        childWidget: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              transactionData.icon,
              color: Colors.blueAccent,
              size: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionData.operationType,
                    textAlign: TextAlign.left,
                    style: kCardSubTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: DateFormat("dd/MM").format(transactionData.date).replaceAll(".", ""),
                        //textAlign: TextAlign.left,
                        style: kCardSubTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: " · " + transactionData.accountType,
                        //textAlign: TextAlign.left,
                        style: kCardSubTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                transactionData.amount.toStringAsFixed(2) + " €",
                textAlign: TextAlign.right,
                style: kCardSubTextStyle,
              ),
            ),
          ],
        ),
        flatTop: firstTransactionOfMonth ? false : true,
        flatBottom: lastTransactionOfMonth ? false : true,
      ));

      return Column(
      children: tileElements,
    );
  }
}
