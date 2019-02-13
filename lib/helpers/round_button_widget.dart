import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool disabled;
  final Color backgroundColor;
  final Color textColor;

  const RoundButton({Key key, @required this.text, this.onPressed, this.disabled = false, this.backgroundColor, this.textColor = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Container(
          child: Text(text,
        style: TextStyle(color: textColor, fontSize: 18),
      )),
      onPressed: disabled ? null : onPressed,
      splashColor: Colors.blue[400],
      disabledColor: Colors.grey,
      padding: EdgeInsets.all(20),
      color: backgroundColor ?? Colors.blue[700],
      shape: CircleBorder(side: BorderSide(style: BorderStyle.none)),
    );
  }
}
