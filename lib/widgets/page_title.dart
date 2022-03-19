import 'package:flutter/material.dart';
import 'package:indexax/tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> pageTitles = [
      'page_titles.overview'.tr(),
      'page_titles.portfolio'.tr(),
      'page_titles.evolution'.tr(),
      'page_titles.transactions'.tr(),
      'page_titles.projection'.tr(),
    ];
    return Text(
      pageTitles[Provider.of<BottomNavigationBarProvider>(context, listen: true)
          .currentIndex],
      style: kTitleTextStyle,
    overflow: TextOverflow.fade,
    maxLines: 1,
    softWrap: false,
    );
  }
}