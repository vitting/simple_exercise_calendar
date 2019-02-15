import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/event_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_detail_row_widget.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_exercise_plan_chooser.dart';

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
                SystemHelpers.vibrate25();
                _popupMenuAction(value);
              },
              offset: Offset(10, 50),
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text("Fjern plan"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.view_list),
                        title: Text("Skift plan"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        leading: Icon(Icons.update),
                        title: Text("Opdater plan"),
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
                return CalendarDetailRow(
                  item: item,
                );
              },
            );
          },
        ));
  }

  void _popupMenuAction(int value) {
    switch (value) {
      case 0:
        _removePlan();
        break;
      case 1:
        _changePlan();
        break;
      case 2:
        _updatePlan();
        break;
      default:
    }
  }

  void _removePlan() async {
    String currentPlanTitle = await widget.event.getEventPlanTitle();
    bool delete = await showDeleteDialog(context, "Fjern", "Fjern planen:\n\n$currentPlanTitle");
    if (delete != null && delete) {
      await widget.event.deleteExercisePlan();
      await widget.event.delete();
      Navigator.of(context).pop(true);
    }
  }

  void _changePlan() async {
    ExercisePlanData exercisePlan = await Navigator.of(context).push(
        MaterialPageRoute<ExercisePlanData>(
            builder: (BuildContext context) =>
                CalendarExercisePlanChooser(date: widget.event.date)));

    if (exercisePlan != null) {
      String currentPlanTitle = await widget.event.getEventPlanTitle();
      bool change = await showDeleteDialog(
          context, "Skift plan", "Er du sikker på du skifte planen:\n\n$currentPlanTitle\n\nmed\n\n${exercisePlan.title}");
      if (change != null && change) {
        await widget.event.deleteExercisePlan();
        await widget.event.delete();
        await exercisePlan.addEvent(widget.event.date);
        Navigator.of(context).pop(true);
      }
    }
  }

  void _updatePlan() async {
    String currentPlanTitle = await widget.event.getEventPlanTitle();
    bool update = await showDeleteDialog(context, "Opdatere plan",
        "Vil opdatere planen:\n\n$currentPlanTitle");
    if (update != null && update) {
      await widget.event.updateExercises();
      setState(() {});
    }
  }
}
