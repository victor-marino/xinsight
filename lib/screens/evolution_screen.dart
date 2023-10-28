import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/widgets/evolution_screen/evolution_chart_zoom_chips.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_chart.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_year_switcher.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/widgets/evolution_screen/evolution_chart.dart';
import 'package:provider/provider.dart';
import 'package:indexax/tools/evolution_chart_provider.dart';
import 'package:indexax/widgets/evolution_screen/evolution_series_type_toggle.dart';

class EvolutionScreen extends StatefulWidget {
  const EvolutionScreen({
    Key? key,
    required this.accountData,
    required this.userAccounts,
    required this.refreshData,
    required this.currentAccountIndex,
    required this.landscapeOrientation,
    required this.availableWidth,
  }) : super(key: key);
  final Account accountData;
  final List<Map<String, String>> userAccounts;
  final Function refreshData;
  final int currentAccountIndex;
  final bool landscapeOrientation;
  final double availableWidth;

  @override
  EvolutionScreenState createState() => EvolutionScreenState();
}

class EvolutionScreenState extends State<EvolutionScreen>
    with AutomaticKeepAliveClientMixin<EvolutionScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  late int _profitLossChartSelectedYear;

  TextEditingController evolutionChartDateTextController =
      TextEditingController();

  Future<void> _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Couldn't refresh data");
        print(e);
      }
      if (mounted) snackbar.showInSnackBar(context, e.toString());
    }
  }

  void _reloadProfitLossChart(int year) {
    // Called when the user changes the year in the profit loss chart
    setState(() {
      _profitLossChartSelectedYear = year;
    });
  }

  Future<void> _selectEvolutionChartDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: context.read<EvolutionChartProvider>().firstDate,
      lastDate: context.read<EvolutionChartProvider>().lastDate,
      initialDateRange: DateTimeRange(
          start: context.read<EvolutionChartProvider>().startDate,
          end: context.read<EvolutionChartProvider>().endDate),
    );
    if (picked != null && mounted) {
      context.read<EvolutionChartProvider>().updateStartDate(picked.start);
      context.read<EvolutionChartProvider>().updateEndDate(picked.end);
    }
  }

  @override
  void initState() {
    super.initState();
    // Set the first and last dates of the series in the Evolution Chart Provider
    context.read<EvolutionChartProvider>().firstDate =
        widget.accountData.amountsSeries.first.date;
    context.read<EvolutionChartProvider>().lastDate =
        widget.accountData.amountsSeries.last.date;
    context.read<EvolutionChartProvider>().startDate =
        widget.accountData.amountsSeries.first.date;
    context.read<EvolutionChartProvider>().endDate =
        widget.accountData.amountsSeries.last.date;
    context.read<EvolutionChartProvider>().updateRangeSelectorText(context);
    // Show the current year by default in the profit loss chart
    _profitLossChartSelectedYear =
        widget.accountData.profitLossSeries.keys.toList().last;
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    TextStyle cardHeaderTextStyle = text_styles.robotoLighter(context, 15);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: widget.landscapeOrientation && widget.availableWidth > 1000
                ? widget.availableWidth * 0.7
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          children: <Widget>[
                            ReusableCard(
                              paddingBottom:
                                  widget.landscapeOrientation ? 16 : 8,
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'evolution_screen.evolution'.tr(),
                                          textAlign: TextAlign.left,
                                          style: cardHeaderTextStyle,
                                        ),
                                        evolutionSeriesTypeToggle(context)
                                      ]),
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4, right: 5),
                                          child: Icon(
                                              Icons.calendar_month_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20),
                                        ),
                                        IntrinsicWidth(
                                          child: TextField(
                                            controller: TextEditingController(
                                                text: context
                                                    .watch<
                                                        EvolutionChartProvider>()
                                                    .rangeSelectorText),
                                            style:
                                                const TextStyle(fontSize: 13),
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 12),
                                            ),
                                            showCursor: false,
                                            autofocus: true,
                                            readOnly: true,
                                            enableInteractiveSelection: false,
                                            scrollPadding: EdgeInsets.zero,
                                            onTap: () {
                                              _selectEvolutionChartDateRange(
                                                  context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  EvolutionChart(
                                      amountsSeries:
                                          widget.accountData.amountsSeries,
                                      returnsSeries:
                                          widget.accountData.returnsSeries),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: widget.availableWidth < 500 ||
                                              widget.landscapeOrientation ==
                                                  false
                                          ? WrapAlignment.center
                                          : WrapAlignment.end,
                                      spacing: 5,
                                      children: evolutionChartZoomChips(
                                          context: context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ReusableCard(
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('evolution_screen.returns'.tr(),
                                          textAlign: TextAlign.left,
                                          style: cardHeaderTextStyle),
                                      ProfitLossYearSwitcher(
                                          currentYear:
                                              _profitLossChartSelectedYear,
                                          yearList: widget
                                              .accountData.profitLossSeries.keys
                                              .toList(),
                                          reloadProfitLossChart:
                                              _reloadProfitLossChart),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: ProfitLossChart(
                                        profitLossSeries:
                                            widget.accountData.profitLossSeries,
                                        selectedYear:
                                            _profitLossChartSelectedYear),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
