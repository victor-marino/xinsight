import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle roboto(double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: size,
    ),
  );
}

TextStyle robotoBold(double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle ubuntu(double size) {
  return GoogleFonts.ubuntu(
    textStyle: TextStyle(
      fontSize: size,
    ),
  );
}

TextStyle ubuntuBold(double size) {
  return GoogleFonts.ubuntu(
    textStyle: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
  );
}

List<Color?> equityColors = [
  Colors.purple[800],
  Colors.purple[700],
  Colors.purple[600],
  Colors.purple[500],
  Colors.purple[400],
  Colors.purple[300],
  Colors.purple[200],
  Colors.purple[100],
  Colors.purple[50],
];
List<Color?> fixedColors = [
  Colors.indigo[800],
  Colors.indigo[700],
  Colors.indigo[600],
  Colors.indigo[500],
  Colors.indigo[400],
  Colors.indigo[300],
  Colors.indigo[200],
  Colors.indigo[100],
  Colors.indigo[50]
];
Color cashColor = Colors.grey;
Color otherColor = Colors.black12;
