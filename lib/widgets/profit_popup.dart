import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

class ProfitPopUp extends StatelessWidget {
  const ProfitPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rentabilidad',
            //style: kPopUpTitleTextStyle,
          ),
          Icon(
            Icons.info_outline,
            color: Colors.black54,
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
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
