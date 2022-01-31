import 'package:flutter/material.dart';
import 'package:indexax/screens/settings_screen.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: CircleBorder(),
      child: Icon(
        Icons.settings,
        color: Colors.blue[600],
      ),
      height: 40,
      minWidth: 40,
      materialTapTargetSize:
      MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => SettingsScreen()));
      },
    );
  }
}