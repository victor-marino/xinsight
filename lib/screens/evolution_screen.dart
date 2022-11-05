// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/widgets/reusable_card.dart';
import '../widgets/evolution_screen/amounts_chart.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_chart.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_year_switcher.dart';
import 'package:indexax/widgets/evolution_screen/amounts_chart_zoom_chips.dart';
import 'package:indexax/tools/theme_operations.dart' as theme_operations;

class EvolutionScreen extends StatefulWidget {
  const EvolutionScreen({
    Key? key,
    required this.accountData,
    required this.userAccounts,
    required this.refreshData,
    required this.reloadPage,
    required this.currentAccountNumber,
    required this.landscapeOrientation,
    required this.availableWidth,
  }) : super(key: key);
  final Account? accountData;
  final List<Map<String, String>>? userAccounts;
  final Function refreshData;
  final Function reloadPage;
  final int currentAccountNumber;
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

  int currentPage = 1;
  Account? accountData;
  late Function refreshData;
  Duration? currentPeriod;
  int? currentAccountNumber;
  int? currentYear;
  List<DropdownMenuItem> profitLossYearDropdownItems = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    try {
      accountData = await refreshData(currentAccountNumber);
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void reloadAmountsChart([Duration? period]) {
    setState(() {
      currentPeriod = period;
    });
  }

  void reloadProfitLossChart(int year) {
    setState(() {
      currentYear = year;
    });
  }

  void initState() {
    super.initState();
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;
    currentYear = accountData!.profitLossSeries.keys.toList().last;
  }

  List<Map> zoomLevels = [
    {"label": "1m", "duration": Duration(days: 30)},
    {"label": "3m", "duration": Duration(days: 90)},
    {"label": "6m", "duration": Duration(days: 180)},
    {"label": "1y", "duration": Duration(days: 365)},
    {"label": "5y", "duration": Duration(days: 1825)},
    {"label": "all", "duration": null},
  ];

  List<ChoiceChip> buildEvolutionChartChipList(List<Map> chipData) {
    List<ChoiceChip> chipList = [];
    for (Map element in chipData) {
      chipList.add(
        ChoiceChip(
          label: Text(element['label'], style: kChipTextStyle),
          autofocus: false,
          clipBehavior: Clip.none,
          elevation: 0,
          pressElevation: 0,
          visualDensity: VisualDensity.compact,
          selected: currentPeriod == element['duration'],
          onSelected: (bool selected) {
            setState(() {
              reloadAmountsChart(element['duration']);
            });
          },
        ),
      );
    }
    return chipList;
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    theme_operations.updateTheme(context);

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
                              paddingTop: widget.landscapeOrientation ? 8 : 16,
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
                                        if (widget.landscapeOrientation) ...[
                                          Container(
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.end,
                                              spacing: 5,
                                              children: amountsChartZoomChips(
                                                  currentPeriod: currentPeriod,
                                                  zoomLevels: zoomLevels,
                                                  reloadAmountsChart:
                                                      reloadAmountsChart,
                                                  context: context),
                                            ),
                                          ),
                                        ],
                                      ]),
                                  AmountsChart(
                                      amountsSeries: accountData!.amountsSeries,
                                      period: currentPeriod),
                                  if (!widget.landscapeOrientation) ...[
                                    Container(
                                      width: double.infinity,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: widget.availableWidth < 500
                                            ? WrapAlignment.center
                                            : WrapAlignment.end,
                                        spacing: 5,
                                        children: amountsChartZoomChips(
                                            currentPeriod: currentPeriod,
                                            zoomLevels: zoomLevels,
                                            reloadAmountsChart:
                                                reloadAmountsChart,
                                            context: context),
                                      ),
                                    ),
                                  ],
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
                                          currentYear: currentYear,
                                          yearList: accountData!
                                              .profitLossSeries.keys
                                              .toList(),
                                          reloadProfitLossChart:
                                              reloadProfitLossChart),
                                    ],
                                  ),
                                  Container(
                                    height: 150,
                                    child: ProfitLossChart(
                                        profitLossSeries:
                                            accountData!.profitLossSeries,
                                        currentYear: currentYear),
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
