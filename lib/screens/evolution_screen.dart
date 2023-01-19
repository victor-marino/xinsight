import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/widgets/evolution_screen/evolution_chart_zoom_chips.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_chart.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_year_switcher.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/widgets/evolution_screen/evolution_chart.dart';

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
  _EvolutionScreenState createState() => _EvolutionScreenState();
}

class _EvolutionScreenState extends State<EvolutionScreen>
    with AutomaticKeepAliveClientMixin<EvolutionScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  Duration _evolutionChartSelectedPeriod = Duration(seconds: 0);
  bool _evolutionChartShowReturns = false;
  late int _profitLossChartSelectedYear;

  Future<void> _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      snackbar.showInSnackBar(context, e.toString());
    }
  }

  void _reloadEvolutionChart({Duration? period, bool? showReturns}) {
    // Called when any setting in the evolution chart is changed by the user
    if (period != null) {
      setState(() {
        _evolutionChartSelectedPeriod = period;
      });
    }
    if (showReturns != null) {
      setState(() {
        _evolutionChartShowReturns = showReturns;
      });
    }
  }

  void _reloadProfitLossChart(int year) {
    // Called when the user changes the year in the profit loss chart
    setState(() {
      _profitLossChartSelectedYear = year;
    });
  }

  void initState() {
    super.initState();
    // Show the current year by default in the profit loss chart
    _profitLossChartSelectedYear =
        widget.accountData.profitLossSeries.keys.toList().last;
  }

  // Zoom options for the evolution chart
  List<Map> _zoomLevels = [
    {"label": "1m", "duration": Duration(days: 30)},
    {"label": "3m", "duration": Duration(days: 90)},
    {"label": "6m", "duration": Duration(days: 180)},
    {"label": "1y", "duration": Duration(days: 365)},
    {"label": "5y", "duration": Duration(days: 1825)},
    {"label": "all", "duration": Duration(seconds: 0)},
  ];

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
                              paddingTop: 16,
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'evolution_screen.evolution'.tr(),
                                          textAlign: TextAlign.left,
                                          style: cardHeaderTextStyle,
                                        ),
                                        !_evolutionChartShowReturns
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: Icon(Icons.euro,
                                                        size: 20),
                                                  ),
                                                  Text(
                                                    " | ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        height: 0.9,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: Icon(
                                                        Icons.percent,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    onTap: () =>
                                                        _reloadEvolutionChart(
                                                            showReturns: true),
                                                  ),
                                                  SizedBox(width: 7)
                                                ],
                                              )
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: Icon(
                                                        Icons.euro,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    onTap: () =>
                                                        _reloadEvolutionChart(
                                                            showReturns: false),
                                                  ),
                                                  Text(
                                                    " | ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        height: 0.9,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                                  ),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: Icon(
                                                      Icons.percent,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 7)
                                                ],
                                              )
                                      ]),
                                  EvolutionChart(
                                      amountsSeries:
                                          widget.accountData.amountsSeries,
                                      returnsSeries:
                                          widget.accountData.returnsSeries,
                                      period: _evolutionChartSelectedPeriod,
                                      showReturns: _evolutionChartShowReturns),
                                  Container(
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
                                          selectedPeriod:
                                              _evolutionChartSelectedPeriod,
                                          zoomLevels: _zoomLevels,
                                          reloadEvolutionChart:
                                              _reloadEvolutionChart,
                                          context: context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
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
                                  Container(
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
