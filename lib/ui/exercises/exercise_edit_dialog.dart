import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseEditDialog extends StatefulWidget {
  final String title;
  final String lable;
  final String value;

  const ExerciseEditDialog({Key key, this.title, this.lable, this.value = ""}) : super(key: key);
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
      titlePadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: widget.value,
                maxLines: 3,
                inputFormatters: [LengthLimitingTextInputFormatter(250)],
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
