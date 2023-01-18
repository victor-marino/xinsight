import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

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
    TextStyle accountNumberTextStyle =
        text_styles.robotoBoldLighter(context, 15);
    TextStyle accountTypeTextStyle = text_styles.robotoLighter(context, 15);

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
          style: accountNumberTextStyle,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        Text(
          accountTypeText.toUpperCase(),
          style: accountTypeTextStyle,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }
}
