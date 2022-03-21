// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/widgets/reusable_card.dart';
import '../widgets/evolution_screen/amounts_chart.dart';
import 'package:indexax/widgets/evolution_screen/profit_loss_chart.dart';
import 'package:indexax/widgets/evolution_screen/build_profit_loss_year_switcher.dart';

class EvolutionScreen extends StatefulWidget {
  const EvolutionScreen({
    Key key,
    this.accountData,
    this.userAccounts,
    this.refreshData,
    this.reloadPage,
    this.currentAccountNumber,
  }) : super(key: key);
  final Account accountData;
  final List<String> userAccounts;
  final Function refreshData;
  final Function reloadPage;
  final int currentAccountNumber;

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
  Account accountData;
  Function refreshData;
  Duration currentPeriod;
  int currentAccountNumber;
  int currentYear;
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

  void reloadAmountsChart([Duration period]) {
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

    currentYear = accountData.profitLossSeries.keys.toList().last;
    accountData.profitLossSeries.forEach((key, value) {
      profitLossYearDropdownItems
          .add(DropdownMenuItem(child: Text(key.toString()), value: key));
    });
    profitLossYearDropdownItems.sort((b, a) => a.value.compareTo(b.value));
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    return Scaffold(
      body: SafeArea(
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
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'evolution_screen.evolution'.tr(),
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              AmountsChart(
                                  amountsSeries: accountData.amountsSeries,
                                  period: currentPeriod),
                              Container(
                                  width: double.infinity,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing: 3,
                                    children: [
                                      RawChip(
                                        label: Text('evolution_screen.1m'.tr(),
                                            style: kChipTextStyle),
                                        autofocus: false,
                                        clipBehavior: Clip.none,
                                        elevation: 0,
                                        pressElevation: 0,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            reloadAmountsChart(
                                                Duration(days: 30));
                                          });
                                        },
                                      ),
                                      RawChip(
                                        label: Text('evolution_screen.3m'.tr(),
                                            style: kChipTextStyle),
                                        autofocus: false,
                                        clipBehavior: Clip.none,
                                        elevation: 0,
                                        pressElevation: 0,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            reloadAmountsChart(
                                                Duration(days: 90));
                                          });
                                        },
                                      ),
                                      RawChip(
                                        label: Text('evolution_screen.6m'.tr(),
                                            style: kChipTextStyle),
                                        autofocus: false,
                                        clipBehavior: Clip.none,
                                        elevation: 0,
                                        pressElevation: 0,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            reloadAmountsChart(
                                                Duration(days: 180));
                                          });
                                        },
                                      ),
                                      RawChip(
                                        label: Text('evolution_screen.1y'.tr(),
                                            style: kChipTextStyle),
                                        autofocus: false,
                                        clipBehavior: Clip.none,
                                        elevation: 0,
                                        pressElevation: 0,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            reloadAmountsChart(
                                                Duration(days: 365));
                                          });
                                        },
                                      ),
                                      RawChip(
                                        label: Text('evolution_screen.5y'.tr(),
                                            style: kChipTextStyle),
                                        autofocus: false,
                                        clipBehavior: Clip.none,
                                        elevation: 0,
                                        pressElevation: 0,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            reloadAmountsChart(
                                                Duration(days: 1825));
                                          });
                                        },
                                      ),
                                      RawChip(
                                        label: Text('evolution_screen.all'.tr(),
                                            style: kChipTextStyle),
                                        autofocus: false,
                                        clipBehavior: Clip.none,
                                        elevation: 0,
                                        pressElevation: 0,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            reloadAmountsChart();
                                          });
                                        },
                                      ),
                                    ],
                                  )),
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
                                  Text(
                                    'evolution_screen.returns'.tr(),
                                    textAlign: TextAlign.left,
                                    style: kCardTitleTextStyle,
                                  ),
                                  buildProfitLossYearSwitcher(
                                      profitLossYearDropdownItems:
                                          profitLossYearDropdownItems,
                                      currentYear: currentYear,
                                      reloadProfitLossChart:
                                          reloadProfitLossChart),
                                ],
                              ),
                              Container(
                                height: 150,
                                child: ProfitLossChart(
                                    profitLossSeries:
                                        accountData.profitLossSeries,
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
    );
  }
}
