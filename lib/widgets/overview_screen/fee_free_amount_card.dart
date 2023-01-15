import 'package:flutter/material.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:easy_localization/easy_localization.dart';

// Text showing the fee-free assets due to referral promotions

class FeeFreeAmountCard extends StatelessWidget {
  const FeeFreeAmountCard({
    Key? key,
    required this.feeFreeAmount,
  }) : super(key: key);

  final double feeFreeAmount;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'fee_free_amount_card.fee_free_amount'.tr() + ': ',
            style: Theme.of(context).textTheme.labelLarge
          ),
          TextSpan(
            text: getInvestmentAsString(feeFreeAmount),
            style: Theme.of(context).textTheme.titleSmall
          ),
        ],
      ),
    );
  }
}
