import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/mainInherited_widget.dart';
import 'package:simple_exercise_calendar/helpers/progress_widget.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_edit_dialog.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String text = await showEditDialog(context, "Create exercise", "Exercise", "");

            if (text != null && text.isNotEmpty) {
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
        body: ProgressWidget(
          showStream: MainInherited.of(context).loaderProgressStream,
                  child: DragAndDropList<ExerciseData>(_list,
              onDragFinish: (int before, int after) async {
            ExerciseData data = _list[before];
            _list.removeAt(before);
            _list.insert(after, data);

            await widget.plan.updateExercisesOrder(_list);
          }, canBeDraggedTo: (one, two) {
            return true;
          }, itemBuilder: (BuildContext context, ExerciseData item) {
            return Card(
              color: Colors.blueGrey[700],
              child: ListTile(
                title: Text(
                  item.text,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  String text = await showEditDialog(context, "Create exercise", "Exercise", item.text);
                  if (text != null && text.isNotEmpty) {
                    await item.updateText(text);
                  }
                },
                trailing: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      bool delete =
                          await showDeleteDialog(context, "Delete Plan?");
                      if (delete != null && delete) {
                        setState(() {
                          _list.remove(item);  
                        });
                        
                        await item.delete();
                      }
                    }),
              ),
            );
          }),
        ));
  }
}
