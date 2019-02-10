import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CalendarCarousel<int>(
        onDayPressed: (DateTime date, List<int> items) {
          print(date);
          print(items);
        },
        weekDayFormat: WeekdayFormat.standaloneNarrow,
        markedDateShowIcon: true,
        markedDateMoreShowTotal: true,
        markedDateIconBuilder: (int item) {
          return Icon(Icons.people);
        },
        markedDateIconMaxShown: 1,
        markedDatesMap: EventList<int>(
          events: {
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [1, 4, 5, 10, 56, 67, 78, 89],
            DateTime(DateTime.now().subtract(Duration(minutes: 1440)).year, DateTime.now().subtract(Duration(minutes: 1440)).month, DateTime.now().subtract(Duration(minutes: 1440)).day): [1, 4, 5, 10]
          }
        ),
        locale: "da",
        // locale: "en",
      ),
    );
  }
}