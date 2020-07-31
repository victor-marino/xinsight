import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String SYNCFUSION_LICENSE = 'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmglOjAnPCE+MiE6PTwTND4yOj99MDw+';

TextStyle kTitleTextStyle = GoogleFonts.oxygen(
  textStyle: TextStyle(
    fontSize: 35.0,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kCardTitleTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.grey,
    fontSize: 15.0,
  ),
);

TextStyle kCardPrimaryContentTextStyle = GoogleFonts.ubuntu(
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kCardSecondaryContentTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kCardSubTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.grey,
    fontSize: 15.0,
  ),
);

List<Color> equityColors = [Colors.purple[400], Colors.purple[300], Colors.purple[200], Colors.purple[100], Colors.purple[50]];
List<Color> fixedColors = [Colors.indigo[400], Colors.indigo[300], Colors.indigo[200], Colors.indigo[100]];
Color cashColor = Colors.blueGrey;
Color otherColor = Colors.black12;