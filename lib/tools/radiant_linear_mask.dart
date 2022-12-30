import 'package:flutter/material.dart';

// Gradient mask used for the legend icons in distribution chart

class RadiantLinearMask extends StatelessWidget {
  RadiantLinearMask({this.child, this.color1, this.color2});
  final Widget? child;
  final Color? color1;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [color1!, color2!],
      ).createShader(bounds),
      child: child,
    );
  }
}