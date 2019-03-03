import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/exercise_note_data.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class CalendarDetailNoteRow extends StatelessWidget {
  final bool closed;
  final ExerciseNoteData exerciseNote;
  final ValueChanged<ExerciseNoteData> onLongPress;

  const CalendarDetailNoteRow(
      {Key key, this.closed = false, @required this.exerciseNote, this.onLongPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
          onLongPress: () {
            if (onLongPress != null) {
              SystemHelpers.vibrate25();
              onLongPress(exerciseNote);
            }
          },
          child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              Container(
                  width: 40,
                  child: Icon(MdiIcons.notebook,
                      color: closed
                          ? ThemeConfig.rowTextColor2
                          : ThemeConfig.rowSubTextColor,
                      size: 20)),
              Expanded(
                child: Text(
                    exerciseNote.note,
                    style: TextStyle(
                        color: closed
                            ? ThemeConfig.rowTextColor2
                            : ThemeConfig.rowTextColor)),
              ),
            ],
          )),
    );
  }
}
