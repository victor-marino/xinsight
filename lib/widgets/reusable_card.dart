import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    Key key,
    @required this.childWidget,
  }) : super(key: key);
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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