import 'package:flutter/material.dart';
import 'package:indexax/models/chart_series_type.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/evolution_chart_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget evolutionSeriesRangeSelector(BuildContext context) {
  return Container(
    child: SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.extendableRange,
    ),
  );
}
