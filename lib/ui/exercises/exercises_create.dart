import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_edit_dialog.dart';

class ExercisesCreate extends StatefulWidget {
  final ExercisePlanData plan;

  const ExercisesCreate({Key key, this.plan}) : super(key: key);
  @override
  ExercisesCreateState createState() {
    return new ExercisesCreateState();
  }
}

class ExercisesCreateState extends State<ExercisesCreate> {
  List<ExerciseData> _list = [];

  @override
  void initState() {
    super.initState();
  }

  void getData() async {
    List<ExerciseData> list = await widget.plan.getExercises();
    setState(() {
      _list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String text = await _showEdit();

            if (text.isNotEmpty) {
              ExerciseData data =
                  await widget.plan.addExercise(text, _list.length);
              _list.add(data);
            }
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(widget.plan.title),
        ),
        body: DragAndDropList<ExerciseData>(_list,
            onDragFinish: (int before, int after) async {
          ExerciseData data = _list[before];
          _list.removeAt(before);
          _list.insert(after, data);

          await widget.plan.updateExercisesOrder(_list);
        }, canBeDraggedTo: (one, two) {
          return true;
        }, itemBuilder: (BuildContext context, item) {
          return Card(
            color: Colors.blueGrey[200],
            child: ListTile(
              title: Text(item.text),
              trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    await item.delete();
                  }),
            ),
          );
        }));
  }

  Future<String> _showEdit() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) => ExerciseEditDialog(
              title: "Create Exersice",
              lable: "Exercise text",
            ));
  }
}
