import 'package:flutter/material.dart';
import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/widgets/reusable_card.dart';
import '../../tools/constants.dart';
import 'package:indexax/widgets/portfolio_screen/asset_tile.dart';

class AssetList extends StatelessWidget {
  const AssetList({
    Key key,
    @required this.portfolioData,
  }) : super(key: key);
  final List<PortfolioDataPoint> portfolioData;

  @override
  Widget build(BuildContext context) {
    List<Widget> equityInstruments = [];
    List<Widget> fixedInstruments = [];
    List<Widget> cashInstruments = [];
    List<Widget> otherInstruments = [];
    // double equityAmount = 0;
    double equityPercentage = 0;
    // double fixedAmount = 0;
    double fixedPercentage = 0;
    double cashAmount = 0;
    double cashPercentage = 0;
    // double otherAmount = 0;
    // double otherPercentage = 0;

    for (var assetData in portfolioData) {
      switch (assetData.instrumentType) {
        case InstrumentType.equity:
          {
            if (equityInstruments.length > 0) {
              equityInstruments.add(Divider(height: 0));
            }
            // equityAmount += assetData.amount;
            equityPercentage += assetData.percentage;
            equityInstruments.add(AssetTile(assetData: assetData));
          }
          break;

        case InstrumentType.fixed:
          {
            if (fixedInstruments.length > 0) {
              fixedInstruments.add(Divider(height: 0));
            }
            // fixedAmount += assetData.amount;
            fixedPercentage += assetData.percentage;
            fixedInstruments.add(AssetTile(assetData: assetData));
          }
          break;

        case InstrumentType.cash:
          {
            cashAmount += assetData.amount;
            cashPercentage += assetData.percentage;
            cashInstruments.add(AssetTile(assetData: assetData));
          }
          break;

        default:
          {
            // otherAmount += assetData.amount;
            // otherPercentage += assetData.percentage;
            otherInstruments.add(AssetTile(assetData: assetData));
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
                child: Text(
                    'portfolio_screen.equity'.tr(),
                    style: kCardTitleTextStyle
                ),
              ),
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  getPercentAsString(equityPercentage),
                  style: kCardTitleTextStyle,
                ),
              ),
            ],
          ),
        ),
        ReusableCard(
          childWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Column(children: equityInstruments),
            ]
            ),
          paddingTop: 0,
          paddingBottom: 0,
          paddingLeft: 15,
          paddingRight: 15,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                    'portfolio_screen.fixed'.tr(),
                    style: kCardTitleTextStyle
                ),
              ),
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  getPercentAsString(fixedPercentage),
                  style: kCardTitleTextStyle,
                ),
              ),
            ],
          ),
        ),
        ReusableCard(
          childWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Column(children: fixedInstruments),
          ]
          ),
          paddingTop: 0,
          paddingBottom: 0,
          paddingLeft: 15,
          paddingRight: 15,
        ),
        if (cashAmount != 0) ... [
          SizedBox(height: 20),
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
                      child: Text(
                          'portfolio_screen.cash'.tr(),
                          style: kCardTitleTextStyle
                      ),
                    ),
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        getPercentAsString(cashPercentage),
                        style: kCardTitleTextStyle,
                      ),
                    )
                  ],
                ),
                Text(
                  getInvestmentAsString(cashAmount),
                  style: kAssetListAmountTextStyle,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
