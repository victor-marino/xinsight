// import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/snackbar.dart' as snackbar;
import 'package:indexax/widgets/evolution_screen/evolution_chart_zoom_chips.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_chart.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_year_switcher.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widgets/evolution_screen/evolution_chart.dart';

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
  final Account? accountData;
  final List<Map<String, String>>? userAccounts;
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
  int? _profitLossChartSelectedYear;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
      _refreshController.refreshCompleted();
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      snackbar.showInSnackBar(context, e.toString());
    }
  }

  void _reloadEvolutionChart({Duration? period, bool? showReturns}) {
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
    setState(() {
      _profitLossChartSelectedYear = year;
    });
  }

  void initState() {
    super.initState();
    _profitLossChartSelectedYear =
        widget.accountData!.profitLossSeries.keys.toList().last;
  }

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

    //print(widget.availableWidth);
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
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          children: <Widget>[
                            ReusableCard(
                              paddingBottom:
                                  widget.landscapeOrientation ? 16 : 8,
                              //paddingTop: widget.landscapeOrientation ? 8 : 16,
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
                                          // style: kCardTitleTextStyle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        !_evolutionChartShowReturns
                                            ? Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: Icon(
                                                      Icons.euro,
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
                                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                          widget.accountData!.amountsSeries,
                                      returnsSeries:
                                          widget.accountData!.returnsSeries,
                                      period: _evolutionChartSelectedPeriod,
                                      showReturns: _evolutionChartShowReturns),
                                  //if (!widget.landscapeOrientation) ...[
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
                                  //],
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
                                          //style: kCardTitleTextStyle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                      ProfitLossYearSwitcher(
                                          currentYear:
                                              _profitLossChartSelectedYear,
                                          yearList: widget.accountData!
                                              .profitLossSeries.keys
                                              .toList(),
                                          reloadProfitLossChart:
                                              _reloadProfitLossChart),
                                    ],
                                  ),
                                  Container(
                                    height: 150,
                                    child: ProfitLossChart(
                                        profitLossSeries: widget
                                            .accountData!.profitLossSeries,
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
