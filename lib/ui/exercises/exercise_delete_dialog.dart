import 'package:flutter/material.dart';

class ExerciseDeleteDialog extends StatelessWidget {
  final String bodyText;

  const ExerciseDeleteDialog({Key key, @required this.bodyText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(25),
        title: Text("Slet"),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(bodyText),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SimpleDialogOption(
            child: Text("Ja"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          SimpleDialogOption(
            child: Text("Nej"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
            ],
          )
        ],
      );
  }
}