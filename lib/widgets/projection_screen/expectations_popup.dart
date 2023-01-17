import 'package:flutter/material.dart';
import 'package:indexax/tools/text_styles.dart' as text_styles;
import 'package:easy_localization/easy_localization.dart';

// Informational pop-up explaining how expectations are calculated

class ExpectationsPopUp extends StatelessWidget {
  const ExpectationsPopUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle descriptionTextStyle = text_styles.roboto(16);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'expectations_popup.expectations'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          'expectations_popup.expectations_explanation'.tr(),
          style: descriptionTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
