import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class BottomMenuRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final int value;

  const BottomMenuRow({Key key, this.text, this.icon, this.value})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeConfig.bottomSheetRowColor,
      child: ListTile(
          leading: Icon(icon, color: ThemeConfig.bottomSheetTextColor),
          title: Text(text,
              style: TextStyle(color: ThemeConfig.bottomSheetTextColor)),
          onTap: () {
            SystemHelpers.vibrate25();
            Navigator.of(context).pop(value);
          }),
    );
  }
}
