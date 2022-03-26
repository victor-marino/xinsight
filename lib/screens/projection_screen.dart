// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/widgets/projection_screen/projection_chart.dart';
import 'package:indexax/widgets/projection_screen/risk_chart.dart';
import 'package:indexax/widgets/projection_screen/expectations_popup.dart';

class ProjectionScreen extends StatefulWidget {
  const ProjectionScreen({
    Key key,
    @required this.accountData,
    @required this.userAccounts,
    @required this.refreshData,
    @required this.reloadPage,
    @required this.currentAccountNumber,
  }) : super(key: key);
  final Account accountData;
  final List<Map<String, String>> userAccounts;
  final Function refreshData;
  final Function reloadPage;
  final int currentAccountNumber;

  @override
  _ProjectionScreenState createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends State<ProjectionScreen> with AutomaticKeepAliveClientMixin<ProjectionScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  int currentPage = 2;
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
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    // dropdownItems =
    //     AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'projection_screen.risk'.tr(),
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              RiskChart(risk: widget.accountData.risk),
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
                            children: <Widget>[
                              Text(
                                'projection_screen.projection'.tr(),
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              PerformanceChart(
                                  performanceSeries:
                                      accountData.performanceSeries),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              'projection_screen.expected_annual_return'.tr() + ': ',
                                          style: kCardSubTextStyle),
                                      TextSpan(
                                          text: getPLPercentAsString(widget
                                              .accountData.expectedReturn),
                                          style: kCardSecondaryContentTextStyle)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          height: 40,
                          minWidth: 40,
                          shape: CircleBorder(),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ExpectationsPopUp());
                          },
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
