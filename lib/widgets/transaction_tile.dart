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

    List<Widget> transactionDetails = [];

    transactionDetails.add(
        Text(
          "Cuenta:",
              style: kTransactionDetailTitleTextStyle,
        )
    );
    transactionDetails.add(
        Text(
          transactionData.accountType,
          style: kTransactionDetailValueTextStyle,
        )
    );
    transactionDetails.add(
        Text(
          "Concepto:",
          style: kTransactionListTitleTextStyle,
        )
    );
    transactionDetails.add(
        Text(
          transactionData.operationType,
          style: kTransactionDetailValueTextStyle,
        )
    );
    transactionDetails.add(
      Text(
        "Fecha:",
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
      transactionDetails.add(
        Text(
          "Fecha valor:",
          style: kTransactionListTitleTextStyle,
        )
      );
      transactionDetails.add(
          Text(
            DateFormat("dd/MM/yyyy").format(transactionData.valueDate),
            style: kTransactionDetailValueTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            "Fecha fiscal:",
            style: kTransactionListTitleTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            DateFormat("dd/MM/yyyy").format(transactionData.fiscalDate),
            style: kTransactionDetailValueTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            "\nFondo:",
            style: kTransactionListTitleTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            transactionData.instrumentName,
            style: kTransactionDetailValueTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            "ISIN:",
            style: kTransactionListTitleTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            transactionData.instrumentCode,
            style: kTransactionDetailValueTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            "Participaciones:",
            style: kTransactionListTitleTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            transactionData.titles.toString(),
            style: kTransactionDetailValueTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            "Precio:",
            style: kTransactionListTitleTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            transactionData.price.toString() + " €",
            style: kTransactionDetailValueTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            "Coste:",
            style: kTransactionListTitleTextStyle,
          )
      );
      transactionDetails.add(
          Text(
            transactionData.amount.toString() + " €",
            style: kTransactionDetailValueTextStyle,
          )
      );
    }
    transactionDetails.add(
      Text(
        "\nEstado:",
        style: kTransactionListTitleTextStyle,
      ),
    );
    transactionDetails.add(
      Text(
        transactionData.status,
        style: kTransactionDetailValueTextStyle,
      ),
    );
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
                    style: kTransactionListAmountTextStyle.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          "Detalles",
                          //style: kTransactionListAmountTextStyle,
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children:
                          transactionDetails,
                    ),
                      contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],            ),
            );
          },
        ),
    );
      return Column(
      children: tileElements,
    );
  }
}
