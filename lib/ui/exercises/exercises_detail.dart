import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/bottom_menu_row_widget.dart';
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
                child: Icon(Icons.add,
                            size: 40, color: ThemeConfig.textColor),
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
              line1: FlutterI18n.translate(context, 'ExercisesDetail.string1'),
              line2:
                  "${FlutterI18n.translate(context, 'ExercisesDetail.string2')}: ${widget.plan.title}",
            )),
        body: _createList());
  }

  Widget _createList() {
    Widget value = Center(
      child: NoData(
          backgroundIcon: MdiIcons.dumbbell,
          text: FlutterI18n.translate(context, 'ExercisesDetail.string3'),
          text2: widget.create
              ? FlutterI18n.translate(context, 'ExercisesDetail.string4')
              : null),
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
            dynamic result = await showEditNumberDialog(
                context,
                FlutterI18n.translate(context, 'ExercisesDetail.string5'),
                item.seconds.toString(),
                ExerciseNumberEditDialogType.integer);
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
            dynamic result = await showEditNumberDialog(
                context,
                FlutterI18n.translate(context, 'ExercisesDetail.string6'),
                item.weight.toString(),
                ExerciseNumberEditDialogType.double);
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
                FlutterI18n.translate(context, 'ExercisesDetail.string7'),
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
              BottomMenuRow(
                icon: Icons.content_copy,
                text: FlutterI18n.translate(context, 'ExercisesDetail.string8'),
                value: 0,
              ),
              BottomMenuRow(
                icon: Icons.edit,
                text: FlutterI18n.translate(context, 'ExercisesDetail.string9'),
                value: 1,
              ),
              BottomMenuRow(
                icon: Icons.delete,
                text: FlutterI18n.translate(context, 'ExercisesDetail.string10'),
                value: 2,
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
        bool delete = await showDeleteDialog(
            context,
            FlutterI18n.translate(context, 'ExercisesDetail.string11'),
            FlutterI18n.translate(context, 'ExercisesDetail.string12'));
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
