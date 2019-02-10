import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:simple_exercise_calendar/helpers/event_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_detail.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_exercise_plan_chooser.dart';

class CalendarMain extends StatefulWidget {
  @override
  CalendarMainState createState() {
    return new CalendarMainState();
  }
}

class CalendarMainState extends State<CalendarMain> {
  EventList<String> _events = EventList<String>();
  @override
  void initState() {
    super.initState();
    _getEvents(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CalendarCarousel<String>(
        onCalendarChanged: (DateTime date) {
          print("ONCALENDARCHANGED: $date");
        },
        onDayPressed: (DateTime date, List<String> items) async {
          if (items.length == 0) {
            ExercisePlanData exercisePlan = await Navigator.of(context).push(
                MaterialPageRoute<ExercisePlanData>(
                    builder: (BuildContext context) =>
                        CalendarExercisePlanChooser(date: date)));

            if (exercisePlan != null) {
              await exercisePlan.addEvent(date);
            }

            _getEvents(date);
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CalendarDetail(date: date)));
          }
        },
        weekDayFormat: WeekdayFormat.standaloneNarrow,
        markedDateShowIcon: true,
        markedDateMoreShowTotal: false,
        markedDateIconBuilder: (String item) {
          return Icon(Icons.person, size: 30, color: Colors.blue[800].withAlpha(80));
        },
        markedDateIconMaxShown: 1,
        markedDatesMap: _events,
        locale: "da",
        // locale: "en",
      ),
    );
  }

  void _getEvents(DateTime date) async {
    List<EventData> list = await EventData.getEventsForMonth(date);
    _events.clear();
    setState(() {
      list.forEach((EventData item) {
        _events.add(item.date, item.exercisePlanId);
      });
    });
  }
}
