import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/no_data_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class ExercisesMain extends StatefulWidget {
  @override
  ExercisesMainState createState() {
    return new ExercisesMainState();
  }
}

class ExercisesMainState extends State<ExercisesMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planer"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeConfig.floatingActionButtonBackgroundColor,
          tooltip: "Tilføj ny plan",
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
                  text: "Ingen planer fundet",
                  text2: "Opret en ny plan",
                  buttonIcon: Icons.add_circle_outline,
                  onIconTap: (_) {
                    addNewPlan(context);
                  },
                ),
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
                          child: Tooltip(
                            message: "Antal øvelser",
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: Colors.cyan[800],
                                      shape: BoxShape.circle),
                                  child: FutureBuilder(
                                    future: plan.getExercisesCount(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: Text("0",
                                                style: TextStyle(
                                                    color:
                                                        ThemeConfig.textColor,
                                                    fontSize: 12)));
                                      }

                                      return Center(
                                          child: Text(snapshot.data.toString(),
                                              style: TextStyle(
                                                  color: ThemeConfig.textColor,
                                                  fontSize: 12)));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ExercisesDetail(
                                plan: plan,
                                create: true,
                              )));
                    },
                    onLongPress: () {
                      _editPlanTitle(plan);
                    },
                    trailing: IconButton(
                        color: ThemeConfig.rowTextColor,
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        onPressed: () async {
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
                    title: Text("Kopier",
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      Navigator.of(sheetContext).pop(0);
                    }),
              ),
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.edit,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text("Redigere",
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      Navigator.of(sheetContext).pop(1);
                    }),
              ),
              Card(
                color: ThemeConfig.bottomSheetRowColor,
                child: ListTile(
                    leading: Icon(Icons.delete,
                        color: ThemeConfig.bottomSheetTextColor),
                    title: Text("Slet",
                        style:
                            TextStyle(color: ThemeConfig.bottomSheetTextColor)),
                    onTap: () {
                      Navigator.of(sheetContext).pop(2);
                    }),
              )
            ],
          )),
    );

    if (result != null) {
      if (result == 0) {
        String title = await showEditDialog(
            context, "Kopier plan", "Plan name", plan.title);
        if (title != null && title.isNotEmpty) {
          await plan.saveCopyWithExercises(title);
        }
      } else if (result == 1) {
        _editPlanTitle(plan);
      } else if (result == 2) {
        bool delete = await showDeleteDialog(context, "Delete Plan?");
        if (delete != null && delete) {
          await plan.delete();
        }
      }

      setState(() {});
    }
  }

  void _editPlanTitle(ExercisePlanData plan) async {
    String title =
        await showEditDialog(context, "Edit Plan", "Plan name", plan.title);
    if (title != null && title.isNotEmpty) {
      setState(() {
        plan.updateTitle(title);
      });
    }
  }
}
