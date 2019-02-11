import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/title_two_lines_widget.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class CalendarExercisePlanChooser extends StatelessWidget {
  final DateTime date;

  const CalendarExercisePlanChooser({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TitleTwoLines(
            line1: "Tilføj en plan til",
            line2: DateTimeHelpers.dDmmyyyy(date),
          )
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

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                var plan = snapshot.data[position];
                return Card(
                  // color: Colors.blueGrey[100],
                  child: ListTile(
                    title: Text(plan.title),
                    trailing: IconButton(
                      tooltip: "Tilføj plan til dag",
                      color: Colors.blue,
                      splashColor: Colors.blue,
                      icon: Stack(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.heart,
                            size: 40,
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Icon(Icons.add, size: 20,),
                          )
                        ],
                      ),
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
