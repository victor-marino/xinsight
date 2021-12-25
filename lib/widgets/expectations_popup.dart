import 'package:flutter/material.dart';
import 'package:indexa_dashboard/tools/constants.dart';

class ExpectationsPopUp extends StatelessWidget {
  const ExpectationsPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expectativas',
            //style: kPopUpTitleTextStyle,
          ),
        ],
      ),
      content: Text(
        'Recuerda que estos cálculos son expectativas, por lo que no hay ninguna garantía ni seguridad de que las rentabilidades acaben en el rango indicado. Calculamos que hay un 95% de probabilidad de que tu rentabilidad esté comprendida entre el escenario positivo y el negativo.\n\nTen en cuenta que los mercados pueden ser volátiles en el corto plazo, pero tienden a revertir a la media y crecer en el largo plazo.',
        style: kPopUpNormalTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          24, 24, 24, 0),
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