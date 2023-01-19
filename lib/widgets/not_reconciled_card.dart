import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Banner showing if there are pending transactions in this account

class NotReconciledCard extends StatelessWidget {
  const NotReconciledCard({
    Key? key,
    required this.reconciledUntil,
  }) : super(key: key);

  final DateTime reconciledUntil;

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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                      'Posiciones pendientes de actualización. La fecha de tus datos sigue siendo el ' +
                          reconciledUntil.day.toString() + "/" + reconciledUntil.month.toString() + "/" + reconciledUntil.year.toString() + ".",
                      style: pendingTransactionsTextStyle.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ),
            ],
          ),
        ));
  }
}
