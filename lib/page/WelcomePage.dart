import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:zpj_githup_app/redux/ZpjRedux.dart';
import 'package:zpj_githup_app/page/LoginPage.dart';

class WelcomePage extends StatefulWidget {
  static final sName = '/';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;//防止多次进入
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(hadInit){
      return;
    }
    hadInit=true;
    Store<ZpjState> store=StoreProvider.of(context);
    new Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context,LoginPage.sName);
    });
  }
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