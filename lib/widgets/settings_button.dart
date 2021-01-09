import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Icon(
        Icons.settings,
      ),
      height: 40,
      minWidth: 40,
      materialTapTargetSize:
      MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }
}