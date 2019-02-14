import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/mainInherited_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/home/home.dart';

void main() => runApp(MainInherited(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: ThemeConfig.scaffoldBackgroundColor,
      ),
      home: Home(),
    )));
