import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Pop-up explaining the difference between time-weighted and money-weighted returns

class ReturnsPopUp extends StatelessWidget {
  const ReturnsPopUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle returnNameTextStyle = text_styles.robotoBoldLighter(context, 16);
    TextStyle returnDescriptionTextStyle =
        text_styles.robotoLighter(context, 16);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'profit_popup.return'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'profit_popup.time_weighted'.tr(),
                  style: returnNameTextStyle,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'profit_popup.twr_explanation'.tr(),
              style: returnDescriptionTextStyle,
            ),
            Divider(
                height: 30, color: Theme.of(context).colorScheme.onBackground),
            Row(
              children: <Widget>[
                Text(
                  'profit_popup.money_weighted'.tr(),
                  style: returnNameTextStyle,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.euro_symbol,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'profit_popup.mwr_explanation'.tr(),
              style: returnDescriptionTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'profit_popup.returns_calculated_net_of_fees'.tr(),
              style: returnDescriptionTextStyle,
            ),
          ],
        ),
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
