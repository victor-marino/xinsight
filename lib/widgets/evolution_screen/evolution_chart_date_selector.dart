import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/evolution_chart_provider.dart';
        
Future<void> _selectEvolutionChartStartDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: context.read<EvolutionChartProvider>().firstDate,
      lastDate: context
          .read<EvolutionChartProvider>()
          .lastDate
          .subtract(const Duration(days: 1)),
      initialDate: context.read<EvolutionChartProvider>().startDate,
      helpText: 'evolution_screen.select_start_date'.tr());
  if (pickedDate != null && context.mounted) {
    context.read<EvolutionChartProvider>().updateStartDate(pickedDate);
  }
}

Future<void> _selectEvolutionChartEndDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: context
          .read<EvolutionChartProvider>()
          .firstDate
          .add(const Duration(days: 1)),
      lastDate: context.read<EvolutionChartProvider>().lastDate,
      initialDate: context.read<EvolutionChartProvider>().endDate,
      helpText: 'evolution_screen.select_end_date'.tr());
  if (pickedDate != null && context.mounted) {
    context.read<EvolutionChartProvider>().updateEndDate(pickedDate);
  }
}

Widget showEvolutionSeriesDateSelector(BuildContext context) {
  TextEditingController evolutionChartStartDateTextController =
      TextEditingController(
          text: getShortDateAsString(
              context.read<EvolutionChartProvider>().startDate));
  TextEditingController evolutionChartEndDateTextController =
      TextEditingController(
          text: getShortDateAsString(
              context.read<EvolutionChartProvider>().endDate));

  return SizedBox(
      height: 23,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 5),
            child: Icon(Icons.calendar_month_rounded,
                color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          IntrinsicWidth(
            child: TextField(
              controller: evolutionChartStartDateTextController,
              style: const TextStyle(fontSize: 13),
              textAlignVertical: TextAlignVertical.center,
              cursorWidth: 0,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 17),
                border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              showCursor: false,
              autofocus: true,
              readOnly: true,
              enableInteractiveSelection: false,
              scrollPadding: EdgeInsets.zero,
              onTap: () {
                _selectEvolutionChartStartDate(context);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(" - "),
          ),
          IntrinsicWidth(
            child: TextField(
              controller: evolutionChartEndDateTextController,
              style: const TextStyle(fontSize: 13),
              textAlignVertical: TextAlignVertical.center,
              cursorWidth: 0,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 17),
                border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              showCursor: false,
              autofocus: true,
              readOnly: true,
              enableInteractiveSelection: false,
              scrollPadding: EdgeInsets.zero,
              onTap: () {
                _selectEvolutionChartEndDate(context);
              },
            ),
          ),
        ],
      ),
    );
}
