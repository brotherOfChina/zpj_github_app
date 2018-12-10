import 'package:flutter/material.dart';

class InputIconWidget extends StatefulWidget {
  final bool obscureText;
  final String hintText;
  final IconData iconData;
  final ValueChanged<String> onChanged;
  final TextStyle textStyle;
  final TextEditingController controller;

  InputIconWidget(
      {Key key,
      this.obscureText,
      this.hintText,
      this.iconData,
      this.onChanged,
      this.textStyle,
      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _InputIconWidgetState();
  }
}
class _InputIconWidgetState extends State<InputIconWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      decoration: new InputDecoration(
          hintText: widget.hintText,
          icon: widget.iconData == null ? null : new Icon(widget.iconData)),
    );
  }
}
