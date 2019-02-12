import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class ExercisesMain extends StatefulWidget {
  @override
  ExercisesMainState createState() {
    return new ExercisesMainState();
  }
}

class ExercisesMainState extends State<ExercisesMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planer"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: "Tilføj ny plan",
          child: Icon(Icons.add, size: 30),
          onPressed: () {
            addNewPlan(context);
          },
        ),
        body: FutureBuilder(
          future: ExercisePlanData.getExercisePlans(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ExercisePlanData>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            if (snapshot.hasData && snapshot.data.length == 0) {
              return Center(
                child: NoData(
                  backgroundIcon: FontAwesomeIcons.heart,
                  text: "Ingen planer fundet",
                  text2: "Opret en ny plan",
                  buttonIcon: Icons.add_circle_outline,
                  onIconTap: (_) {
                    addNewPlan(context);
                  },
                ),
              );
            }

            ///TODO: Copy plan
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                ExercisePlanData plan = snapshot.data[position];
                return Card(
                  color: Colors.blueGrey[100],
                  child: ListTile(
                    title: Text(plan.title),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ExercisesDetail(
                                plan: plan,
                                create: false,
                              )));
                    },
                    onLongPress: () {
                      _editPlanTitle(plan);
                    },
                    trailing: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        onPressed: () async {
                          _showBottomMenu(plan);
                        }),
                  ),
                );
              },
            );
          },
        ));
  }

  void _showBottomMenu(ExercisePlanData plan) async {
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
        String title = await showEditDialog(
            context, "Kopier plan", "Plan name", plan.title);
        if (title != null && title.isNotEmpty) {
          await plan.saveCopyWithExercises(title);
        }
      } else if (result == 1) {
        _editPlanTitle(plan);
      } else if (result == 2) {
        bool delete = await showDeleteDialog(context, "Delete Plan?");
        if (delete != null && delete) {
          await plan.delete();
        }
      }

      setState(() {});
    }
  }

  void _editPlanTitle(ExercisePlanData plan) async {
    String title =
        await showEditDialog(context, "Edit Plan", "Plan name", plan.title);
    if (title != null && title.isNotEmpty) {
      setState(() {
        plan.updateTitle(title);
      });
    }
  }
}
