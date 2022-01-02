import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MyBottomNavigationBar extends StatelessWidget {
  @override
  const MyBottomNavigationBar({
    Key key,
    @required this.onTapped,
  }) : super(key: key);
  final Function onTapped;

  Widget build(BuildContext context) {

    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black54,

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'page_titles.portfolio'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.assessment), label: 'page_titles.evolution'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.list), label: 'page_titles.transactions'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), label: 'page_titles.projection'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.history), label: 'page_titles.stats'.tr()),
      ],
      onTap: onTapped,
      currentIndex:
          Provider.of<BottomNavigationBarProvider>(context).currentIndex,
    );
  }
}
