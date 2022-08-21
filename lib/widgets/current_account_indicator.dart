import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class CurrentAccountIndicator extends StatelessWidget {
  const CurrentAccountIndicator({
    Key? key,
    required this.accountNumber,
    required this.accountType,
  }) : super(key: key);

  final String? accountNumber;
  final String? accountType;

  @override
  Widget build(BuildContext context) {

    String? accountTypeText;

    switch (accountType) {
      case 'mutual':
        accountTypeText = 'header.mutual_account'.tr();
        break;
      case 'pension':
        accountTypeText = 'header.pension_account'.tr();
        break;
      case 'epsv':
        accountTypeText = 'header.epsv_account'.tr();
        break;
      case 'employment_plan':
        accountTypeText = 'header.employment_plan_account'.tr();
        break;
      default:
        accountTypeText = accountType;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          accountNumber != null
              ? accountNumber!
              : "",
          style: kAccountNumberTextStyle.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        Text(
          accountType != null ? accountTypeText!.toUpperCase() : "",
          style: kAccountNumberTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }
}