import 'package:flutter/material.dart';

class ExerciseEditDialog extends StatefulWidget {
  final String title;
  final String lable;

  const ExerciseEditDialog({Key key, this.title, this.lable}) : super(key: key);
  @override
  ExerciseEditDialogState createState() {
    return new ExerciseEditDialogState();
  }
}

class ExerciseEditDialogState extends State<ExerciseEditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(widget.title), CloseButton()],
      ),
      contentPadding: EdgeInsets.all(5),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: widget.lable),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return "Fill out ${widget.lable}";
                  }
                },
                onSaved: (String value) {
                  Navigator.of(context).pop(value);
                },
              )
            ],
          ),
        ),
        FlatButton.icon(
          icon: Icon(Icons.save),
          label: Text("Gem"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
            }
          },
        )
      ],
    );
  }
}
