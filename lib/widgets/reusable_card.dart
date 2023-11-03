import 'package:flutter/material.dart';

// Reusable card widget on which most of the app content is drawn.
// Optionally accepts custom padding values, as they're needed in some cases.

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
  final double paddingTop, paddingBottom, paddingLeft, paddingRight;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.only(
            top: paddingTop,
            bottom: paddingBottom,
            left: paddingLeft,
            right: paddingRight),
        child: childWidget,
      ),
    );
  }
}
