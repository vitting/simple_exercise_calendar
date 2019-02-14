import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class ExerciseSub extends StatelessWidget {
  final ExerciseData item;
  final bool editMode;
  final ValueChanged<bool> onTapSeconds;
  final ValueChanged<bool> onTapWeight;
  final ValueChanged<bool> onTapRepetitions;

  const ExerciseSub({Key key, this.item, this.editMode = false, this.onTapRepetitions, this.onTapSeconds, this.onTapWeight})
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
        item.description.isNotEmpty ? SizedBox(height: 5) : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: editMode ? () {
                if (onTapSeconds != null) {
                  onTapSeconds(true);
                }
              } : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.timer,
                          color: item.closed
                              ? ThemeConfig.rowTextColor2
                              : ThemeConfig.rowTextColor,
                          size: 20),
                    ),
                    Text("${item.seconds.toString()} sek",
                        style: TextStyle(
                            color: item.closed
                                ? ThemeConfig.rowTextColor2
                                : ThemeConfig.rowTextColor))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: editMode ? () {
                if (onTapWeight != null) {
                  onTapWeight(true);
                }
              } : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(MdiIcons.weight,
                          color: item.closed
                              ? ThemeConfig.rowTextColor2
                              : ThemeConfig.rowTextColor,
                          size: 20),
                    ),
                    Text("${item.weight.toString()} kg",
                        style: TextStyle(
                            color: item.closed
                                ? ThemeConfig.rowTextColor2
                                : ThemeConfig.rowTextColor))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (onTapRepetitions != null) {
                  onTapRepetitions(true);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(MdiIcons.repeat,
                          color: item.closed
                              ? ThemeConfig.rowTextColor2
                              : ThemeConfig.rowTextColor,
                          size: 20),
                    ),
                    editMode
                        ? Text("${item.repetitions.toString()}",
                            style: TextStyle(
                                color: item.closed
                                    ? ThemeConfig.rowTextColor2
                                    : ThemeConfig.rowTextColor))
                        : Text("0/${item.repetitions.toString()}",
                            style: TextStyle(
                                color: item.closed
                                    ? ThemeConfig.rowTextColor2
                                    : ThemeConfig.rowTextColor))
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
