import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/models/transaction.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/widgets/transaction_details_popup.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key key,
    @required this.transactionData,
    @required this.firstTransaction,
    @required this.firstTransactionOfMonth,
    @required this.lastTransactionOfMonth,
  }) : super(key: key);
  final Transaction transactionData;
  final bool firstTransaction;
  final bool firstTransactionOfMonth;
  final bool lastTransactionOfMonth;

  @override
  Widget build(BuildContext context) {
    List<Widget> tileElements = [];
    double topPadding;

    if (firstTransactionOfMonth && !firstTransaction) {
      topPadding = 30;
    } else {
      topPadding = 0;
    }

    if (firstTransactionOfMonth) {
      tileElements.add(
        Padding(
          padding: EdgeInsets.only(top: topPadding, bottom: 5),
          child: Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  DateFormat("MMMM y")
                      .format(transactionData.date)
                      .toUpperCase(),
                  style: kDividerTextStyle,
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
      );
    }
    tileElements.add(
      InkWell(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
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
                      style: kTransactionListTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: DateFormat("dd/MM")
                              .format(transactionData.date)
                              .replaceAll(".", ""),
                          style: kCardSubTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: " · " + transactionData.accountType,
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
                  style: kTransactionListAmountTextStyle.copyWith(
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TransactionDetailsPopup(transactionData: transactionData),
          );
        },
      ),
    );
    return Column(
      children: tileElements,
    );
  }
}