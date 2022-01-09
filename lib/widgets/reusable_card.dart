import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    Key key,
    @required this.childWidget,
    this.padding = 15.0,
  }) : super(key: key);
  final Widget childWidget;
  final double padding;

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: childWidget,
      ),
    );
  }
}