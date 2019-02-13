import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercicises.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showExitDialog(context, "Vil du afslutte?");
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                
              },
            )
          ],
          title: Text("Øvelses planlægger"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeConfig.floatingActionButtonBackgroundColor,
          tooltip: "Dine planer",
          child: Icon(Icons.view_list, size: 30),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ExercisesMain()));
          },
        ),
        body: CalendarMain()),
    );
  }
}
