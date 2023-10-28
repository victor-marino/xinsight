import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:intl/intl.dart';

// Provider changing the evolution chart parameters
class EvolutionChartProvider with ChangeNotifier {
  ChartSeriesType _seriesType = ChartSeriesType.amounts;
  Duration? _zoomLevel = const Duration(seconds: 0);
  late DateTime firstDate;
  late DateTime lastDate;
  late DateTime startDate;
  late DateTime endDate;
  late String rangeSelectorText;

  ChartSeriesType get seriesType => _seriesType;

  Duration? get zoomLevel => _zoomLevel;

  void triggerListenersUpdate() {
    notifyListeners();
  }

  void updateStartDate(DateTime date) {
    startDate = date;
    _zoomLevel = null;
    notifyListeners();
  }

  void updateEndDate(DateTime date) {
    endDate = date;
    _zoomLevel = null;
    notifyListeners();
  }

  set seriesType(ChartSeriesType type) {
    _seriesType = type;
    notifyListeners();
  }

  void updateRangeSelectorText(BuildContext context) {
    String startDateText = DateFormat.yMd(getCurrentLocale()).format(startDate);
    String endDateText = DateFormat.yMd(getCurrentLocale()).format(endDate);
    rangeSelectorText = "$startDateText - $endDateText";
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
