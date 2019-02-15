import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_exercise_calendar/helpers/close_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/round_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

enum ExerciseNumberEditDialogType { integer, double }

class ExerciseNumberEditDialog extends StatefulWidget {
  final String title;
  final dynamic value;
  final String buttonText;
  final bool autoFocus;
  final ExerciseNumberEditDialogType type;

  const ExerciseNumberEditDialog(
      {Key key,
      this.title,
      this.value = 0,
      @required this.buttonText,
      @required this.type,
      this.autoFocus = false})
      : super(key: key);
  @override
  ExerciseNumberEditDialogState createState() {
    return new ExerciseNumberEditDialogState();
  }
}

class ExerciseNumberEditDialogState extends State<ExerciseNumberEditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove, color: ThemeConfig.textColor),
                    onPressed: () {
                      SystemHelpers.vibrate25();
                      setState(() {
                        if (widget.type ==
                            ExerciseNumberEditDialogType.integer) {
                          try {
                            int value = int.parse(_controller.text);
                            _controller.text = (--value).toString();
                          } on FormatException catch (_) {
                            _controller.text = "0";
                          }
                        } else {
                          try {
                            double value = double.parse(_controller.text);
                            _controller.text = (--value).toString();
                          } on FormatException catch (_) {
                            _controller.text = "0.0";
                          }
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      autofocus: widget.autoFocus,
                      inputFormatters: widget.type ==
                              ExerciseNumberEditDialogType.integer
                          ? [
                              LengthLimitingTextInputFormatter(3),
                              WhitelistingTextInputFormatter(RegExp("[0-9]"))
                            ]
                          : [
                              LengthLimitingTextInputFormatter(5),
                              WhitelistingTextInputFormatter(RegExp("[0-9,.]"))
                            ],
                      cursorColor: ThemeConfig.dialogTextColor,
                      style: TextStyle(color: ThemeConfig.dialogTextColor),
                      keyboardType:
                          widget.type == ExerciseNumberEditDialogType.integer
                              ? TextInputType.number
                              : TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeConfig.dialogTextColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeConfig.dialogTextColor)),
                        isDense: true,
                      ),
                      onSaved: (String value) {
                        if (value.trim().isEmpty) {
                          Navigator.of(context).pop(widget.value);
                        } else {
                          Navigator.of(context).pop(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: ThemeConfig.textColor),
                    onPressed: () {
                      SystemHelpers.vibrate25();
                      setState(() {
                        if (widget.type ==
                            ExerciseNumberEditDialogType.integer) {
                          try {
                            int value = int.parse(_controller.text);
                            _controller.text = (++value).toString();
                          } on FormatException catch (_) {
                            _controller.text = "0";
                          }
                        } else {
                          try {
                            double value = double.parse(_controller.text);
                            _controller.text = (++value).toString();
                          } on FormatException catch (_) {
                            _controller.text = "0.0";
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: RoundButton(
                  text: widget.buttonText,
                  backgroundColor: ThemeConfig.dialogButton1Color,
                  textColor: ThemeConfig.dialogTextColor,
                  onPressed: () {
                    SystemHelpers.vibrate25();
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
