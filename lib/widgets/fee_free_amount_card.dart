import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';

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
            text: "Activos gestionados gratis: ",
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
