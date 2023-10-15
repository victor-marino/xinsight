import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';

// Text showing the fee-free assets due to referral promotions

class FeeFreeAmountCard extends StatelessWidget {
  const FeeFreeAmountCard({
    Key? key,
    required this.feeFreeAmount,
  }) : super(key: key);

  final double feeFreeAmount;

  @override
  Widget build(BuildContext context) {
    TextStyle itemNameText = text_styles.robotoLighter(context, 15);
    TextStyle itemValueText = text_styles.robotoBoldLighter(context, 15);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: '${'fee_free_amount_card.fee_free_amount'.tr()}: ',
              style: itemNameText),
          TextSpan(
              text: getInvestmentAsString(feeFreeAmount,
                  maskValue:
                      context.watch<PrivateModeProvider>().privateModeEnabled),
              style: itemValueText),
        ],
      ),
    );
  }
}
