import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
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
    if (!widget.create) {
      _getData();
    }
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () async {
            _addExerciseToPlan(context);
          },
          child: Icon(Icons.add, size: 30),
        ),
        appBar: AppBar(
            title: TitleTwoLines(
          line1: "Plan:",
          line2: widget.plan.title,
        )),
        body: _list.length == 0
            ? Center(
                child: NoData(
                  backgroundIcon: FontAwesomeIcons.heart,
                  text: "Ingen øvelser fundet",
                  text2: "Opret en øvelse",
                  buttonIcon: Icons.add_circle_outline,
                  onIconTap: (_) {},
                ),
              )

            /// Fix to avoid bug in DragAndDropList when only 1 element is present and dragged
            : _list.length == 1
                ? _createExerciseRow(_list[0])
                : DragAndDropList<ExerciseData>(_list,
                    onDragFinish: _onDragFinish,
                    canBeDraggedTo: (int one, int two) => true,
                    itemBuilder: (BuildContext context, ExerciseData item) {
                      return _createExerciseRow(item);
                    }));
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
      color: Colors.blueGrey[700],
      child: ListTile(
        title: Text(
          item.text,
          style: TextStyle(color: Colors.white),
        ),
        onLongPress: () {
          _editExerciseText(item);
        },
        trailing: IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              _showBottomMenu(item);
            }),
      ),
    );
  }

  void _showBottomMenu(ExerciseData item) async {
    int result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext sheetContext) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.content_copy),
                    title: Text("Kopier"),
                    onTap: () {
                      Navigator.of(sheetContext).pop(0);
                    }),
                ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Redigere"),
                    onTap: () {
                      Navigator.of(sheetContext).pop(1);
                    }),
                ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Slet"),
                    onTap: () {
                      Navigator.of(sheetContext).pop(2);
                    })
              ],
            ));

    if (result != null) {
      if (result == 0) {
        ExerciseData copy = ExerciseData.copy(item);
        await copy.save();
        _getData();
      } else if (result == 1) {
        _editExerciseText(item);
      } else if (result == 2) {
        bool delete = await showDeleteDialog(context, "Slet denne plan?");
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
