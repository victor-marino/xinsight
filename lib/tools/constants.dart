import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String SYNCFUSION_LICENSE = 'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmglOjAnPCE+MiE6PTwTND4yOj99MDw+';

TextStyle kTitleTextStyle = GoogleFonts.oxygen(
  textStyle: TextStyle(
    fontSize: 33.0,
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
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kCardPLTextStyle = GoogleFonts.ubuntu(
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kCardPLTextStyleSmaller = GoogleFonts.ubuntu(
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kCardPrimaryContentTextStyleSmaller = GoogleFonts.ubuntu(
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

TextStyle kPopUpTitleTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kPopUpSubtitleTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kPopUpNormalTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black54,
  ),
);

TextStyle kPopUpFootnoteTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.grey,
    fontStyle: FontStyle.italic,
    //fontSize: 14,
  ),
);

TextStyle kLoginErrorsTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    //fontSize: 14,
  ),
);

TextStyle kAccountSwitcherTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    //fontWeight: FontWeight.bold,
    fontSize: 15.0,
  ),
);

TextStyle kAccountSwitcherSelectedTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 15.0,
  ),
);

TextStyle kAccountSwitcherDisabledSelectedTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 17.0,
  ),
);

TextStyle kChartLabelTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 9.0,
  ),
);

Decoration kEnabledAccountSwitcherBoxDecoration = ShapeDecoration(
  color: Colors.blueGrey[100],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
);

TextStyle kLegendMainTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 12.0,
  ),
);

TextStyle kLegendSecondaryTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.grey,
    fontSize: 12.0,
  ),
);

TextStyle kProfitLossChartLabelTextStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 10.0,
  ),
);

Decoration kDisabledAccountSwitcherBoxDecoration = ShapeDecoration(
//color: Colors.blueGrey[100],
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.all(Radius.circular(20.0)),
));

List<Color> equityColors = [Colors.purple[400], Colors.purple[300], Colors.purple[200], Colors.purple[100], Colors.purple[50]];
List<Color> fixedColors = [Colors.indigo[400], Colors.indigo[300], Colors.indigo[200], Colors.indigo[100]];
Color cashColor = Colors.blueGrey;
Color otherColor = Colors.black12;