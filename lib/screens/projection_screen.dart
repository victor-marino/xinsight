import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/performance_chart.dart';
import 'package:indexa_dashboard/widgets/risk_chart.dart';
import 'package:indexa_dashboard/widgets/build_account_switcher.dart';
import 'package:indexa_dashboard/models/account_dropdown_items.dart';
import 'package:indexa_dashboard/widgets/settings_button.dart';
import 'package:indexa_dashboard/widgets/expectations_popup.dart';

class ProjectionScreen extends StatefulWidget {
  const ProjectionScreen({
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
  _ProjectionScreenState createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends State<ProjectionScreen> {
  int currentPage = 2;
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

    dropdownItems =
        AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;
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
                    'Proyección',
                    style: kTitleTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  buildAccountSwitcher(
                      currentAccountNumber: currentAccountNumber,
                      currentPage: currentPage,
                      accountDropdownItems: dropdownItems,
                      reloadPage: widget.reloadPage),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'RIESGO',
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              RiskChart(risk: widget.accountData.selectedRisk),
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: Text(
                              //       //'Rentabilidad anual media esperada: ${getPLPercentAsString(widget.accountData.expectedReturn)}.\n\nProbabilidad del 95 %:\n· Entre ${getPLPercentAsString(widget.accountData.worstReturn1yr)} y ${getPLPercentAsString(widget.accountData.bestReturn1yr)} al cabo de 1 año.\n· Entre ${getPLPercentAsString(widget.accountData.worstReturn10yr)} y ${getPLPercentAsString(widget.accountData.bestReturn10yr)} al cabo de 10 años.'),
                              //       'Rentabilidad anual media esperada: ${getPLPercentAsString(widget.accountData.expectedReturn)}'),
                              // ),
                              // Container(
                              //   alignment: Alignment.bottomRight,
                              //   child: Icon(
                              //     Icons.info_outline,
                              //     color: Colors.grey,
                              //   ),
                              // ),
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
                                'PROYECCIÓN',
                                textAlign: TextAlign.left,
                                style: kCardTitleTextStyle,
                              ),
                              PerformanceChart(
                                  performanceSeries:
                                      accountData.performanceSeries),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                //child: Text(
                                //  'Rentabilidad anual media esperada: ${getPLPercentAsString(widget.accountData.expectedReturn)}\nProbabilidades:\n· Por encima del escenario negativo: 97,5%\n· Por encima del escenario positivo: 2,5%\n· Entre ambos escenarios: 95%.',
                                // 'Rentabilidad anual media esperada: ${getPLPercentAsString(widget.accountData.expectedReturn)}\n95% de probabilidad de estar entre ambos escenarios.',
                                //'Rentabilidad anual media esperada: ${getPLPercentAsString(widget.accountData.expectedReturn)}',
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "Rentabilidad anual media esperada: ",
                                          style: kCardSubTextStyle),
                                      TextSpan(
                                          text: getPLPercentAsString(widget
                                              .accountData.expectedReturn),
                                          style: kCardSecondaryContentTextStyle)
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   alignment: Alignment.bottomRight,
                              //   child: Icon(
                              //     Icons.info_outline,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          height: 40,
                          minWidth: 40,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          color: Colors.blue[600],
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
