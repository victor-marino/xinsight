import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';

// Provider changing the evolution chart parameters
class EvolutionChartProvider with ChangeNotifier {
  ChartSeriesType _seriesType = ChartSeriesType.amounts;
  Duration? _zoomLevel = const Duration(seconds: 0);
  late DateTime firstDate;
  late DateTime lastDate;
  late DateTime startDate;
  late DateTime endDate;

  ChartSeriesType get seriesType => _seriesType;

  Duration? get zoomLevel => _zoomLevel;

  void updateStartDate(DateTime date) {
    startDate = date;
    if (startDate.isAfter(endDate)) {
      endDate = startDate.add(const Duration(days: 1));
    }
    _zoomLevel = null;
    notifyListeners();
  }

  void updateEndDate(DateTime date) {
    endDate = date;
    if (endDate.isBefore(startDate)) {
      startDate = endDate.subtract(const Duration(days: 1));
    }
    _zoomLevel = null;
    notifyListeners();
  }

  set seriesType(ChartSeriesType type) {
    _seriesType = type;
    notifyListeners();
  }

  set setPeriod(Duration period) {
    if (period == const Duration(seconds: 0)) {
      startDate = firstDate;
      endDate = lastDate;
    } else if (lastDate.subtract(period).isBefore(firstDate)) {
      startDate = firstDate;
    } else {
      startDate = lastDate.subtract(period);
      endDate = lastDate;
    }
    _zoomLevel = period;
    notifyListeners();
  }
}
