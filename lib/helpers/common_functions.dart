import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_delete_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_edit_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

Future<String> showEditDialog(
    BuildContext context, String title, String lable, String value, [bool autoFocus = false]) async {
  return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => ExerciseEditDialog(
            title: title,
            lable: lable,
            value: value,
            autoFocus: autoFocus,
          ));
}

Future<bool> showDeleteDialog(BuildContext context, String bodyText) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) =>
          ExerciseDeleteDialog(bodyText: bodyText));
}

void addNewPlan(BuildContext context) async {
  String title = await showEditDialog(context, "Create Plan", "Plan name", "", true);

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
