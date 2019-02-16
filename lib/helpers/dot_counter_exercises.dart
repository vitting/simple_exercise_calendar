import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class DotCounterExercises extends StatelessWidget {
  final ExercisePlanData plan;

  const DotCounterExercises({Key key, @required this.plan}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: FlutterI18n.translate(context, 'DotCounterExercises.string1'),
      child: Stack(
        children: <Widget>[
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: Colors.cyan[800], shape: BoxShape.circle),
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Icon(
                    MdiIcons.dumbbell,
                    color: Colors.cyan[600],
                  )),
                  FutureBuilder(
                    future: plan.getExercisesCount(),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Text("0",
                                style: TextStyle(
                                    color: ThemeConfig.textColor,
                                    fontSize: 12)));
                      }

                      return Center(
                          child: Text(snapshot.data.toString(),
                              style: TextStyle(
                                  color: ThemeConfig.textColor, fontSize: 12)));
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
