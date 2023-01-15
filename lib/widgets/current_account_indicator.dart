import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Text showing the current account at the top of the page.
// First line shows the account number, second line shows the account type.
class CurrentAccountIndicator extends StatelessWidget {
  const CurrentAccountIndicator({
    Key? key,
    required this.accountNumber,
    required this.accountType,
  }) : super(key: key);

  final String accountNumber;
  final String accountType;

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
          accountNumber,
          style: Theme.of(context).textTheme.titleSmall,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        Text(
          accountTypeText.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }
}