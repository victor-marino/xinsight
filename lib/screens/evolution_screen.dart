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
  final List<Map<String, String>> userAccounts;
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
  }

  List<Map> chipData = [
    {"label": "evolution_screen.1m".tr(), "duration": Duration(days: 30)},
    {"label": "evolution_screen.3m".tr(), "duration": Duration(days: 90)},
    {"label": "evolution_screen.6m".tr(), "duration": Duration(days: 180)},
    {"label": "evolution_screen.1y".tr(), "duration": Duration(days: 365)},
    {"label": "evolution_screen.5y".tr(), "duration": Duration(days: 1825)},
    {"label": "evolution_screen.all".tr(), "duration": null},
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
                          paddingBottom: 8,
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
                                  children:
                                      buildEvolutionChartChipList(chipData),
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
                                  Text(
                                    'evolution_screen.returns'.tr(),
                                    textAlign: TextAlign.left,
                                    style: kCardTitleTextStyle,
                                  ),
                                  ProfitLossYearSwitcher(
                                      // profitLossYearDropdownItems:
                                      //     profitLossYearDropdownItems,
                                      currentYear: currentYear,
                                      yearList: accountData.profitLossSeries.keys.toList(),
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
