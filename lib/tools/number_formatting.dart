import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:flutter/material.dart';

// All operations regarding number and string formatting are grouped here

String getCurrentLocale() {
  final locale = WidgetsBinding.instance.platformDispatcher.locale;

  final joined = "${locale.languageCode}_${locale.countryCode}";
  if (numberFormatSymbols.keys.contains(joined)) {
    return joined;
  }
  return locale.languageCode;
}

double getDoubleWithTwoDecimalPlaces(double number) {
  return (number * 100).toInt() / 100;
}

Color getNumberColor(double variable) {
  if (variable < 0) {
    return Colors.red;
  } else {
    return Colors.green;
  }
}

String getBalanceAsString(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  return numberString;
}

String getWholeBalanceAsString(num? number, {bool maskValue = false}) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  numberString = numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[0];

  if (maskValue) numberString = maskMonetaryString(numberString);

  return numberString;
}

String getFractionalBalanceAsString(num? number, {bool maskValue = false}) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  numberString = numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[1];

  if (maskValue) numberString = maskMonetaryString(numberString, length: 2);

  return numberString;
}

String getInvestmentAsString(num number, {bool maskValue = false}) {
  int decimalPlaces;
  if (number == number.roundToDouble()) {
    decimalPlaces = 0;
  } else {
    decimalPlaces = 2;
  }
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: decimalPlaces)
      .format(number);

  if (maskValue) numberString = maskMonetaryString(numberString);

  return numberString;
}

String getAmountAsStringWithTwoDecimals(num? number, {bool maskValue = false}) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);

  if (maskValue) numberString = maskMonetaryString(numberString);

  return numberString;
}

String getAmountAsStringWithMaxDecimals(num? number) {
  int numberOfDecimals = number.toString().split(".")[1].length;
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(),
          symbol: '€',
          decimalDigits: numberOfDecimals)
      .format(number);
  return numberString;
}

String getAmountAsStringWithZeroDecimals(num number, {bool maskValue = false}) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 0)
      .format(number);

  if (maskValue) numberString = maskMonetaryString(numberString);

  return numberString;
}

String getNumberAsStringWithMaxDecimals(num? number, {bool maskValue = false}) {
  int numberOfDecimals = number.toString().split(".")[1].length;
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(),
          symbol: '',
          decimalDigits: numberOfDecimals)
      .format(number);

  if (maskValue) numberString = maskMonetaryString(numberString);
  return numberString;
}

String getNumberAsStringWithTwoDecimals(num? number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '', decimalDigits: 2)
      .format(number);
  return numberString;
}

String getPLAsString(num number, {bool maskValue = false}) {
  String numberString;
  if (number < 0) {
    numberString = NumberFormat.currency(
            locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
        .format(number);
  } else {
    numberString =
        '+${NumberFormat.currency(locale: getCurrentLocale(), symbol: '€', decimalDigits: 2).format(number)}';
  }
  if (maskValue) numberString = maskMonetaryString(numberString);

  return numberString;
}

String getPercentAsString(num? number) {
  String numberString = NumberFormat.decimalPercentPattern(
          locale: getCurrentLocale(), decimalDigits: 1)
      .format(number);
  if (numberString[numberString.length - 2] == '\u00A0') {
    return ("${numberString.substring(0, numberString.length - 2)}%");
  }
  return numberString;
}

String getWholePercentWithoutPercentSignAsString(num number) {
  String numberString = (number * 100).toStringAsFixed(0);
  return numberString;
}

String getWholePercentWithPercentSignAsString(num number) {
  String numberString = "${(number * 100).toStringAsFixed(0)}%";
  return numberString;
}

String getPLPercentAsString(num number) {
  String numberString;
  if (number < 0) {
    numberString = NumberFormat.decimalPercentPattern(
            locale: getCurrentLocale(), decimalDigits: 1)
        .format(number);
  } else {
    numberString =
        '+${NumberFormat.decimalPercentPattern(locale: getCurrentLocale(), decimalDigits: 1).format(number)}';
  }
  if (numberString[numberString.length - 2] == '\u00A0') {
    return ("${numberString.substring(0, numberString.length - 2)}%");
  }
  return numberString;
}

String getWholePLPercentAsString(num number) {
  String numberString;
  if (number < 0) {
    numberString = NumberFormat.decimalPercentPattern(
            locale: getCurrentLocale(), decimalDigits: 1)
        .format(number);
  } else {
    numberString =
        '+${NumberFormat.decimalPercentPattern(locale: getCurrentLocale(), decimalDigits: 1).format(number)}';
  }
  return numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[0];
}

String getFractionalPLPercentAsString(num number) {
  String numberString;
  if (number < 0) {
    numberString = NumberFormat.decimalPercentPattern(
            locale: getCurrentLocale(), decimalDigits: 1)
        .format(number);
  } else {
    numberString =
        '+${NumberFormat.decimalPercentPattern(locale: getCurrentLocale(), decimalDigits: 1).format(number)}';
  }
  numberString = numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[1];

  if (numberString[numberString.length - 2] == '\u00A0') {
    return ("${numberString.substring(0, numberString.length - 2)}%");
  }
  return numberString;
}

String getDecimalSeparator() {
  return numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "";
}

String testParse(String amount) {
  return amount.substring(0, 2);
}

String maskMonetaryString(String text, {int length = 3}) {
  int firstDigit = text.split('').indexWhere((character) => isDigit(character));
  int lastDigit = text
      .split('')
      .lastIndexWhere((character) => character.codeUnitAt(0) ^ 0x30 <= 9);

  String maskedValue =
      text.replaceRange(firstDigit, lastDigit + 1, "•" * length);

  return maskedValue;
}

// Check if a character is a numerical digit
bool isDigit(String s) => (s.codeUnitAt(0) ^ 0x30) <= 9;
