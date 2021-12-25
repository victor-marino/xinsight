import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

class PendingTransactionsCard extends StatelessWidget {
  const PendingTransactionsCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                    "Hay transacciones en curso",
                style: kPendingTransactionsWidgetTextStyle),
              ),
            ],
          ),
        ));
  }
}