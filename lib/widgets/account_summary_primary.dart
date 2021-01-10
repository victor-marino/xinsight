import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/amounts_datapoint.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:indexa_dashboard/models/account.dart';

class AccountSummaryPrimary extends StatelessWidget {
  const AccountSummaryPrimary({
    Key key,
    @required this.accountData,
  }) : super(key: key);
  final Account accountData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'VALOR',
                textAlign: TextAlign.left,
                style: kCardTitleTextStyle,
              ),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text:
                      getBalanceAsString(accountData.totalAmount).split(',')[0],
                  style: kCardPrimaryContentTextStyle,
                ),
                TextSpan(
                  text: ',' +
                      getBalanceAsString(accountData.totalAmount).split(',')[1],
                  style: kCardSecondaryContentTextStyle,
                ),
              ]),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Aportado: ' +
                      getInvestmentAsString(accountData.investment),
                  //textAlign: TextAlign.left,
                  style: kCardSubTextStyle,
                ),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
