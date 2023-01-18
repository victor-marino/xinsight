//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// These functions can be called from anywhere in the app to pick a text style.
// Fontsize is passed as an argument to avoid creating too many text styles.
// By passing the BuildContext as an argument, the function can also return
// the correct onSurface/onSurfaceVariant color based on the active theme.
TextStyle oxygenBold(BuildContext context, double size) {
  return GoogleFonts.oxygen(
      textStyle: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface));
}

TextStyle roboto(BuildContext context, double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
        fontSize: size, color: Theme.of(context).colorScheme.onSurface),
  );
}

TextStyle robotoBold(BuildContext context, double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface),
  );
}

TextStyle robotoLighter(BuildContext context, double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
        fontSize: size, color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

TextStyle robotoBoldLighter(BuildContext context, double size) {
  return GoogleFonts.roboto(
    textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

TextStyle ubuntu(BuildContext context, double size) {
  return GoogleFonts.ubuntu(
    textStyle: TextStyle(
        fontSize: size, color: Theme.of(context).colorScheme.onSurface),
  );
}

TextStyle ubuntuBold(BuildContext context, double size) {
  return GoogleFonts.ubuntu(
    textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface),
  );
}

TextStyle ubuntuLighter(BuildContext context, double size) {
  return GoogleFonts.ubuntu(
    textStyle: TextStyle(
        fontSize: size, color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

TextStyle ubuntuBoldLighter(BuildContext context, double size) {
  return GoogleFonts.ubuntu(
    textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

// These are the colors used by the distribution chart in the overview screen.
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
