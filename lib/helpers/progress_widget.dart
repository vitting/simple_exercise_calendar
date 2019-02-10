import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  final Stream<bool> showStream;
  final Widget child;
  final Color color;

  const ProgressWidget({Key key, this.showStream, this.child, this.color = Colors.blue}) : super(key: key);
  @override
  ProgressWidgetState createState() {
    return new ProgressWidgetState();
  }
}

class ProgressWidgetState extends State<ProgressWidget> {
  bool _show = false;
  @override
  void initState() {
    super.initState();
    if (widget.showStream != null) {
      widget.showStream.listen((bool data) {
        if (mounted) {
          setState(() {
            _show = data;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [widget.child];
    if (_show) {
      widgets.addAll([_showBarrier(), _showProgressBox()]);
    }

    return Stack(
      children: widgets,
    );
  }

  Widget _showProgressBox() {
    return Positioned(
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(widget.color),
                  ),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 8, color: widget.color)),
        ),
      ),
    );
  }

  Widget _showBarrier() {
    return Positioned(
      child: ModalBarrier(
        dismissible: false,
        color: Colors.black26,
      ),
    );
  }
}
