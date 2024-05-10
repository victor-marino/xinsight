import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Banner showing if there are pending transactions in this account

class PendingTransactionsCard extends StatelessWidget {
  const PendingTransactionsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle pendingTransactionsTextStyle = text_styles.roboto(context, 15);

    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
                    'pending_transactions_popup.pending_transactions_message'
                        .tr(),
                    style: pendingTransactionsTextStyle.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ],
          ),
        ));
  }
}
