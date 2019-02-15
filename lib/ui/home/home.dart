import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercicise_plans.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(FlutterI18n.translate(context, 'Home.string1')),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ThemeConfig.floatingActionButtonBackgroundColor,
            tooltip: FlutterI18n.translate(context, 'Home.string2'),
            child: Icon(Icons.view_list, size: 30),
            onPressed: () {
              SystemHelpers.vibrate25();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ExercisePlansMain()));
            },
          ),
          body: CalendarMain()),
      onWillPop: () {
        DbHelpers.close();
        return Future.value(true);
      },
    );
  }
}
