import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/widgets/projection_screen/expectations_popup.dart';
import 'package:indexax/widgets/projection_screen/projection_chart.dart';
import 'package:indexax/widgets/projection_screen/risk_chart.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

class ProjectionScreen extends StatefulWidget {
  const ProjectionScreen({
    super.key,
    required this.accountData,
    required this.userAccounts,
    required this.landscapeOrientation,
    required this.availableWidth,
    required this.refreshData,
    required this.currentAccountIndex,
  });
  final Account accountData;
  final List<Map<String, String>> userAccounts;
  final bool landscapeOrientation;
  final double availableWidth;
  final Function refreshData;
  final int currentAccountIndex;

  @override
  ProjectionScreenState createState() => ProjectionScreenState();
}

class ProjectionScreenState extends State<ProjectionScreen>
    with AutomaticKeepAliveClientMixin<ProjectionScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Couldn't refresh data");
        print(e);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    TextStyle cardHeaderTextStyle = text_styles.robotoLighter(context, 15);
    TextStyle annualReturnDescriptionTextStyle =
        text_styles.robotoLighter(context, 15);
    TextStyle annualReturnValueTextStyle = text_styles.robotoBold(context, 16);

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
                            ReusableCard(
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('projection_screen.risk'.tr(),
                                      textAlign: TextAlign.left,
                                      style: cardHeaderTextStyle),
                                  RiskChart(risk: widget.accountData.risk),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ReusableCard(
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('projection_screen.projection'.tr(),
                                      textAlign: TextAlign.left,
                                      style: cardHeaderTextStyle),
                                  PerformanceChart(
                                      performanceSeries:
                                          widget.accountData.performanceSeries),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${'projection_screen.expected_annual_return'.tr()}: ',
                                              style:
                                                  annualReturnDescriptionTextStyle),
                                          TextSpan(
                                              text: getPLPercentAsString(widget
                                                  .accountData.expectedReturn),
                                              style: annualReturnValueTextStyle)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            MaterialButton(
                              height: 40,
                              minWidth: 40,
                              shape: const CircleBorder(),
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
                                        const ExpectationsPopUp());
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
        ),
      ),
    );
  }
}
