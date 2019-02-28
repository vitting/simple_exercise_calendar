import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/bottom_menu_row_widget.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:simple_exercise_calendar/helpers/event_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/help_dialog.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
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

                  return Text(
                      "${FlutterI18n.translate(context, 'CalendarDetail.string1')}: ${snapshot.data.title}",
                      style: TextStyle(fontSize: 16));
                },
              ),
              Text("${DateTimeHelpers.dDLmMyyyy(context, widget.event.date)}",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () async {
                List<Map<String, dynamic>> list = await DbHelpers.query(DbSql.tableExercises);
                print(list);
                // _showHelp(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                _showBottomMenu();
              },
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
                    text: FlutterI18n.translate(
                        context, 'CalendarDetail.string7')),
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
    bool delete = await showDeleteDialog(
        context,
        FlutterI18n.translate(context, 'CalendarDetail.string8'),
        "${FlutterI18n.translate(context, 'CalendarDetail.string9')}:\n\n$currentPlanTitle");
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
          context,
          FlutterI18n.translate(context, 'CalendarDetail.string10'),
          "${FlutterI18n.translate(context, 'CalendarDetail.string11')}:\n\n$currentPlanTitle\n\n${FlutterI18n.translate(context, 'CalendarDetail.string12')}\n\n${exercisePlan.title}");
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
    bool update = await showDeleteDialog(
        context,
        FlutterI18n.translate(context, 'CalendarDetail.string13'),
        "${FlutterI18n.translate(context, 'CalendarDetail.string14')}:\n\n$currentPlanTitle");
    if (update != null && update) {
      await widget.event.updateExercises();
      setState(() {});
    }
  }

  void _showBottomMenu() async {
    int result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
          color: ThemeConfig.bottomSheetBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomMenuRow(
                icon: Icons.delete,
                text: FlutterI18n.translate(context, 'CalendarDetail.string4'),
                value: 0,
              ),
              BottomMenuRow(
                icon: Icons.view_list,
                text: FlutterI18n.translate(context, 'CalendarDetail.string5'),
                value: 1,
              ),
              BottomMenuRow(
                icon: Icons.update,
                text: FlutterI18n.translate(context, 'CalendarDetail.string6'),
                value: 2,
              )
            ],
          )),
    );

    if (result != null) {
      SystemHelpers.vibrate25();
      _popupMenuAction(result);
    }
  }

  void _showHelp(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => HelpDialog(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.more_vert, color: ThemeConfig.dialogTextColor),
                    Text(
                        FlutterI18n.translate(
                            context, 'CalendarDetail.string15'),
                        style: TextStyle(
                            color: ThemeConfig.dialogTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.delete,
                              color: ThemeConfig.dialogTextColor, size: 18),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text(
                              FlutterI18n.translate(
                                  context, 'CalendarDetail.string4'),
                              style: TextStyle(
                                  color: ThemeConfig.dialogTextColor,
                                  fontSize: 18))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Text(
                            FlutterI18n.translate(
                                context, 'CalendarDetail.string16'),
                            style: TextStyle(
                                color: ThemeConfig.dialogTextColor,
                                fontSize: 16)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.view_list,
                              color: ThemeConfig.dialogTextColor, size: 18),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text(
                              FlutterI18n.translate(
                                  context, 'CalendarDetail.string5'),
                              style: TextStyle(
                                  color: ThemeConfig.dialogTextColor,
                                  fontSize: 18))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Text(
                            FlutterI18n.translate(
                                context, 'CalendarDetail.string17'),
                            style: TextStyle(
                                color: ThemeConfig.dialogTextColor,
                                fontSize: 16)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.update,
                              color: ThemeConfig.dialogTextColor, size: 18),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text(
                              FlutterI18n.translate(
                                  context, 'CalendarDetail.string6'),
                              style: TextStyle(
                                  color: ThemeConfig.dialogTextColor,
                                  fontSize: 18))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Text(
                            FlutterI18n.translate(
                                context, 'CalendarDetail.string18'),
                            style: TextStyle(
                                color: ThemeConfig.dialogTextColor,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.repeat, color: ThemeConfig.dialogTextColor),
                    Text(
                        FlutterI18n.translate(
                            context, 'CalendarDetail.string19'),
                        style: TextStyle(
                            color: ThemeConfig.dialogTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          FlutterI18n.translate(
                              context, 'CalendarDetail.string20'),
                          style: TextStyle(
                              color: ThemeConfig.dialogTextColor,
                              fontSize: 16)),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Text(
                          FlutterI18n.translate(
                              context, 'CalendarDetail.string21'),
                          style: TextStyle(
                              color: ThemeConfig.dialogTextColor, fontSize: 16))
                    ],
                  ),
                )
              ],
            ));
  }
}
