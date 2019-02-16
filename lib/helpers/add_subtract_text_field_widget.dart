import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class AddSubtractTextField extends StatelessWidget {
  final ValueChanged<bool> onTapSubtract;
  final ValueChanged<bool> onTapAdd;
  final ValueChanged<String> onSave;
  final String label;
  final TextEditingController controller;
  final int maxLength;
  final String whiteListRegExPattern;

  const AddSubtractTextField(
      {Key key,
      @required this.onTapSubtract,
      @required this.onTapAdd,
      @required this.onSave,
      @required this.label,
      @required this.controller,
      @required this.maxLength,
      @required this.whiteListRegExPattern})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove, color: ThemeConfig.textColor),
          onPressed: () {
            SystemHelpers.vibrate25();
            if (onTapSubtract != null) {
              onTapSubtract(true);
            }
          },
        ),
        SizedBox(
          width: 120,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(label,
                      style: TextStyle(
                          color: ThemeConfig.textColor, fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.timer,
                        color: ThemeConfig.textColor, size: 20),
                  ),
                ],
              ),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(maxLength),
                  WhitelistingTextInputFormatter(RegExp(whiteListRegExPattern))
                ],
                onSaved: (String value) {
                  if (onSave != null) {
                    onSave(value);
                  }
                },
                style: TextStyle(color: ThemeConfig.dialogTextColor),
                cursorColor: ThemeConfig.dialogTextColor,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ThemeConfig.textColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ThemeConfig.textColor)),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: ThemeConfig.textColor,
          ),
          onPressed: () {
            SystemHelpers.vibrate25();
            if (onTapAdd != null) {
              onTapAdd(true);
            }
          },
        )
      ],
    );
  }
}
