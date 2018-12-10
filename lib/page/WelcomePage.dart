import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  static final sName = '/';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
        width: 375,
        height: 640,
        child: new Image(
          image: new AssetImage("static/images/yang_mi.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
