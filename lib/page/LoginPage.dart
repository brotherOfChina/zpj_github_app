import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:zpj_github_app/widget/InputIconWidget.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:zpj_github_app/common/dao/UserDao.dart';
import 'package:zpj_github_app/common/utils/NavigatorUtils.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static final sName = "login";

  @override
  State<StatefulWidget> createState() {

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

    super.setState(fn);
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new StoreBuilder<ZpjState>(
      builder: (context, store) {
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
                            CommonUtils.showLoadingDialog(context);
                            UserDao.login(_userName, _password, store)
                                .then((res) {
                              Navigator.pop(context);

                              if (res != null && res.result) {

                                new Future.delayed(const Duration(seconds: 1),
                                        () {
                                      NavigatorUtils.goHome(context);
                                      return true;
                                    });
                              }
                            });
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
