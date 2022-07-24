// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableSecondaryCard extends StatelessWidget {
  const ReusableSecondaryCard({
    Key? key,
    required this.childWidget,
  }) : super(key: key);
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: childWidget,
      ),
    );
  }
}