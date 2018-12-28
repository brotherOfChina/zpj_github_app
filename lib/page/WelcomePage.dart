import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:zpj_github_app/common/dao/UserDao.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/page/LoginPage.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:zpj_github_app/common/utils/NavigatorUtils.dart';

class WelcomePage extends StatefulWidget {
  static final sName = '/';

  @override
  State<StatefulWidget> createState() {

    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false; //防止多次进入
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;
    Store<ZpjState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    new Future.delayed(const Duration(seconds: 3), () {
      UserDao.initUserInfo(store).then((res){
        if(res!=null&&res.result){
          NavigatorUtils.goHome(context);
        }else{
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child:new Center(
          child: Image.asset("static/images/yang_mi.jpg"),
        )
        ,
      ),
    );
  }
}
