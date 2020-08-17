import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexa_dashboard/models/amounts_datapoint.dart';
import 'package:indexa_dashboard/tools/constants.dart';
import 'package:indexa_dashboard/tools/number_formatting.dart';
import 'package:indexa_dashboard/models/account.dart';

class AccountSummary extends StatelessWidget {
  const AccountSummary({
    Key key,
    @required this.accountData,
  }) : super(key: key);
  final Account accountData;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Expanded(
            //flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'VALOR',
                  textAlign: TextAlign.left,
                  style: kCardTitleTextStyle,
                ),
                SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: getBalanceAsString(accountData.totalAmount)
                          .split(',')[0],
                      style: kCardPrimaryContentTextStyle,
                    ),
                    TextSpan(
                      text: ',' +
                          getBalanceAsString(accountData.totalAmount)
                              .split(',')[1],
                      style: kCardSecondaryContentTextStyle,
                    ),
                  ]),
                ),
                Text(
                  'Aportado: ' + getInvestmentAsString(accountData.investment),
                  textAlign: TextAlign.left,
                  style: kCardSubTextStyle,
                )
              ],
            ),
          ),
          Container(
            width: 20,
            child: VerticalDivider(
              color: Colors.black12,
              thickness: 1,
              //width: 50,
              indent: 5,
              endIndent: 5,
            ),
          ),
          Expanded(
            //flex: 4,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rentabilidad',
                          //style: kPopUpTitleTextStyle,
                        ),
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Ponderada por tiempo',
                              style: kPopUpSubtitleTextStyle,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Es la mejor forma de comparar la rentabilidad entre diferentes gestoras, ya que ignora el momento de tus aportaciones o reembolsos.',
                          style: kPopUpNormalTextStyle,
                        ),
                        Divider(
                          height: 30,
                          color: Colors.black54,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Ponderada por dinero',
                              style: kPopUpSubtitleTextStyle,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.euro_symbol,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Es la forma más común de evaluar el desempeño de la cuenta, ya que tiene en cuenta tu patrón específico de aportaciones y retiradas.',
                          style: kPopUpNormalTextStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Las rentabilidades se calculan netas de comisiones.',
                          style: kPopUpFootnoteTextStyle,
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    actions: [
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'RENTABILIDAD',
                    textAlign: TextAlign.left,
                    style: kCardTitleTextStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            getPLAsString(accountData.profitLoss).split(',')[0],
                        style: kCardPrimaryContentTextStyle.copyWith(
                          color: accountData.profitLossColor,
                        ),
                      ),
                      TextSpan(
                        text: ',' +
                            getPLAsString(accountData.profitLoss).split(',')[1],
                        style: kCardSecondaryContentTextStyle.copyWith(
                          color: accountData.profitLossColor,
                        ),
                      ),
                    ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: Colors.grey,
                            size: 14.0,
                          ),
                          Text(
                            getPLPercentAsString(accountData.timeReturn),
                            textAlign: TextAlign.left,
                            style: kCardSubTextStyle.copyWith(
                                color: accountData.timeReturnColor),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.euro_symbol,
                            color: Colors.grey,
                            size: 14.0,
                          ),
                          Text(
                            getPLPercentAsString(accountData.moneyReturn),
                            textAlign: TextAlign.left,
                            style: kCardSubTextStyle.copyWith(
                                color: accountData.moneyReturnColor),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
