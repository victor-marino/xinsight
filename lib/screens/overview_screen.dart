import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:indexax/widgets/overview_screen/collapsed_account_summary.dart';
import 'package:indexax/widgets/overview_screen/distribution_chart.dart';
import 'package:indexax/widgets/overview_screen/distribution_legend.dart';
import 'package:indexax/widgets/overview_screen/expanded_account_summary.dart';
import 'package:indexax/widgets/overview_screen/expanded_account_summary_single_view.dart';
import 'package:indexax/widgets/overview_screen/fee_free_amount_card.dart';
import 'package:indexax/widgets/overview_screen/minimum_transfer_card.dart';
import 'package:indexax/widgets/overview_screen/returns_popup.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/widgets/not_reconciled_card.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({
    Key? key,
    required this.accountData,
    required this.userAccounts,
    required this.landscapeOrientation,
    required this.availableWidth,
    required this.refreshData,
    required this.currentAccountIndex,
  }) : super(key: key);
  final Account accountData;
  final List<Map<String, String>>? userAccounts;
  final bool landscapeOrientation;
  final double availableWidth;
  final Function refreshData;
  final int currentAccountIndex;

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen>
    with AutomaticKeepAliveClientMixin<OverviewScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    TextStyle cardHeaderTextStyle = text_styles.robotoLighter(context, 15);

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
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            if (!widget.landscapeOrientation ||
                                widget.availableWidth <= 1000) ...[
                                  if (!widget.accountData.isReconciledToday) ...[
                                  NotReconciledCard(reconciledUntil: widget.accountData.reconciledUntil),
                                  SizedBox(
                                height: 20,
                              ),],
                              ReusableCard(
                                childWidget: ExpandableNotifier(
                                  child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: true,
                                    child: ExpandablePanel(
                                      collapsed: ExpandableButton(
                                        child: CollapsedAccountSummary(
                                            accountData: widget.accountData),
                                      ),
                                      expanded: ExpandableButton(
                                        child: ExpandedAccountSummary(
                                            accountData: widget.accountData),
                                      ),
                                    ),
                                  ),
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
                                    Text('overview_screen.distribution'.tr(),
                                        style: cardHeaderTextStyle),
                                    DistributionChart(
                                        portfolioData:
                                            widget.accountData.portfolioData),
                                    DistributionChartLegend(
                                        portfolioDistribution: widget
                                            .accountData.portfolioDistribution),
                                  ],
                                ),
                              ),
                            ] else ...[
                              if (!widget.accountData.isReconciledToday) ...[
                                  NotReconciledCard(reconciledUntil: widget.accountData.reconciledUntil),
                                  SizedBox(
                                height: 20,
                              ),],
                              SizedBox(
                                height: 362,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ReusableCard(
                                        childWidget:
                                            ExpandedAccountSummarySingleView(
                                                accountData:
                                                    widget.accountData),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      child: ReusableCard(
                                        childWidget: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'overview_screen.distribution'
                                                  .tr(),
                                              style: cardHeaderTextStyle,
                                            ),
                                            DistributionChart(
                                                portfolioData: widget
                                                    .accountData.portfolioData),
                                            DistributionChartLegend(
                                                portfolioDistribution: widget
                                                    .accountData
                                                    .portfolioDistribution),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MinimumTransferCard(
                                        additionalCashNeededToTrade: widget
                                            .accountData
                                            .additionalCashNeededToTrade),
                                    SizedBox(height: 5),
                                    FeeFreeAmountCard(
                                        feeFreeAmount:
                                            widget.accountData.feeFreeAmount),
                                  ],
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
                                            ReturnsPopUp());
                                  },
                                ),
                              ],
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
