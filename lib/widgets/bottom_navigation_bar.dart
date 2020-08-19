import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tools/bottom_navigation_bar_provider.dart';

class MyBottomNavigationBar extends StatelessWidget {
  @override
  const MyBottomNavigationBar({
    Key key,
    @required this.onTapped,
  }) : super(key: key);
  final Function onTapped;

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Inicio')),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), title: Text('Desempeño')),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), title: Text('Ajustes')),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.compare_arrows), title: Text('Transactions'))
      ],
      onTap: onTapped,
      currentIndex:
          Provider.of<BottomNavigationBarProvider>(context).currentIndex,
    );
  }
}
