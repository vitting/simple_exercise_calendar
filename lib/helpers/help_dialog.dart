import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:simple_exercise_calendar/helpers/close_button_widget.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';

class HelpDialog extends StatelessWidget {
  final List<Widget> children;

  const HelpDialog({Key key, this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: ThemeConfig.dialogBackgroundColor,
      titlePadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(FlutterI18n.translate(context, 'HelpDialog.string1'), style: TextStyle(color:ThemeConfig.dialogTextColor)),
          CloseButtonWidget()
          ],
      ),
      children: children
    );
  }
}
