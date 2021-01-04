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
  List<DropdownMenuItem> accountDropdownItems = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    accountData = await refreshData(currentAccountNumber);
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void reloadPageFromAccountSwitcher(int selectedAccount) {
    currentAccountNumber = selectedAccount;
    widget.reloadPage(selectedAccount, currentPage);
  }

  @override
  void initState() {
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    for(var account in widget.userAccounts) {
      accountDropdownItems.add(
        DropdownMenuItem(
          child: Text((accountDropdownItems.length + 1).toString() + ". " + account),
          value: accountDropdownItems.length,
        ),
      );
    }
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
                children: [
                  Text(
                    'Proyección',
                    style: kTitleTextStyle,
                    textAlign: TextAlign.left,
                  ),
                  buildAccountSwitcher(currentAccountNumber: currentAccountNumber, accountDropdownItems: accountDropdownItems, reloadPageFromAccountSwitcher: reloadPageFromAccountSwitcher),
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
                          childWidget: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Riesgo',
                                        //style: kPopUpTitleTextStyle,
                                      ),
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'Recuerda que estos cálculos son expectativas, por lo que no hay ninguna garantía ni seguridad de que las rentabilidades acaben en el rango indicado.',
                                    style: kPopUpNormalTextStyle,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      24, 24, 24, 0),
                                  actions: [
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'RIESGO',
                                  textAlign: TextAlign.left,
                                  style: kCardTitleTextStyle,
                                ),
                                RiskChart(risk: 6),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                      'Rentabilidad anual esperada media: ${getPLPercentAsString(widget.accountData.expectedReturn)}.\n\nProbabilidad del 95 % de que la rentabilidad esté:\n· Entre ${getPLPercentAsString(widget.accountData.worstReturn1yr)} y ${getPLPercentAsString(widget.accountData.bestReturn1yr)} al cabo de 1 año.\n· Entre ${getPLPercentAsString(widget.accountData.worstReturn10yr)} y ${getPLPercentAsString(widget.accountData.bestReturn10yr)} al cabo de 10 años.'),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ReusableCard(
                          childWidget: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Proyección',
                                        //style: kPopUpTitleTextStyle,
                                      ),
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'Recuerda que los mercados pueden ser volátiles en el corto plazo, pero tienden a revertir a la media y crecer en el largo plazo.',
                                    style: kPopUpNormalTextStyle,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      24, 24, 24, 0),
                                  actions: [
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                PerformanceChart(
                                    performanceSeries:
                                        accountData.performanceSeries),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Probabilidades:\n· Por encima del escenario negativo: 97,5%\n· Por encima del escenario positivo: 2,5%\n· Entre ambos escenarios: 95%.',
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
