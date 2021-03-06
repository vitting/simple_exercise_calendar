import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/helpers/title_two_lines_widget.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercicise_plans.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class CalendarExercisePlanChooser extends StatelessWidget {
  final DateTime date;

  const CalendarExercisePlanChooser({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(FontAwesomeIcons.heart),
              )
            ],
            title: TitleTwoLines(
              line1: "Tilføj en plan til",
              line2: DateTimeHelpers.dDLmMyyyy(context, date),
            )),
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
                  text: "Ingen planer",
                  text2: "Opret en plan",
                  buttonIcon: Icons.view_list,
                  onIconTap: (_) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ExercisePlansMain()));
                  },
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                var plan = snapshot.data[position];
                return Card(
                  color: ThemeConfig.rowBackgroundColor,
                  child: ListTile(
                    title: Text(plan.title,
                        style: TextStyle(color: ThemeConfig.rowTextColor)),
                    trailing: IconButton(
                      tooltip: "Tilføj plan til dag",
                      icon: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: -3,
                            child: Icon(
                              FontAwesomeIcons.heart,
                              color: ThemeConfig.rowTextColor,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 10,
                            child: Icon(
                              Icons.add,
                              color: ThemeConfig.rowTextColor,
                              size: 20,
                            ),
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
