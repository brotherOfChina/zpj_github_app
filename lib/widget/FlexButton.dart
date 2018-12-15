import 'package:flutter/material.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/14 0014-9:09
 *   note:充满button
 */
class FlexButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPress;
  final double fontSize;
  final int maxLines;
  final MainAxisAlignment mainAxisAlignment;

  FlexButton(
      {Key key,
      this.text,
      this.textColor,
      this.color,
      this.onPress,
      this.fontSize,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: const EdgeInsets.only(
          left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
      textColor: textColor,
      color: color,
      onPressed: () {
        this.onPress?.call();
      },
      child: new Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          new Text(
            text,
            style: new TextStyle(fontSize: fontSize),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
