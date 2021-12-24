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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black54,

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Cartera'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assessment), label: 'Evolución'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list), label: 'Movimientos'),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), label: 'Proyección'),
        BottomNavigationBarItem(
            icon: Icon(Icons.history), label: 'Estadísticas'),
      ],
      onTap: onTapped,
      currentIndex:
          Provider.of<BottomNavigationBarProvider>(context).currentIndex,
    );
  }
}
