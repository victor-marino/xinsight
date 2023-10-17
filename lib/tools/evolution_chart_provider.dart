import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';

// Provider changing the evolution chart parameters
class EvolutionChartProvider with ChangeNotifier {
  ChartSeriesType _seriesType = ChartSeriesType.amounts;
  Duration? _zoomLevel = const Duration(seconds: 0);
  DateTime? _firstDate;
  DateTime? _lastDate;
  DateTime? _startDate;
  DateTime? _endDate;

  ChartSeriesType get seriesType => _seriesType;

  Duration? get zoomLevel => _zoomLevel;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  set seriesType(ChartSeriesType type) {
    _seriesType = type;
    notifyListeners();
  }

  set firstDate(DateTime date) {
    _firstDate = date;
  }

  set lastDate(DateTime date) {
    _lastDate = date;
  }

  set setPeriod(Duration period) {
    if (period == const Duration(seconds: 0)) {
      _startDate = _firstDate;
      _endDate = _lastDate;
    } else if (_lastDate!.subtract(period).isBefore(_firstDate!)) {
      _startDate = _firstDate;
    } else {
      _startDate = _lastDate!.subtract(period);
      _endDate = _lastDate;
    }
    _zoomLevel = period;
    notifyListeners();
  }
}
