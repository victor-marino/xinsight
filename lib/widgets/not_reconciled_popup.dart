import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Pop-up informing the user that account data is not fully up to date yet

class NotReconciledCard extends StatelessWidget {
  const NotReconciledCard({
    super.key,
    required this.reconciledUntil,
  });

  final DateTime reconciledUntil;

  @override
  Widget build(BuildContext context) {
    TextStyle notReconciledDescriptionTextStyle =
        text_styles.robotoLighter(context, 16);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'not_reconciled_popup.update_pending'.tr(),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      content: Row(
        children: [
          Expanded(
            child: Text(
                "${'not_reconciled_popup.not_reconciled_explanation'.tr()}${reconciledUntil.day.toString().padLeft(2, '0')}/${reconciledUntil.month.toString().padLeft(2, '0')}/${reconciledUntil.year}.",
                            style: notReconciledDescriptionTextStyle
                ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
