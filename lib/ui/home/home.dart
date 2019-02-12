import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercicises.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planlægger"),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Dine planer",
          child: Icon(Icons.view_list, size: 30),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ExercisesMain()
            ));
          },
        ),
        body: CalendarMain());
  }
}
