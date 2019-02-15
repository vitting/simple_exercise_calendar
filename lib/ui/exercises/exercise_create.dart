import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/round_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class ExerciseCreate extends StatefulWidget {
  final ExerciseData exercise;

  const ExerciseCreate({Key key, this.exercise}) : super(key: key);
  @override
  _ExerciseCreateState createState() => _ExerciseCreateState();
}

class _ExerciseCreateState extends State<ExerciseCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();
  ExerciseData _exercise;

  @override
  void initState() {
    super.initState();
    if (widget.exercise == null) {
      _exercise = ExerciseData();
      _timeController.text = _exercise.seconds.toString();
      _weightController.text = _exercise.weight.toString();
      _repeatController.text = _exercise.repetitions.toString();
    } else {
      _exercise = widget.exercise;
      _timeController.text = _exercise.seconds.toString();
      _weightController.text = _exercise.weight.toString();
      _repeatController.text = _exercise.repetitions.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timeController.dispose();
    _weightController.dispose();
    _repeatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _exercise.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(250)],
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return FlutterI18n.translate(
                            context, 'ExerciseCreate.string1');
                      }
                    },
                    onSaved: (String value) {
                      _exercise.text = value.trim();
                    },
                    style: TextStyle(color: ThemeConfig.dialogTextColor),
                    cursorColor: ThemeConfig.dialogTextColor,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeConfig.textColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeConfig.textColor)),
                        labelText: FlutterI18n.translate(
                            context, 'ExerciseCreate.string2'),
                        labelStyle: TextStyle(color: ThemeConfig.textColor)),
                  ),
                  TextFormField(
                    initialValue: _exercise.description,
                    inputFormatters: [LengthLimitingTextInputFormatter(2000)],
                    onSaved: (String value) {
                      _exercise.description = value.trim();
                    },
                    style: TextStyle(color: ThemeConfig.dialogTextColor),
                    cursorColor: ThemeConfig.dialogTextColor,
                    maxLines: 3,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeConfig.textColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeConfig.textColor)),
                        labelText: FlutterI18n.translate(
                            context, 'ExerciseCreate.string3'),
                        labelStyle: TextStyle(color: ThemeConfig.textColor)),
                  ),
                  SizedBox(height: 20),
                  _inputTime(),
                  SizedBox(height: 20),
                  _inputWeight(),
                  SizedBox(height: 20),
                  _inputRepeat(),
                ],
              ),
            ),
            SizedBox(height: 30),
            RoundButton(
              text: FlutterI18n.translate(context, 'ExerciseCreate.string4'),
              backgroundColor: ThemeConfig.defaultBackgroundColor,
              onPressed: () {
                SystemHelpers.vibrate25();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.of(context).pop(_exercise);
                }
              },
            )
          ],
        ));
  }

  Widget _inputWeight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove, color: ThemeConfig.textColor),
          onPressed: () {
            SystemHelpers.vibrate25();
            if (_weightController.text.trim().isNotEmpty) {
              double value = double.parse(_weightController.text);
              _weightController.text = (--value).toString();
            } else {
              _weightController.text = "0";
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
                  Text(FlutterI18n.translate(context, 'ExerciseCreate.string5'),
                      style: TextStyle(
                          color: ThemeConfig.textColor, fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(MdiIcons.weight,
                        color: ThemeConfig.textColor, size: 20),
                  ),
                ],
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  WhitelistingTextInputFormatter(RegExp("[0-9.,]"))
                ],
                onSaved: (String value) {
                  try {
                    _exercise.weight = double.parse(value.trim());
                  } on FormatException catch (_) {
                    _exercise.weight = 0.0;
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
            if (_weightController.text.trim().isNotEmpty) {
              double value = double.parse(_weightController.text);
              _weightController.text = (++value).toString();
            } else {
              _weightController.text = "0";
            }
          },
        ),
      ],
    );
  }

  Widget _inputRepeat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove, color: ThemeConfig.textColor),
          onPressed: () {
            SystemHelpers.vibrate25();
            if (_repeatController.text.trim().isNotEmpty) {
              int value = int.parse(_repeatController.text);
              _repeatController.text = (--value).toString();
            } else {
              _repeatController.text = "0";
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
                  Text(FlutterI18n.translate(context, 'ExerciseCreate.string6'),
                      style: TextStyle(
                          color: ThemeConfig.textColor, fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.repeat,
                        color: ThemeConfig.textColor, size: 20),
                  ),
                ],
              ),
              TextFormField(
                controller: _repeatController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  WhitelistingTextInputFormatter(RegExp("[0-9]"))
                ],
                onSaved: (String value) {
                  try {
                    _exercise.repetitions = int.parse(value);
                  } on FormatException catch (_) {
                    _exercise.repetitions = 0;
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
            if (_repeatController.text.trim().isNotEmpty) {
              int value = int.parse(_repeatController.text);
              _repeatController.text = (++value).toString();
            } else {
              _repeatController.text = "0";
            }
          },
        )
      ],
    );
  }

  Widget _inputTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove, color: ThemeConfig.textColor),
          onPressed: () {
            SystemHelpers.vibrate25();
            if (_timeController.text.trim().isNotEmpty) {
              int value = int.parse(_timeController.text);
              _timeController.text = (--value).toString();
            } else {
              _timeController.text = "0";
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
                  Text(FlutterI18n.translate(context, 'ExerciseCreate.string7'),
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
                controller: _timeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  WhitelistingTextInputFormatter(RegExp("[0-9]"))
                ],
                onSaved: (String value) {
                  try {
                    _exercise.seconds = int.parse(value);
                  } on FormatException catch (_) {
                    _exercise.seconds = 0;
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
            if (_timeController.text.trim().isNotEmpty) {
              int value = int.parse(_timeController.text);
              _timeController.text = (++value).toString();
            } else {
              _timeController.text = "0";
            }
          },
        )
      ],
    );
  }
}
