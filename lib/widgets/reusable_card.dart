import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    Key key,
    @required this.childWidget,
    this.flatTop,
    this.flatBottom,
  }) : super(key: key);
  final Widget childWidget;
  final bool flatTop;
  final bool flatBottom;

  @override
  Widget build(BuildContext context) {
    double topRadius = 20;
    double bottomRadius = 20;
    if (flatTop != null && flatTop == true) {
      topRadius = 0;
    }
    if (flatBottom != null && flatBottom == true) {
      bottomRadius = 0;
    }
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(bottomRadius)),
        //borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: childWidget,
      ),
    );
  }
}