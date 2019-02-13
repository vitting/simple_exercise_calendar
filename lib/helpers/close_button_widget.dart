import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  final Color color;

  const CloseButtonWidget({Key key, this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close, color: color),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
