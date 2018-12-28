import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'package:zpj_github_app/page/LoginPage.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/page/WelcomePage.dart';
import 'package:zpj_github_app/common/style/ZPJStyle.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zpj_github_app/common/localization/ZpjLocalizationsDelegate.dart';
import 'package:zpj_github_app/page/home_page.dart';

void main() => runApp(FlutterReduxApp());

class FlutterReduxApp extends StatelessWidget {
  final store = new Store<ZpjState>(appReducer,
      initialState: new ZpjState(
          userInfo: User.empty(),
          eventList: new List(),
          trendList: new List(),
          themeData: new ThemeData(
            primarySwatch: ZPJColors.primarySwatch,
          ),
          locale: Locale("zh", "CH")));

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<ZpjState>(builder: (context, state) {
        return MaterialApp(
          title: "",
          localizationsDelegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            ZpjLocalizationsDelegate.delegate
          ],
          locale: store.state.locale,
          supportedLocales: [store.state.locale],
          theme: store.state.themeData,
          routes: {
            WelcomePage.sName: (context) {
              return new WelcomePage();
            },
            HomePage.sName: (context) {
              return new ZpjLocalizations(
                child: new HomePage(),
              );
            },
            LoginPage.sName: (context) {
              return new ZpjLocalizations(
                child: new LoginPage(),
              );
            },
          },
        );
      }),
    );
  }
}

class ZpjLocalizations extends StatefulWidget {
  final Widget child;

  ZpjLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ZpjLocalizations();
  }
}

class _ZpjLocalizations extends State<ZpjLocalizations> {
  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StoreBuilder<ZpjState>(builder: (context, store) {
      return new Localizations.override(
        context: context,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
