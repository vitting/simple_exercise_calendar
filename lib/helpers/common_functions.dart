import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_delete_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_edit_dialog.dart';

Future<String> showEditDialog(BuildContext context, String title, String lable, String value) async {
    return showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) => ExerciseEditDialog(
              title: title,
              lable: lable,
              value: value,
            ));
  }

  Future<bool> showDeleteDialog(BuildContext context, String bodyText) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => ExerciseDeleteDialog(bodyText: bodyText)
    );
  }