import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class ExerciseSub extends StatelessWidget {
  final ExerciseData item;
  final bool editMode;
  final int repetitionsDone;
  final ValueChanged<bool> onTapSeconds;
  final ValueChanged<bool> onTapWeight;
  final ValueChanged<bool> onTapRepetitions;

  const ExerciseSub(
      {Key key,
      this.item,
      this.editMode = false,
      this.onTapRepetitions,
      this.repetitionsDone = 0,
      this.onTapSeconds,
      this.onTapWeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        item.description.isNotEmpty
            ? Text(item.description,
                style: TextStyle(
                    color: item.closed
                        ? ThemeConfig.rowTextColor2
                        : ThemeConfig.rowTextColor))
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(360),
              onTap: editMode
                  ? () {
                      if (onTapSeconds != null) {
                        onTapSeconds(true);
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.timer,
                          color: item.closed
                              ? ThemeConfig.rowTextColor2
                              : ThemeConfig.rowSubTextColor,
                          size: 20),
                    ),
                    Text(
                        "${item.seconds.toString()} ${FlutterI18n.translate(context, 'ExerciseSub.string1')}",
                        style: TextStyle(
                            color: item.closed
                                ? ThemeConfig.rowTextColor2
                                : ThemeConfig.rowTextColor))
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(360),
              onTap: editMode
                  ? () {
                      if (onTapWeight != null) {
                        onTapWeight(true);
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(MdiIcons.weight,
                          color: item.closed
                              ? ThemeConfig.rowTextColor2
                              : ThemeConfig.rowSubTextColor,
                          size: 20),
                    ),
                    Text(
                        "${item.weight.toString()} ${FlutterI18n.translate(context, 'ExerciseSub.string2')}",
                        style: TextStyle(
                            color: item.closed
                                ? ThemeConfig.rowTextColor2
                                : ThemeConfig.rowTextColor))
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(360),
              onTap: item.closed
                  ? null
                  : () {
                      if (onTapRepetitions != null) {
                        onTapRepetitions(true);
                      }
                    },
              onLongPress: item.closed
                  ? null
                  : () {
                      if (onTapRepetitions != null) {
                        onTapRepetitions(false);
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(MdiIcons.repeat,
                          color: item.closed
                              ? ThemeConfig.rowTextColor2
                              : ThemeConfig.rowSubTextColor,
                          size: 20),
                    ),
                    editMode
                        ? Text("${item.repetitions.toString()}",
                            style: TextStyle(
                                color: item.closed
                                    ? ThemeConfig.rowTextColor2
                                    : ThemeConfig.rowTextColor))
                        : Text(
                            "${repetitionsDone.toString()}/${item.repetitions.toString()}",
                            style: TextStyle(
                                color: item.closed
                                    ? ThemeConfig.rowTextColor2
                                    : ThemeConfig.rowTextColor))
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
