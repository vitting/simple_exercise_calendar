import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_delete_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_edit_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_number_edit_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

Future<String> showEditDialog(
    BuildContext context, String title, String lable, String value,
    [bool autoFocus = false]) async {
  return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => ExerciseEditDialog(
            title: title,
            lable: lable,
            value: value,
            autoFocus: autoFocus,
          ));
}

Future<dynamic> showEditNumberDialog(BuildContext context, String title,
    String value, ExerciseNumberEditDialogType type,
    [bool autoFocus = false]) async {
  return showDialog<dynamic>(
      context: context,
      builder: (BuildContext dialogContext) => ExerciseNumberEditDialog(
            buttonText:
                FlutterI18n.translate(context, 'Common_Functions.string3'),
            title: title,
            value: value,
            type: type,
            autoFocus: autoFocus,
          ));
}

Future<bool> showDeleteDialog(
    BuildContext context, String titleText, String bodyText) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) =>
          ExerciseDeleteDialog(titleText: titleText, bodyText: bodyText));
}

void addNewPlan(BuildContext context) async {
  String title = await showEditDialog(
      context,
      FlutterI18n.translate(context, 'Common_Functions.string1'),
      FlutterI18n.translate(context, 'Common_Functions.string2'),
      "",
      true);

  if (title != null && title.isNotEmpty) {
    ExercisePlanData plan = ExercisePlanData(title: title);

    int result = await plan.save();
    if (result != 0) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ExercisesDetail(
                plan: plan,
              )));
    }
  }
}
