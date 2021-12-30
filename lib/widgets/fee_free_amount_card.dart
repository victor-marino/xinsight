import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:easy_localization/easy_localization.dart';

class FeeFreeAmountCard extends StatelessWidget {
  const FeeFreeAmountCard({
    Key key,
    @required this.feeFreeAmount,
  }) : super(key: key);

  final double feeFreeAmount;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'fee_free_amount_card.fee_free_amount'.tr() + ': ',
            style: kCardSubTextStyle
          ),
          TextSpan(
            text: getInvestmentAsString(feeFreeAmount),
            style: kMinimumTransferCardTextStyle.copyWith(
                fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }
}
