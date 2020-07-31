import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import 'package:indexa_dashboard/widgets/reusable_card.dart';
import 'package:indexa_dashboard/widgets/amounts_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_chart.dart';
import 'package:indexa_dashboard/widgets/portfolio_legend.dart';
import 'package:indexa_dashboard/widgets/account_summary.dart';

class ProjectionScreen extends StatefulWidget {
  const ProjectionScreen({
    Key key,
    this.accountData,
    this.loadData,
  }) : super(key: key);
  final Account accountData;
  final Function loadData;

  @override
  _ProjectionScreenState createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends State<ProjectionScreen> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await widget.loadData();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
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
              child: Text(
                'Inicio',
                style: kTitleTextStyle,
                textAlign: TextAlign.left,
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
//                        SizedBox(
//                          height: 10.0,
//                        ),
                        ReusableCard(
                          childWidget:
                          AccountSummary(accountData: widget.accountData),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ReusableCard(
                          childWidget: AmountsChart(
                              amountsSeries: widget.accountData.amountsSeries),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ReusableCard(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              PortfolioChart(
                                  portfolioData:
                                  widget.accountData.portfolioData),
                              PortfolioChartLegend(
                                  portfolioData:
                                  widget.accountData.portfolioData),
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