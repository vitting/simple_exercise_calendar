import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';

class ExercisesMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ExercisePlanData.getExercisePlans(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExercisePlanData>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Ingen data");
        }

        if (snapshot.hasData && snapshot.data.length == 0) {
          return Text("Ingen plans");
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int position) {
            ExercisePlanData plan = snapshot.data[position];
            return Card(
              child: ListTile(
                title: Text(plan.title),
              ),
            );
          },
        );
      },
    );
  }
}
