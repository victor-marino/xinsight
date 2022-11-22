import 'package:flutter/material.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:easy_localization/easy_localization.dart';

class MinimumTransferCard extends StatelessWidget {
  const MinimumTransferCard({
    Key? key,
    required this.additionalCashNeededToTrade,
  }) : super(key: key);

  final double? additionalCashNeededToTrade;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'minimum_transfer_card.minimum_transfer_to_invest'.tr() + ': ',
            //style: kCardSubTextStyle,
            style: Theme.of(context).textTheme.labelLarge
          ),
          TextSpan(
            text: getInvestmentAsString(additionalCashNeededToTrade!),
            // style: kMinimumTransferCardTextStyle.copyWith(
            //       fontWeight: FontWeight.bold),
            style: Theme.of(context).textTheme.titleSmall
          ),
      ]),
    );
  }
}
