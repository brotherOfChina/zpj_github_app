import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:zpj_githup_app/widget/InputIconWidget.dart';
import 'package:zpj_githup_app/common/redux/ZpjRedux.dart';
class LoginPage extends StatefulWidget {
  static final sName = "login";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();
  var _userName = "";
  var _password = "";

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StoreBuilder<ZpjState>(
      builder: (context, count) {
        return new GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            body: new Container(
              color: Theme.of(context).primaryColor,
              child: new Center(
                child: new Card(
                  elevation: 5.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Colors.white70,
                  margin: const EdgeInsets.all(10.0),
                  child: new Padding(
                    padding: new EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 40.0, bottom: 30.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Image(image: new AssetImage('')),
                        new Padding(padding: const EdgeInsets.all(10.0)),
                        new InputIconWidget(
                          hintText: "输入github账户",
                          obscureText: false,
                          iconData: Icons.account_box,
                          onChanged: (String value) {
                            _userName = value;
                          },
                          controller: userController,
                        ),
                        new Padding(padding: const EdgeInsets.all(30.0)),
                        new InputIconWidget(
                          hintText: '输入github密码',
                          iconData: Icons.grid_on,
                          obscureText: true,
                          onChanged: (String value) {
                            _password = value;
                          },
                          controller: pwController,
                        ),
                        new Padding(padding: new EdgeInsets.all(30.0)),
                        new RaisedButton(
                          onPressed: () {
                            if (_userName == null || _userName.length == 0) {
                              return;
                            }
                            if (_password == null || _password.length == 0) {
                              return;
                            }
                            print(_userName + _password);
                          },
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white70,
                          child: Text(
                            "登录",
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
