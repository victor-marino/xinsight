import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    Key? key,
    required this.childWidget,
    this.paddingTop = 15.0,
    this.paddingBottom = 15.0,
    this.paddingLeft = 15.0,
    this.paddingRight = 15.0,
  }) : super(key: key);
  final Widget childWidget;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      //color: Colors.white,
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom, left: paddingLeft, right: paddingRight),
        child: childWidget,
      ),
    );
  }
}