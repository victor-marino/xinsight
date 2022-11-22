import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pageTitles[
              Provider.of<BottomNavigationBarProvider>(context, listen: true)
                  .currentIndex],
          //style: kTitleTextStyle,
          style: Theme.of(context).textTheme.headlineLarge,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }
}
