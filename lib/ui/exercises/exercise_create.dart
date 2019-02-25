import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:simple_exercise_calendar/helpers/add_subtract_text_field_widget.dart';
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
  String _title;
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.exercise == null) {
      _title = FlutterI18n.translate(context, 'ExerciseCreate.string8');
    } else {
      _title = FlutterI18n.translate(context, 'ExerciseCreate.string9');
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
        appBar: AppBar(
          title: Text(_title),
        ),
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
                    inputFormatters: [LengthLimitingTextInputFormatter(5000)],
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
    return AddSubtractTextField(
      controller: _weightController,
      label: FlutterI18n.translate(context, 'ExerciseCreate.string5'),
      maxLength: 5,
      whiteListRegExPattern: "[0-9.,]",
      onTapSubtract: (_) {
        if (_weightController.text.trim().isNotEmpty) {
          double value = double.parse(_weightController.text);
          _weightController.text = (--value).toString();
        } else {
          _weightController.text = "0";
        }
      },
      onTapAdd: (_) {
        if (_weightController.text.trim().isNotEmpty) {
          double value = double.parse(_weightController.text);
          _weightController.text = (++value).toString();
        } else {
          _weightController.text = "0";
        }
      },
      onSave: (String value) {
        try {
          _exercise.weight = double.parse(value.trim());
        } on FormatException catch (_) {
          _exercise.weight = 0.0;
        }
      },
    );
  }

  Widget _inputRepeat() {
    return AddSubtractTextField(
      controller: _repeatController,
      label: FlutterI18n.translate(context, 'ExerciseCreate.string6'),
      maxLength: 3,
      whiteListRegExPattern: "[0-9]",
      onTapSubtract: (_) {
        if (_repeatController.text.trim().isNotEmpty) {
          int value = int.parse(_repeatController.text);
          _repeatController.text = (--value).toString();
        } else {
          _repeatController.text = "0";
        }
      },
      onTapAdd: (_) {
        if (_repeatController.text.trim().isNotEmpty) {
          int value = int.parse(_repeatController.text);
          _repeatController.text = (++value).toString();
        } else {
          _repeatController.text = "0";
        }
      },
      onSave: (String value) {
        try {
          _exercise.repetitions = int.parse(value);
        } on FormatException catch (_) {
          _exercise.repetitions = 0;
        }
      },
    );
  }

  Widget _inputTime() {
    return AddSubtractTextField(
      controller: _timeController,
      label: FlutterI18n.translate(context, 'ExerciseCreate.string7'),
      maxLength: 3,
      whiteListRegExPattern: "[0-9]",
      onTapSubtract: (_) {
        if (_timeController.text.trim().isNotEmpty) {
          int value = int.parse(_timeController.text);
          _timeController.text = (--value).toString();
        } else {
          _timeController.text = "0";
        }
      },
      onTapAdd: (_) {
        if (_timeController.text.trim().isNotEmpty) {
          int value = int.parse(_timeController.text);
          _timeController.text = (++value).toString();
        } else {
          _timeController.text = "0";
        }
      },
      onSave: (String value) {
        try {
          _exercise.seconds = int.parse(value);
        } on FormatException catch (_) {
          _exercise.seconds = 0;
        }
      },
    );
  }
}
