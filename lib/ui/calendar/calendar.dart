import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/event_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_detail.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar_exercise_plan_chooser.dart';

class CalendarMain extends StatefulWidget {
  @override
  CalendarMainState createState() {
    return new CalendarMainState();
  }
}

class CalendarMainState extends State<CalendarMain> {
  EventList<EventData> _events = EventList<EventData>();
  @override
  void initState() {
    super.initState();
    _getEvents(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CalendarCarousel<EventData>(
        height: 500,
        daysHaveCircularBorder: true,
        iconColor: ThemeConfig.textColor,
        headerTextStyle: TextStyle(color: ThemeConfig.textColor),
        headerTitleTouchable: true,
        todayButtonColor: ThemeConfig.defaultBackgroundColor,
        dayButtonColor: Colors.blueGrey[50],
        onCalendarChanged: (DateTime date) {
          _getEvents(date);
        },
        onDayPressed: (DateTime date, List<EventData> items) async {
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
            bool removed = await Navigator.of(context).push(
                MaterialPageRoute<bool>(
                    builder: (BuildContext context) =>
                        CalendarDetail(event: items[0])));
            if (removed != null && removed) {
              _getEvents(date);
            }
          }
        },
        weekDayFormat: WeekdayFormat.standaloneNarrow,
        weekdayTextStyle: TextStyle(color: ThemeConfig.textColor),
        markedDateShowIcon: true,
        markedDateMoreShowTotal: false,
        markedDateIconBuilder: (EventData item) {
          return Stack(
            children: <Widget>[
              Positioned(
                left: -1,
                child: Icon(MdiIcons.heart,
                    size: 35, color: Colors.blue[800].withAlpha(90)),
              )
            ],
          );
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
        _events.add(item.date, item);
      });
    });
  }
}
