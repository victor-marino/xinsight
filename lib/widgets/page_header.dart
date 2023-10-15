import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/bottom_navigation_bar_provider.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Header showing the current section of the app

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle pageTitleTextStyle = text_styles.oxygenBold(context, 33);

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
              context.watch<BottomNavigationBarProvider>()
                  .currentIndex],
          style: pageTitleTextStyle,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }
}
