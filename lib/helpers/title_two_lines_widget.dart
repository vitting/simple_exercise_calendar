import 'package:flutter/material.dart';

class TitleTwoLines extends StatelessWidget {
  final String line1;
  final String line2;

  const TitleTwoLines({Key key, this.line1, this.line2}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(line1, style: TextStyle(fontSize: 16)),
        Text(line2, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
