import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String text;
  final String text2;
  final IconData backgroundIcon;
  final IconData buttonIcon;
  final double buttonIconSize;
  final ValueChanged<bool> onIconTap;

  const NoData(
      {Key key,
      this.text,
      this.backgroundIcon,
      this.text2,
      this.onIconTap,
      this.buttonIcon,
      this.buttonIconSize = 40})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueGrey[600], width: 10)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Center(
                      child: Icon(backgroundIcon,
                          size: 70, color: Colors.blueGrey[700])),
                ),
                text == null
                    ? Container()
                    : Positioned(
                        child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(text,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white70)),
                            text != null && text2 != null && buttonIcon == null
                                ? SizedBox(height: 60)
                                : Container(),
                            buttonIcon == null
                                ? Container()
                                : IconButton(
                                    iconSize: buttonIconSize,
                                    onPressed: () {
                                      if (onIconTap != null) {
                                        onIconTap(true);
                                      }
                                    },
                                    icon: Icon(buttonIcon, color: Colors.white),
                                  ),
                            text2 == null
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(text2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white70))),
                          ],
                        ),
                      )),
              ],
            )),
      ],
    );
  }
}
