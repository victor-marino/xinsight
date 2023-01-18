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
List<Color> equityColors = [
  Colors.purple.shade800,
  Colors.purple.shade700,
  Colors.purple.shade600,
  Colors.purple.shade500,
  Colors.purple.shade400,
  Colors.purple.shade300,
  Colors.purple.shade200,
  Colors.purple.shade100,
  Colors.purple.shade50,
];
List<Color> fixedColors = [
  Colors.indigo.shade800,
  Colors.indigo.shade700,
  Colors.indigo.shade600,
  Colors.indigo.shade500,
  Colors.indigo.shade400,
  Colors.indigo.shade300,
  Colors.indigo.shade200,
  Colors.indigo.shade100,
  Colors.indigo.shade50
];
Color cashColor = Colors.grey;
Color otherColor = Colors.black12;
