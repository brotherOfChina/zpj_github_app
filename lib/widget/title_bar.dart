import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPressed;
  final bool needRightLocalIcon;
  final Widget rightWidget;

  const TitleBar(
      {Key key,
      this.title,
      this.iconData,
      this.onPressed,
      this.needRightLocalIcon,
      this.rightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = rightWidget;
    if (rightWidget == null) {
      widget = (needRightLocalIcon)
          ? new IconButton(
              icon: new Icon(
                iconData,
                size: 19.0,
              ),
              onPressed: onPressed)
          : new Container();
    }
    return Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }
}
