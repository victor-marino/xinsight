import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:easy_localization/easy_localization.dart';

class MinimumTransferCard extends StatelessWidget {
  const MinimumTransferCard({
    Key key,
    @required this.additionalCashNeededToTrade,
  }) : super(key: key);

  final double additionalCashNeededToTrade;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'minimum_transfer_card.minimum_transfer_to_invest'.tr() + ': ',
            style: kCardSubTextStyle,
          ),
          TextSpan(
            text: getInvestmentAsString(additionalCashNeededToTrade),
            style: kMinimumTransferCardTextStyle.copyWith(
                  fontWeight: FontWeight.bold),
          ),
      ]),
    );
  }
}
