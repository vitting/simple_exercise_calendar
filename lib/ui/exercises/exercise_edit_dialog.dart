import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_exercise_calendar/helpers/close_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/round_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class ExerciseEditDialog extends StatefulWidget {
  final String title;
  final String lable;
  final String value;
  final String buttonText;
  final bool autoFocus;

  const ExerciseEditDialog(
      {Key key,
      this.title,
      this.lable,
      this.value = "",
      this.buttonText = "Gem",
      this.autoFocus = false})
      : super(key: key);
  @override
  ExerciseEditDialogState createState() {
    return new ExerciseEditDialogState();
  }
}

class ExerciseEditDialogState extends State<ExerciseEditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: ThemeConfig.dialogBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(color: ThemeConfig.dialogTextColor),
          ),
          CloseButtonWidget(color: ThemeConfig.dialogTextColor)
        ],
      ),
      titlePadding: EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
      contentPadding: EdgeInsets.all(10),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                autofocus: widget.autoFocus,
                initialValue: widget.value,
                maxLines: 2,
                inputFormatters: [LengthLimitingTextInputFormatter(250)],
                cursorColor: ThemeConfig.dialogTextColor,
                style: TextStyle(color: ThemeConfig.dialogTextColor),
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeConfig.dialogTextColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeConfig.dialogTextColor)),
                    isDense: true,
                    labelText: widget.lable,
                    labelStyle: TextStyle(color: ThemeConfig.dialogTextColor.withOpacity(0.8))),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return "Fill out ${widget.lable}";
                  }
                },
                onSaved: (String value) {
                  Navigator.of(context).pop(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: RoundButton(
                  text: widget.buttonText,
                  backgroundColor: ThemeConfig.dialogButton1Color,
                  textColor: ThemeConfig.dialogTextColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
