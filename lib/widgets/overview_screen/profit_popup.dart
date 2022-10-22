import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';

class ProfitPopUp extends StatelessWidget {
  const ProfitPopUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  style: kPopUpSubtitleTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'profit_popup.twr_explanation'.tr(),
              style: kPopUpNormalTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            Divider(
              height: 30,
              color: Theme.of(context).colorScheme.onBackground
            ),
            Row(
              children: <Widget>[
                Text(
                  'profit_popup.money_weighted'.tr(),
                  style: kPopUpSubtitleTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.euro_symbol,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'profit_popup.mwr_explanation'.tr(),
              style: kPopUpNormalTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'profit_popup.returns_calculated_net_of_fees'.tr(),
              style: kPopUpFootnoteTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
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
