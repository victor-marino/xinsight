import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/performance_chart.dart';
import 'package:indexa_dashboard/widgets/risk_chart.dart';
import '../widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/build_account_switcher.dart';
import 'package:indexa_dashboard/models/account_dropdown_items.dart';
import 'package:indexa_dashboard/widgets/settings_button.dart';

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
  List<DropdownMenuItem> dropdownItems = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    accountData = await refreshData(currentAccountNumber);
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    dropdownItems = AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Evolución',
                    style: kTitleTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  buildAccountSwitcher(currentAccountNumber: currentAccountNumber, currentPage: currentPage, accountDropdownItems: dropdownItems, reloadPage: widget.reloadPage),
                  SettingsButton(),
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        ReusableCard(
                          childWidget: AmountsChart(
                              amountsSeries: accountData.amountsSeries),
                        ),
                        SizedBox(
                          height: 30,
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
