import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/helpers/title_two_lines_widget.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_create.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_number_edit_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_sub_widget.dart';

class ExercisesDetail extends StatefulWidget {
  final ExercisePlanData plan;
  final bool create;

  const ExercisesDetail({Key key, this.plan, this.create = true})
      : super(key: key);
  @override
  ExercisesDetailState createState() {
    return new ExercisesDetailState();
  }
}

class ExercisesDetailState extends State<ExercisesDetail> {
  List<ExerciseData> _list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getData();
  }

  void _getData() async {
    List<ExerciseData> list = await widget.plan.getExercises();
    setState(() {
      _list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: widget.create
            ? FloatingActionButton(
                backgroundColor:
                    ThemeConfig.floatingActionButtonBackgroundColor,
                onPressed: () async {
                  SystemHelpers.vibrate25();
                  _addExerciseToPlan(context);
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Icon(Icons.add,
                            size: 40, color: ThemeConfig.textColor)),
                    Center(
                        child: Icon(MdiIcons.dumbbell,
                            size: 40, color: ThemeConfig.iconSecondLayerColor)),
                  ],
                ),
              )
            : null,
        appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(MdiIcons.dumbbell),
              )
            ],
            title: TitleTwoLines(
              line1: "Øvelser",
              line2: "Plan: ${widget.plan.title}",
            )),
        body: _createList());
  }

  Widget _createList() {
    Widget value = Center(
      child: NoData(
          backgroundIcon: MdiIcons.dumbbell,
          text: "Ingen øvelser",
          text2: widget.create ? "Opret en øvelse" : null),
    );

    if (_list.length == 0) return value;

    if (widget.create) {
      if (_list.length == 1) {
        /// Fix to avoid bug in DragAndDropList when only 1 element is present and dragged
        return _createExerciseRow(_list[0]);
      } else {
        return DragAndDropList<ExerciseData>(_list,
            onDragFinish: _onDragFinish,
            canBeDraggedTo: (int one, int two) => true,
            itemBuilder: (BuildContext context, ExerciseData item) {
              return _createExerciseRow(item);
            });
      }
    } else {
      return ListView.builder(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int position) {
            ExerciseData item = _list[position];
            return _createExerciseRow(item);
          });
    }
  }

  void _addExerciseToPlan(BuildContext context) async {
    ExerciseData exercise = await Navigator.of(context).push<ExerciseData>(
        MaterialPageRoute(builder: (BuildContext context) => ExerciseCreate()));

    if (exercise != null) {
      exercise.index = _list.length;
      await widget.plan.addExercise(exercise);
      _list.add(exercise);
    }
  }

  void _onDragFinish(int before, int after) async {
    if (before != after && _list.length > 1) {
      ExerciseData data = _list[before];
      _list.removeAt(before);
      _list.insert(after, data);

      await widget.plan.updateExercisesOrder(_list);
    }
  }

  Widget _createExerciseRow(ExerciseData item) {
    return Card(
      color: ThemeConfig.rowBackgroundColor,
      child: ListTile(
        title: Text(
          item.text,
          style: TextStyle(color: ThemeConfig.rowTextColor),
        ),
        subtitle: ExerciseSub(
          item: item,
          editMode: true,
          onTapSeconds: (_) async {
            SystemHelpers.vibrate25();
            dynamic result = await showEditNumberDialog(context, "Sekunder",
                item.seconds.toString(), ExerciseNumberEditDialogType.integer);
            if (result != null) {
              int value = int.tryParse(result);
              if (value != null) {
                await item.updateSeconds(value);
                _getData();
              }
            }
          },
          onTapWeight: (_) async {
            SystemHelpers.vibrate25();
            dynamic result = await showEditNumberDialog(context, "Vægt",
                item.weight.toString(), ExerciseNumberEditDialogType.double);
            if (result != null) {
              double value = double.tryParse(result);
              if (value != null) {
                await item.updateWeight(value);
                _getData();
              }
            }
          },
          onTapRepetitions: (_) async {
            SystemHelpers.vibrate25();
            dynamic result = await showEditNumberDialog(
                context,
                "Gentagelser",
                item.repetitions.toString(),
                ExerciseNumberEditDialogType.integer);

            if (result != null) {
              int value = int.tryParse(result);
              if (value != null) {
                await item.updateRepetitions(int.tryParse(result));
                _getData();
              }
            }
          },
        ),
        onTap: widget.create
            ? () {
                SystemHelpers.vibrate25();
                _editExercise(item);
              }
            : null,
        trailing: widget.create
            ? IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: ThemeConfig.rowTextColor,
                ),
                onPressed: () {
                  SystemHelpers.vibrate25();
                  _showBottomMenu(item);
                })
            : null,
      ),
    );
  }

  void _showBottomMenu(ExerciseData item) async {
    int result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
          color: ThemeConfig.bottomSheetBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.content_copy,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text("Kopier",
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(sheetContext).pop(0);
                    }),
              ),
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.edit,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text("Redigere",
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(sheetContext).pop(1);
                    }),
              ),
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.delete,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text("Slet",
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(sheetContext).pop(2);
                    }),
              )
            ],
          )),
    );

    if (result != null) {
      if (result == 0) {
        ExerciseData copy = ExerciseData.copy(item);
        await copy.save();
        _getData();
      } else if (result == 1) {
        _editExercise(item);
      } else if (result == 2) {
        bool delete =
            await showDeleteDialog(context, "Slet", "Slet denne øvelse?");
        if (delete != null && delete) {
          setState(() {
            _list.remove(item);
          });

          await item.delete();
        }
      }
    }
  }

  Future<void> _editExercise(ExerciseData item) async {
    ExerciseData exercise =
        await Navigator.of(context).push<ExerciseData>(MaterialPageRoute(
            builder: (BuildContext context) => ExerciseCreate(
                  exercise: item,
                )));

    if (exercise != null) {
      await exercise.update();
    }
  }
}
