import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import '../widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/profit_loss_chart.dart';
import 'package:indexa_dashboard/widgets/build_profit_loss_year_switcher.dart';

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

class _EvolutionScreenState extends State<EvolutionScreen> {
  int currentPage = 1;
  Account accountData;
  Function refreshData;
  int currentAccountNumber;
  //List<DropdownMenuItem> dropdownItems = [];
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
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void reloadProfitLossChart(int year) {
    setState(() {
      print("setting state");
      currentYear = year;
    });
  }

  @override
  void initState() {
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    currentYear = accountData.profitLossSeries.keys.toList().last;
    accountData.profitLossSeries.forEach((key, value) {
      profitLossYearDropdownItems.add(DropdownMenuItem(child: Text(key.toString()), value: key));
    });
    profitLossYearDropdownItems.sort((b, a) => a.value.compareTo(b.value));
    //dropdownItems =
    //    AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Evolución',
            //         style: kTitleTextStyle,
            //         textAlign: TextAlign.left,
            //       ),
            //       Flexible(
            //         child: Container(),
            //       ),
            //       buildAccountSwitcher(currentAccountNumber: currentAccountNumber, currentPage: currentPage, accountDropdownItems: dropdownItems, reloadPage: widget.reloadPage),
            //       SettingsButton(),
            //     ],
            //   ),
            // ),
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
                                "EVOLUCIÓN",
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              AmountsChart(
                                  amountsSeries: accountData.amountsSeries),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Toca con dos dedos para ampliar",
                                  textAlign: TextAlign.center,
                                  style: kCardSubTextStyle,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "RENTABILIDADES",
                                    textAlign: TextAlign.left,
                                    style: kCardTitleTextStyle,
                                  ),
                                  buildProfitLossYearSwitcher(profitLossYearDropdownItems: profitLossYearDropdownItems, currentYear: currentYear, reloadProfitLossChart: reloadProfitLossChart),
                                ],
                              ),
                              Container(
                                height: 150,
                                child: ProfitLossChart(
                                    profitLossSeries:
                                        accountData.profitLossSeries, currentYear: currentYear),
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
