import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:indexax/models/account.dart';
import 'package:indexax/tools/number_formatting.dart';
import 'package:indexax/tools/styles.dart' as text_styles;

// Collapsed version of the account summary.
// This is the default view in portrait mode, as well as landscape mode in smaller screens.

class CollapsedAccountSummary extends StatelessWidget {
  const CollapsedAccountSummary({
    Key? key,
    required this.accountData,
  }) : super(key: key);
  final Account accountData;

  @override
  Widget build(BuildContext context) {
    TextStyle cardHeaderTextStyle = text_styles.robotoLighter(context, 15);
    TextStyle largeBalanceTextStyle = text_styles.ubuntuBold(context, 40);
    TextStyle smallBalanceTextStyle = text_styles.ubuntuBold(context, 20);
    TextStyle largeReturnTextStyle = text_styles.ubuntuBold(context, 25);
    TextStyle smallReturnTextStyle = text_styles.ubuntuBold(context, 20);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'account_summary.value'.tr(),
                  textAlign: TextAlign.left,
                  style: cardHeaderTextStyle,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "${getInvestmentAsString(accountData.investment)} ",
                      style: cardHeaderTextStyle,
                    ),
                    TextSpan(
                      text: getPLAsString(accountData.profitLoss),
                      style: cardHeaderTextStyle.copyWith(
                        color: accountData.profitLossColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: getWholeBalanceAsString(accountData.totalAmount),
                  style: largeBalanceTextStyle,
                ),
                TextSpan(
                  text: getDecimalSeparator() +
                      getFractionalBalanceAsString(accountData.totalAmount),
                  style: smallBalanceTextStyle,
                ),
              ]),
            ),
          ],
        ),
        const Divider(
          height: 15,
        ),
        SizedBox(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${'account_summary.return'.tr()} ',
                              textAlign: TextAlign.left,
                              style: cardHeaderTextStyle,
                            ),
                            Icon(
                              Icons.access_time,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 15.0,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(children: <Widget>[
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: getWholePLPercentAsString(
                                      accountData.timeReturn),
                                  style: largeReturnTextStyle.copyWith(
                                      color: accountData.timeReturnColor),
                                ),
                                TextSpan(
                                  text: getDecimalSeparator() +
                                      getFractionalPLPercentAsString(
                                          accountData.timeReturn),
                                  style: smallReturnTextStyle.copyWith(
                                      color: accountData.timeReturnColor),
                                ),
                              ]),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  indent: 0,
                  thickness: 1,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${'account_summary.return'.tr()} ',
                                textAlign: TextAlign.left,
                                style: cardHeaderTextStyle),
                            Icon(
                              Icons.euro_symbol,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 15.0,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(children: <Widget>[
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: getWholePLPercentAsString(
                                      accountData.moneyReturn),
                                  style: largeReturnTextStyle.copyWith(
                                      color: accountData.moneyReturnColor),
                                ),
                                TextSpan(
                                  text: getDecimalSeparator() +
                                      getFractionalPLPercentAsString(
                                          accountData.moneyReturn),
                                  style: smallReturnTextStyle.copyWith(
                                      color: accountData.moneyReturnColor),
                                ),
                              ]),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blue),
          ],
        ),
      ],
    );
  }
}
