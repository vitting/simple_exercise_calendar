import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';

// const List<String> dayNameLong = [
//   "Mandag",
//   "Tirsdag",
//   "Onsdag",
//   "Torsdag",
//   "Fredag",
//   "Lørdag",
//   "Søndag"
// ];

class DateTimeHelpers {
  static int weekInYear(DateTime date) {
    return int.parse(formatDate(date, [W]));
  }

  static int daysInMonth(int monthNum, int year) {
    List<int> monthLength = new List(12);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum - 1];
  }

  static bool leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }

  static String ddmmyyyyHHnn(DateTime date) {
    try {
      return formatDate(date, [dd, "-", mm, "-", yyyy, "  ", HH, ":", nn]);
    } catch (e) {
      print("DateTimeHelpers.ddmmyyyyHHnn : $e");
      return "";
    }
  }

  static String ddmmyyyy(DateTime date) {
    return formatDate(date, [dd, "-", mm, "-", yyyy]);
  }

  static String dDLmmyyyy(BuildContext context, DateTime date) {
    return formatDate(
        date, ["${FlutterI18n.translate(context, 'DayNamesLong.${date.weekday - 1}')} ", dd, "-", mm, "-", yyyy]);
  }

  static String dDLmMyyyy(BuildContext context, DateTime date) {
    return formatDate(
        date, ["${FlutterI18n.translate(context, 'DayNamesLong.${date.weekday - 1}')} ", dd, ". ", "${FlutterI18n.translate(context, 'MonthNamesShort.${date.month - 1}')}", " ", yyyy]);
  }

  static String dDSmmyyyy(BuildContext context, DateTime date) {
    return formatDate(
        date, ["${FlutterI18n.translate(context, 'DayNamesShort.${date.weekday - 1}')} ", dd, "-", mm, "-", yyyy]);
  }

  static String hhnn(dynamic date) {
    DateTime dateToFormat;
    if (date is TimeOfDay) {
      TimeOfDay tod = date;
      dateToFormat = DateTime(2000, 1, 1, tod.hour, tod.minute);
    } else {
      dateToFormat = date;
    }
    return formatDate(dateToFormat, [HH, ":", nn]);
  }

  static Duration totalTime(DateTime date1, DateTime date2) {
    return date2.difference(date1);
  }

  static bool dateCompare(DateTime date1, DateTime date2) {
    DateTime a = DateTime(date1.year, date1.month, date1.day);
    DateTime b = DateTime(date2.year, date2.month, date2.day);

    return a.compareTo(b) == 0 ? true : false;
  }

  static int getAge(DateTime birthdate) {
    if (birthdate == null) return 0;

    DateTime today = DateTime.now();
    int years = today.year - birthdate.year;
    int age;
    if (birthdate.month <= today.month) {
      if (today.day < birthdate.day) {
        age = years - 1;
      } else
        age = years;
    } else {
      age = years - 1;
    }

    return age;
  }

  static bool isVvalidDateFormat(String dateString) {
    RegExp reg = RegExp(r"^[0-3]\d-[0-1]\d-[1-2][09]\d\d$");
    return reg.hasMatch(dateString);
  }
}
