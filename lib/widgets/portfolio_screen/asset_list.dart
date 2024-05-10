import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/private_mode_provider.dart';
import 'package:indexax/widgets/portfolio_screen/asset_tile.dart';
import 'package:indexax/widgets/reusable_card.dart';
import 'package:indexax/tools/styles.dart' as text_styles;
import 'package:provider/provider.dart';

// The list of assets shown in the portfolio screen
// Grouped by asset type:
// 1. Equity
// 2. Fixed
// 3. Emergency fund (money market)
// 4. Others
// Instruments within each asset class are sorted by amount

class AssetList extends StatelessWidget {
  const AssetList({
    super.key,
    required this.portfolioData,
    required this.landscapeOrientation,
  });

  final List<PortfolioDataPoint> portfolioData;
  final bool landscapeOrientation;

  @override
  Widget build(BuildContext context) {
    TextStyle listDividerTextStyle = text_styles.roboto(context, 15);
    TextStyle cashAmountTextStyle = text_styles.ubuntuBold(context, 16);

    List<Widget> equityInstruments = [];
    List<Widget> fixedInstruments = [];
    List<Widget> moneyMarketInstruments = [];
    List<Widget> cashInstruments = [];
    List<Widget> otherInstruments = [];
    double equityPercentage = 0;
    double fixedPercentage = 0;
    double moneyMarketPercentage = 0;
    double cashAmount = 0;
    double cashPercentage = 0;

    for (var assetData in portfolioData) {
      switch (assetData.instrumentType) {
        case InstrumentType.equity:
          {
            if (equityInstruments.isNotEmpty) {
              equityInstruments.add(const Divider(height: 0));
            }
            equityPercentage += assetData.percentage;
            equityInstruments.add(AssetTile(
                assetData: assetData,
                landscapeOrientation: landscapeOrientation));
          }
          break;

        case InstrumentType.fixed:
          {
            if (fixedInstruments.isNotEmpty) {
              fixedInstruments.add(const Divider(height: 0));
            }
            fixedPercentage += assetData.percentage;
            fixedInstruments.add(AssetTile(
              assetData: assetData,
              landscapeOrientation: landscapeOrientation,
            ));
          }
          break;

        case InstrumentType.moneymarket:
          {
            if (moneyMarketInstruments.isNotEmpty) {
              moneyMarketInstruments.add(const Divider(height: 0));
            }
            moneyMarketPercentage += assetData.percentage;
            moneyMarketInstruments.add(AssetTile(
              assetData: assetData,
              landscapeOrientation: landscapeOrientation,
            ));
          }
          break;

        case InstrumentType.cash:
          {
            cashAmount += assetData.amount;
            cashPercentage += assetData.percentage;
            cashInstruments.add(AssetTile(
                assetData: assetData,
                landscapeOrientation: landscapeOrientation));
          }
          break;

        default:
          {
            otherInstruments.add(AssetTile(
                assetData: assetData,
                landscapeOrientation: landscapeOrientation));
          }
          break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text('portfolio_screen.equity'.tr(),
                    style: listDividerTextStyle),
              ),
              Expanded(
                  child: Divider(
                      color: Theme.of(context).colorScheme.onBackground)),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  getPercentAsString(equityPercentage),
                  style: listDividerTextStyle,
                ),
              ),
            ],
          ),
        ),
        ReusableCard(
          childWidget:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(children: equityInstruments),
          ]),
          paddingTop: 0,
          paddingBottom: 0,
          paddingLeft: 15,
          paddingRight: 15,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text('portfolio_screen.fixed'.tr(),
                    style: listDividerTextStyle),
              ),
              Expanded(
                  child: Divider(
                      color: Theme.of(context).colorScheme.onBackground)),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  getPercentAsString(fixedPercentage),
                  style: listDividerTextStyle,
                ),
              ),
            ],
          ),
        ),
        ReusableCard(
          childWidget:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(children: fixedInstruments),
          ]),
          paddingTop: 0,
          paddingBottom: 0,
          paddingLeft: 15,
          paddingRight: 15,
        ),
        if (moneyMarketInstruments.isNotEmpty) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text('portfolio_screen.moneymarket'.tr(),
                      style: listDividerTextStyle),
                ),
                Expanded(
                    child: Divider(
                        color: Theme.of(context).colorScheme.onBackground)),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    getPercentAsString(moneyMarketPercentage),
                    style: listDividerTextStyle,
                  ),
                ),
              ],
            ),
          ),
          ReusableCard(
            childWidget:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: moneyMarketInstruments),
            ]),
            paddingTop: 0,
            paddingBottom: 0,
            paddingLeft: 15,
            paddingRight: 15,
          ),
        ],
        if (cashAmount != 0) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text('portfolio_screen.cash'.tr(),
                          style: listDividerTextStyle),
                    ),
                    Expanded(
                        child: Divider(
                            color: Theme.of(context).colorScheme.onBackground)),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        getPercentAsString(cashPercentage),
                        style: listDividerTextStyle,
                      ),
                    )
                  ],
                ),
                Text(
                  getInvestmentAsString(cashAmount,
                      maskValue: context
                          .watch<PrivateModeProvider>()
                          .privateModeEnabled),
                  style: cashAmountTextStyle,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
