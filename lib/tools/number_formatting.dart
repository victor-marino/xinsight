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
  String numberString = NumberFormat.currency(locale: getCurrentLocale(), symbol: '€', decimalDigits: 2).format(number);
  return numberString;
}

String getInvestmentAsString(num number) {
  int decimalPlaces;
  if (number == number.roundToDouble()) {
    decimalPlaces = 0;
  } else {
    decimalPlaces = 2;
  }
  String numberString = NumberFormat.currency(locale: getCurrentLocale(), symbol: '€', decimalDigits: decimalPlaces).format(number);
  return numberString;
}

String getPLAsString(num number) {
  String numberString;
  if (number <0) {
    numberString = '-' + NumberFormat.currency(locale: getCurrentLocale(), symbol: '€', decimalDigits: 2).format(number);
  } else {
    numberString = '+' + NumberFormat.currency(locale: getCurrentLocale(), symbol: '€', decimalDigits: 2).format(number);
  }
  return numberString;
}

String getPercentAsString(num number) {
  String numberString = NumberFormat.decimalPercentPattern(locale: getCurrentLocale(), decimalDigits: 1).format(number);
  return numberString;
}

String getPLPercentAsString(num number) {
  String numberString;
  if (number < 0) {
    numberString = '-' + NumberFormat.decimalPercentPattern(
        locale: getCurrentLocale(), decimalDigits: 1).format(number);
  } else {
    numberString = '+' + NumberFormat.decimalPercentPattern(locale: getCurrentLocale(), decimalDigits: 1).format(number);
  }
  return numberString;
}