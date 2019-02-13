import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/event_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class CalendarDetail extends StatefulWidget {
  final EventData event;

  const CalendarDetail({Key key, this.event}) : super(key: key);
  @override
  CalendarDetailState createState() {
    return new CalendarDetailState();
  }
}

class CalendarDetailState extends State<CalendarDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                future: widget.event.getExercisePlan(),
                builder: (BuildContext context,
                    AsyncSnapshot<ExercisePlanData> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  if (snapshot.hasData && snapshot.data == null) {
                    return Container();
                  }

                  return Text("Plan: ${snapshot.data.title}",
                      style: TextStyle(fontSize: 16));
                },
              ),
              Text("Dato: ${DateTimeHelpers.dDmmyyyy(widget.event.date)}",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<int>(
              tooltip: "Menu",
              onSelected: (int value) async {
                if (value == 0) {
                  bool delete =
                      await showDeleteDialog(context, "Fjern Planen?");
                  if (delete != null && delete) {
                    await widget.event.deleteExercisePlan();
                    await widget.event.delete();
                    Navigator.of(context).pop(true);
                  }
                }
              },
              offset: Offset(10, 50),
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text("Fjern plan fra dato"),
                      ),
                    )
                  ],
            )
          ],
        ),
        body: FutureBuilder(
          future: widget.event.getExercises(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ExerciseData>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            if (snapshot.hasData && snapshot.data.length == 0) {
              return Center(
                child: NoData(
                    backgroundIcon: FontAwesomeIcons.heart,
                    text: "Ingen øvelser fundet"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                ExerciseData item = snapshot.data[position];
                return Card(
                  color: item.closed
                      ? ThemeConfig.rowBackgroundColor2
                      : ThemeConfig.rowBackgroundColor,
                  child: CheckboxListTile(
                    value: item.closed,
                    onChanged: (bool value) async {
                      await item.updateClosed(value);
                      setState(() {});
                    },
                    title: Text(item.text,
                        style: TextStyle(
                            color: ThemeConfig.rowTextColor,
                            fontWeight: item.closed
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ),
                );
              },
            );
          },
        ));
  }
}
