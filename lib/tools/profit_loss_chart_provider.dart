import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';

// Provider changing the evolution chart parameters
class ProfitLossChartProvider with ChangeNotifier {
  ChartSeriesType _seriesType = ChartSeriesType.returns;
  int _year = 2023;

  ChartSeriesType get seriesType => _seriesType;

  int get year => _year;

  set year(int newYear) {
    _year = newYear;
    notifyListeners();
  }

  set seriesType(ChartSeriesType type) {
    _seriesType = type;
    notifyListeners();
  }
}
