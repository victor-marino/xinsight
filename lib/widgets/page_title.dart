import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> pageTitles = [
      "Cartera",
      "Evolución",
      "Movimientos",
      "Proyección",
      "Estadísticas"
    ];
    return Text(
      pageTitles[Provider.of<BottomNavigationBarProvider>(context, listen: true)
          .currentIndex],
      style: kTitleTextStyle,
    );
  }
}