import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/mainInherited_widget.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class CalendarExercisePlanChooser extends StatelessWidget {
  final DateTime date;

  const CalendarExercisePlanChooser({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DateTimeHelpers.dDmmyyyy(date)),
        ),
        body: FutureBuilder(
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

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                var plan = snapshot.data[position];
                return Card(
                  color: Colors.blueGrey[100],
                  child: ListTile(
                    title: Text(plan.title),
                    trailing: IconButton(
                      splashColor: Colors.blue,
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        Navigator.of(context).pop(plan);
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ExercisesDetail(
                                plan: plan,
                                create: false,
                              )));
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
