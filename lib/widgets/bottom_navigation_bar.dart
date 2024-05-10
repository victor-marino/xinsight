import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/bottom_navigation_bar_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MyBottomNavigationBar extends StatelessWidget {
  @override
  const MyBottomNavigationBar({
    super.key,
    required this.onTapped,
  });
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,

      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.pie_chart), label: 'page_titles.overview'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.list), label: 'page_titles.portfolio'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.assessment), label: 'page_titles.evolution'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.sync_alt), label: 'page_titles.transactions'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up), label: 'page_titles.projection'.tr()),
      ],
      onTap: onTapped as void Function(int)?,
      currentIndex:
          context.watch<BottomNavigationBarProvider>().currentIndex,
    );
  }
}
