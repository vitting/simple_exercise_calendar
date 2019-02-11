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
        floatingActionButton: FloatingActionButton(
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
                      onLongPress: () async {
                        String title = await showEditDialog(
                            context, "Edit Plan", "Plan name", plan.title);
                        if (title.isNotEmpty) {
                          setState(() {
                            plan.updateTitle(title);
                          });
                        }
                      },
                      leading: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () async {
                            bool delete =
                                await showDeleteDialog(context, "Delete Plan?");
                            if (delete != null && delete) {
                              await plan.delete();
                              setState(() {});
                            }
                          })),
                );
              },
            );
          },
        ));
  }
}
