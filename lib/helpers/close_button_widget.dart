import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';

class CloseButtonWidget extends StatelessWidget {
  final Color color;

  const CloseButtonWidget({Key key, this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Luk",
      icon: Icon(Icons.close, color: color),
      onPressed: () {
        SystemHelpers.vibrate25();
        Navigator.of(context).pop();
      },
    );
  }
}
