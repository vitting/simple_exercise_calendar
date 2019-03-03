import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/bottom_menu_row_widget.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_note_data.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_detail_note_row_widget.dart';

class CalendarDetailNotes extends StatefulWidget {
  final ExerciseData item;
  final Stream<bool> closedStream;

  const CalendarDetailNotes({Key key, this.item, this.closedStream})
      : super(key: key);
  @override
  _CalendarDetailNotesState createState() => _CalendarDetailNotesState();
}

class _CalendarDetailNotesState extends State<CalendarDetailNotes>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  AnimationController _controller;
  Animation<double> _iconTurns;
  List<CalendarDetailNoteRow> _exerciseNotesRow = [];
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();

    _isClosed = widget.item.closed;
    _getExerciseNote();

    widget.closedStream.listen((bool value) {
      setState(() {
        _isClosed = value;
        _getExerciseNote();
      });
    });

    _controller = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (bool expanded) async {
        if (expanded) {
          await _getExerciseNote();
          _controller.reverse();
        } else {
          _controller.forward();
        }
      },
      leading: IconButton(
        icon: Icon(Icons.add,
            color: widget.item.closed
                ? ThemeConfig.rowTextColor3
                : ThemeConfig.rowTextColor),
        onPressed: widget.item.closed
            ? null
            : () async {
                await _addExerciseNote(context);
              },
      ),
      trailing: RotationTransition(
        turns: _iconTurns,
        child: Icon(Icons.expand_less,
            color: widget.item.closed
                ? ThemeConfig.rowTextColor2
                : ThemeConfig.rowTextColor),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: _exerciseNotesRow.length == 0 ? 0 : 10),
          child: Column(
            children: _exerciseNotesRow,
          ),
        )
      ],
      initiallyExpanded: true,
      title: Text(
        "Kommentar",
        style: TextStyle(
            color: widget.item.closed
                ? ThemeConfig.rowTextColor2
                : ThemeConfig.rowTextColor),
      ),
    );
  }

  Future<void> _addExerciseNote(BuildContext context) async {
    String note = await showEditDialog(context, "Tilføj note", "Note", "", false, 2500);
    if (note != null && note.isNotEmpty) {
      await widget.item.addExerciseNote(note);
      await _getExerciseNote();
    }
  }

  Future<void> _getExerciseNote() async {
    List<ExerciseNoteData> exerciseNotes = await widget.item.getExerciseNotes();
    List<CalendarDetailNoteRow> exerciseNotesRow =
        exerciseNotes.map<CalendarDetailNoteRow>((ExerciseNoteData note) {
      return CalendarDetailNoteRow(
        closed: _isClosed,
        exerciseNote: note,
        onLongPress: (ExerciseNoteData item) {
          _showBottomMenu(item);
        },
      );
    }).toList();

    setState(() {
      _exerciseNotesRow = exerciseNotesRow;
    });
  }

  void _showBottomMenu(ExerciseNoteData item) async {
    int result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
          color: ThemeConfig.bottomSheetBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomMenuRow(
                icon: Icons.edit,
                text: "Redigere",
                value: 0,
              ),
              BottomMenuRow(
                icon: Icons.delete,
                text: "Slet",
                value: 1,
              )
            ],
          )),
    );

    if (result != null) {
      SystemHelpers.vibrate25();
      
      switch (result) {
        case 0:
          String note = await showEditDialog(context, "Redigere note", "Note", item.note, false, 2500);  
          if (note != null && note.isNotEmpty) {
            await widget.item.updateExerciseNote(note, item);
          }
          break;
        case 1: 
          await widget.item.deleteExerciseNote(item);
          break;
      }

      await _getExerciseNote();
    }
  }
}
