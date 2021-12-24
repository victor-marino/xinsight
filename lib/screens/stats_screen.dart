import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import '../models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/account_summary.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/portfolio_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_legend.dart';
import 'package:indexa_dashboard/widgets/profit_popup.dart';
import 'package:indexa_dashboard/widgets/build_account_switcher.dart';
import 'package:indexa_dashboard/models/account_dropdown_items.dart';
import 'package:indexa_dashboard/widgets/settings_button.dart';

const int nbsp = 0x00A0;

class StatsScreen extends StatefulWidget {
  const StatsScreen({
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
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int currentPage = 4;
  Account accountData;
  Function refreshData;
  int currentAccountNumber;
  List<DropdownMenuItem> dropdownItems = [];

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
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Estadísticas',
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[

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
