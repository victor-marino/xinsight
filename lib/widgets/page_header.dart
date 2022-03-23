import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key key,
    @required this.accountNumber,
    @required this.accountType,
  }) : super(key: key);

  final String accountNumber;
  final String accountType;

  @override
  Widget build(BuildContext context) {
    String accountTypeText;

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

    List<String> pageTitles = [
      'page_titles.overview'.tr(),
      'page_titles.portfolio'.tr(),
      'page_titles.evolution'.tr(),
      'page_titles.transactions'.tr(),
      'page_titles.projection'.tr(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pageTitles[
              Provider.of<BottomNavigationBarProvider>(context, listen: true)
                  .currentIndex],
          style: kTitleTextStyle,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        Text(
          accountNumber != null
              //? 'header.account'.tr().toUpperCase() + " " + accountNumber : "",
              ? accountNumber : "",
          style: kAccountNumberTextStyle.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        Text(
          accountType != null ? accountTypeText.toUpperCase() : "",
          style: kAccountNumberTextStyle,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }
}
