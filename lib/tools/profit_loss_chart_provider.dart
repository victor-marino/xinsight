import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';

// Provider changing the evolution chart parameters
class ProfitLossChartProvider with ChangeNotifier {
  ChartSeriesType _seriesType = ChartSeriesType.returns;
  late int currentYear;

  ChartSeriesType get seriesType => _seriesType;

  void updateCurrentYear(int newYear) {
    currentYear = newYear;
    notifyListeners();
  }

  set seriesType(ChartSeriesType type) {
    _seriesType = type;
    notifyListeners();
  }
}
