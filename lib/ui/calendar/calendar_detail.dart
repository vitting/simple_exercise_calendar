import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';

class CalendarDetail extends StatefulWidget {
  final DateTime date;

  const CalendarDetail({Key key, this.date}) : super(key: key);
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
        title: Text(DateTimeHelpers.dDmmyyyy(widget.date)),
      ),
      body: Container(
        child: Text("Create"),
      ),
      
    );
  }
}