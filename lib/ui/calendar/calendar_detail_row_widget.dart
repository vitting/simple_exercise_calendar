import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_sub_widget.dart';

class CalendarDetailRow extends StatefulWidget {
  final ExerciseData item;

  const CalendarDetailRow({Key key, this.item}) : super(key: key);
  @override
  _CalendarDetailRowState createState() => _CalendarDetailRowState();
}

class _CalendarDetailRowState extends State<CalendarDetailRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.item.closed
          ? ThemeConfig.rowBackgroundColor2
          : ThemeConfig.rowBackgroundColor,
      child: CheckboxListTile(
        value: widget.item.closed,
        onChanged: (bool value) async {
          await widget.item.updateClosed(value);
          setState(() {});
        },
        title: Text(widget.item.text,
            style: TextStyle(
                color: widget.item.closed
                    ? ThemeConfig.rowTextColor2
                    : ThemeConfig.rowTextColor,
                fontWeight: FontWeight.normal)),
        subtitle: ExerciseSub(
          item: widget.item,
          editMode: false,
          repetitionsDone: widget.item.repetitionsDone,
          onTapRepetitions: (bool value) {
            ///true = Single tap | false = double tap
            if (value) {
              if (widget.item.repetitions >= widget.item.repetitionsDone + 1) {
                setState(() {
                  widget.item.updateRepetitionsDone(++widget.item.repetitionsDone);
                });
              }
            } else {
              print(widget.item.repetitionsDone - 1 >= 0);
              if (widget.item.repetitionsDone - 1 <= widget.item.repetitions && widget.item.repetitionsDone - 1 >= 0) {
                setState(() {
                  widget.item.updateRepetitionsDone(--widget.item.repetitionsDone);
                });
              }
            }
            
          },
        ),
      ),
    );
  }
}
