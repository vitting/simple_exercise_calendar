import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/helpers/title_two_lines_widget.dart';

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
      _list.forEach((v) {
        print("${v.index} - ${v.text}");
      });
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
                  _addExerciseToPlan(context);
                },
                child: Stack(
                  children: <Widget>[
                    Center(child: Icon(Icons.add, size: 40, color: ThemeConfig.textColor)),
                    Center(child: Icon(MdiIcons.dumbbell, size: 40, color: ThemeConfig.iconSecondLayerColor)),
                    
                  ],
                ),
              )
            : null,
        appBar: AppBar(
            title: TitleTwoLines(
          line1: "Plan:",
          line2: widget.plan.title,
        )),
        body: _createList());
  }

  Widget _createList() {
    Widget value = Center(
      child: NoData(
        backgroundIcon: MdiIcons.dumbbell,
        text: "Ingen øvelser fundet",
        text2: widget.create ? "Opret en øvelse" : null,
        buttonIcon: widget.create ? Icons.add_circle_outline : null,
        onIconTap: widget.create ? (_) {} : null,
      ),
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
        } 
      );
    }
  }

  void _addExerciseToPlan(BuildContext context) async {
    String text = await showEditDialog(context, "Ny øvelse", "Øvelse", "");

    if (text != null && text.isNotEmpty) {
      ExerciseData data = await widget.plan.addExercise(text, _list.length);
      _list.add(data);
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
        onTap: widget.create
            ? () {
                _editExerciseText(item);
              }
            : null,
        trailing: widget.create
            ? IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: ThemeConfig.rowTextColor,
                ),
                onPressed: () {
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
        _editExerciseText(item);
      } else if (result == 2) {
        bool delete = await showDeleteDialog(context, "Slet denne øvelse?");
        if (delete != null && delete) {
          setState(() {
            _list.remove(item);
          });

          await item.delete();
        }
      }
    }
  }

  void _editExerciseText(ExerciseData item) async {
    String text = await showEditDialog(context, "Øvelse", "Øvelse", item.text);
    if (text != null && text.isNotEmpty && (item.text != text)) {
      await item.updateText(text);
    }
  }
}
