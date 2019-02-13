import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/close_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/round_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class ExitDialog extends StatelessWidget {
  final String bodyText;

  const ExitDialog({Key key, @required this.bodyText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: ThemeConfig.dialogBackgroundColor,
      titlePadding: EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
      contentPadding: EdgeInsets.all(10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Afslut", style: TextStyle(color: ThemeConfig.dialogTextColor)),
          CloseButtonWidget(
            color: ThemeConfig.dialogTextColor,
          )
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(bodyText,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: ThemeConfig.dialogTextColor, fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RoundButton(
                backgroundColor: ThemeConfig.dialogButton1Color,
                textColor: ThemeConfig.dialogTextColor,
                text: "Ja",
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              RoundButton(
                backgroundColor: ThemeConfig.dialogButton2Color,
                textColor: ThemeConfig.dialogTextColor,
                text: "Nej",
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
