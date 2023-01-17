import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/transaction.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;
import 'package:indexax/widgets/transactions_screen/transaction_details_popup_landscape.dart';
import 'package:indexax/widgets/transactions_screen/transaction_details_popup_portrait.dart';

// Individual tiles for each transaction in the list

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key? key,
    required this.transactionData,
    required this.firstTransaction,
    required this.firstTransactionOfMonth,
    required this.lastTransactionOfMonth,
    required this.landscapeOrientation,
  }) : super(key: key);

  final Transaction transactionData;
  final bool firstTransaction;
  final bool firstTransactionOfMonth;
  final bool lastTransactionOfMonth;
  final bool landscapeOrientation;

  @override
  Widget build(BuildContext context) {
    List<Widget> tileElements = [];
    TextStyle tileTitleTextStyle = text_styles.robotoBold(15);
    TextStyle tileSubtitleTextStyle = text_styles.roboto(12);
    TextStyle dividerTextStyle = text_styles.roboto(13);
    TextStyle transactionAmountTextStyle = text_styles.ubuntuBold(17);

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
              Expanded(
                  child: Divider(
                color: Theme.of(context).colorScheme.onBackground,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  DateFormat("MMMM y")
                      .format(transactionData.date)
                      .toUpperCase(),
                  style: dividerTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              Expanded(
                  child: Divider(
                color: Theme.of(context).colorScheme.onBackground,
              )),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionData.operationType,
                        textAlign: TextAlign.left,
                        style: tileTitleTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                      RichText(
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        text: TextSpan(children: [
                          TextSpan(
                              text: DateFormat("dd/MM")
                                  .format(transactionData.date)
                                  .replaceAll(".", ""),
                              style: tileSubtitleTextStyle.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                          TextSpan(
                              text: " · " + transactionData.accountType,
                              style: tileSubtitleTextStyle.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                getAmountAsStringWithTwoDecimals(transactionData.amount),
                textAlign: TextAlign.right,
                style: transactionAmountTextStyle.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: landscapeOrientation
                  ? (BuildContext context) => TransactionDetailsPopupLandscape(
                      transactionData: transactionData)
                  : (BuildContext context) => TransactionDetailsPopup(
                      transactionData: transactionData));
        },
      ),
    );
    return Column(
      children: tileElements,
    );
  }
}
