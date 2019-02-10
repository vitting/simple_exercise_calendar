import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/mainInherited_widget.dart';
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
    return FutureBuilder(
      future: ExercisePlanData.getExercisePlans(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExercisePlanData>> snapshot) {
        if (!snapshot.hasData) {
          MainInherited.of(context).showProgressLayer(true);
          return Text("Loader");
        } else {
          MainInherited.of(context).showProgressLayer(false);
        } 

        if (snapshot.hasData && snapshot.data.length == 0) {
          return Text("Ingen plans");
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
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        bool delete = await showDeleteDialog(context, "Delete Plan?");
                        if (delete != null && delete) {
                          await plan.delete();
                        }
                      })),
            );
          },
        );
      },
    );
  }
}
