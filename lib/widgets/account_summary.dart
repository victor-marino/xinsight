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
                      text: getPLAsString(accountData.profitLoss).split(',')[0],
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
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          child: SimpleDialog(
                            children: <Widget>[
                              SimpleDialogOption(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: Text(
                                            'Rentabilidad ponderada por tiempo, neta de comisiones. Es la mejor forma de comparar la rentabilidad entre diferentes gestoras, ya que ignora el momento de tus aportaciones o reembolsos.',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 40,
                                      color: Colors.black54,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.euro_symbol,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: Text(
                                              'Rentabilidad ponderada por dinero, neta de comisiones. Es la forma más común de evaluar el desempeño de la cuenta, ya que tiene en cuenta tu patrón específico de aportaciones y retiradas.'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      child: Icon(
                        Icons.help_outline,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
