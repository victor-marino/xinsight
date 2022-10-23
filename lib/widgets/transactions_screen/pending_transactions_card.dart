import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class PendingTransactionsCard extends StatelessWidget {
  const PendingTransactionsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          //color: Colors.blue[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                    'pending_transactions_popup.pending_transactions_message'.tr(),
                style: kPendingTransactionsWidgetTextStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ],
          ),
        ));
  }
}