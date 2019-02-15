import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/exercises/dot_counter_exercises.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class ExercisePlansMain extends StatefulWidget {
  @override
  ExercisePlansMainState createState() {
    return new ExercisePlansMainState();
  }
}

class ExercisePlansMainState extends State<ExercisePlansMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.view_list),
            )
          ],
          title:
              Text(FlutterI18n.translate(context, 'ExercisePlansMain.string1')),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeConfig.floatingActionButtonBackgroundColor,
          tooltip: FlutterI18n.translate(context, 'ExercisePlansMain.string2'),
          child: Stack(
            children: <Widget>[
              Center(
                  child:
                      Icon(Icons.add, size: 40, color: ThemeConfig.textColor)),
              Center(
                  child:
                      Icon(Icons.view_list, size: 40, color: Colors.white54)),
            ],
          ),
          onPressed: () {
            SystemHelpers.vibrate25();
            addNewPlan(context);
          },
        ),
        body: FutureBuilder(
          future: ExercisePlanData.getExercisePlans(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ExercisePlanData>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            if (snapshot.hasData && snapshot.data.length == 0) {
              return Center(
                child: NoData(
                    backgroundIcon: Icons.view_list,
                    text: FlutterI18n.translate(
                        context, 'ExercisePlansMain.string3'),
                    text2: FlutterI18n.translate(
                        context, 'ExercisePlansMain.string4')),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                ExercisePlanData plan = snapshot.data[position];
                return Card(
                  color: ThemeConfig.rowBackgroundColor,
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(plan.title,
                                style: TextStyle(
                                    color: ThemeConfig.rowTextColor))),
                        Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: DotCounterExercises(plan: plan))
                      ],
                    ),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ExercisesDetail(
                                plan: plan,
                                create: true,
                              )));
                    },
                    onLongPress: () {
                      SystemHelpers.vibrate25();
                      _editPlanTitle(plan);
                    },
                    trailing: IconButton(
                        color: ThemeConfig.rowTextColor,
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        onPressed: () async {
                          SystemHelpers.vibrate25();
                          _showBottomMenu(plan);
                        }),
                  ),
                );
              },
            );
          },
        ));
  }

  void _showBottomMenu(ExercisePlanData plan) async {
    int result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
          color: ThemeConfig.bottomSheetBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.content_copy,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text(
                        FlutterI18n.translate(
                            context, 'ExercisePlansMain.string5'),
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(sheetContext).pop(0);
                    }),
              ),
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.edit,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text(
                        FlutterI18n.translate(
                            context, 'ExercisePlansMain.string6'),
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(sheetContext).pop(1);
                    }),
              ),
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.delete,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text(
                        FlutterI18n.translate(
                            context, 'ExercisePlansMain.string7'),
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      SystemHelpers.vibrate25();
                      Navigator.of(sheetContext).pop(2);
                    }),
              )
            ],
          )),
    );

    if (result != null) {
      if (result == 0) {
        String title = await showEditDialog(
            context,
            FlutterI18n.translate(context, 'ExercisePlansMain.string8'),
            FlutterI18n.translate(context, 'ExercisePlansMain.string9'),
            plan.title);
        if (title != null && title.isNotEmpty) {
          await plan.saveCopyWithExercises(title);
        }
      } else if (result == 1) {
        _editPlanTitle(plan);
      } else if (result == 2) {
        bool delete = await showDeleteDialog(
            context,
            FlutterI18n.translate(context, 'ExercisePlansMain.string10'),
            FlutterI18n.translate(context, 'ExercisePlansMain.string11'));
        if (delete != null && delete) {
          await plan.delete();
        }
      }

      setState(() {});
    }
  }

  void _editPlanTitle(ExercisePlanData plan) async {
    String title = await showEditDialog(
        context,
        FlutterI18n.translate(context, 'ExercisePlansMain.string12'),
        FlutterI18n.translate(context, 'ExercisePlansMain.string13'),
        plan.title);
    if (title != null && title.isNotEmpty) {
      setState(() {
        plan.updateTitle(title);
      });
    }
  }
}
