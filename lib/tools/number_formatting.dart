import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'dart:ui' as ui;

String getCurrentLocale() {
  final locale = ui.window.locale;
  final joined = "${locale.languageCode}_${locale.countryCode}";
  if (numberFormatSymbols.keys.contains(joined)) {
    return joined;
  }
  return locale.languageCode;
}

String getBalanceAsString(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  return numberString;
}

String getWholeBalanceAsString(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  return numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[0];
}

String getFractionalBalanceAsString(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  return numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[1];
}

String getInvestmentAsString(num number) {
  int decimalPlaces;
  if (number == number.roundToDouble()) {
    decimalPlaces = 0;
  } else {
    decimalPlaces = 2;
  }
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: decimalPlaces)
      .format(number);
  return numberString;
}

String getAmountAsStringWithTwoDecimals(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
      .format(number);
  return numberString;
}

String getAmountAsStringWithMaxDecimals(num number) {
  int numberOfDecimals = number.toString().split(".")[1].length;
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(),
          symbol: '€',
          decimalDigits: numberOfDecimals)
      .format(number);
  return numberString;
}

String getAmountAsStringWithZeroDecimals(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '€', decimalDigits: 0)
      .format(number);
  return numberString;
}

String getNumberAsStringWithMaxDecimals(num number) {
  int numberOfDecimals = number.toString().split(".")[1].length;
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(),
          symbol: '',
          decimalDigits: numberOfDecimals)
      .format(number);
  return numberString;
}

String getNumberAsStringWithTwoDecimals(num number) {
  String numberString = NumberFormat.currency(
          locale: getCurrentLocale(), symbol: '', decimalDigits: 2)
      .format(number);
  return numberString;
}

String getPLAsString(num number) {
  String numberString;
  if (number < 0) {
    numberString = NumberFormat.currency(
            locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
        .format(number);
  } else {
    numberString = '+' +
        NumberFormat.currency(
                locale: getCurrentLocale(), symbol: '€', decimalDigits: 2)
            .format(number);
  }
  return numberString;
}

String getPercentAsString(num number) {
  String numberString = NumberFormat.decimalPercentPattern(
          locale: getCurrentLocale(), decimalDigits: 1)
      .format(number);
  if (numberString[numberString.length - 2] == '\u00A0') {
    return (numberString.substring(0, numberString.length - 2) + "%");
  }
  return numberString;
}

String getWholePercentWithoutPercentSignAsString(num number) {
  String numberString = (number * 100).toStringAsFixed(0);
  return numberString;
}

String getPLPercentAsString(num number) {
  String numberString;
  if (number < 0) {
    numberString = NumberFormat.decimalPercentPattern(
            locale: getCurrentLocale(), decimalDigits: 1)
        .format(number);
  } else {
    numberString = '+' +
        NumberFormat.decimalPercentPattern(
                locale: getCurrentLocale(), decimalDigits: 1)
            .format(number);
  }
  if (numberString[numberString.length - 2] == '\u00A0') {
    return (numberString.substring(0, numberString.length - 2) + "%");
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
    numberString = '+' +
        NumberFormat.decimalPercentPattern(
                locale: getCurrentLocale(), decimalDigits: 1)
            .format(number);
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
    numberString = '+' +
        NumberFormat.decimalPercentPattern(
                locale: getCurrentLocale(), decimalDigits: 1)
            .format(number);
  }
  numberString = numberString
      .split(numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "")[1];

  if (numberString[numberString.length - 2] == '\u00A0') {
    return (numberString.substring(0, numberString.length - 2) + "%");
  }
  return numberString;
}

String getDecimalSeparator() {
  return numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "";
}
