import 'package:flutter/material.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/common/style/ZPJStyle.dart';
import 'package:zpj_github_app/widget/tab_bar_widget.dart';
import 'package:zpj_github_app/widget/home_drawer.dart';
import 'package:zpj_github_app/widget/title_bar.dart';
import 'package:zpj_github_app/common/localization/DefaultLocalizations.dart';
/**
 *   author：Administrator
 *   create_date:2018/12/28 0028-9:05
 *   note:主页
 */
class HomePage extends StatelessWidget {
  static final String sName = "home";

  ///单机提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text(CommonUtils.getLocale(context).app_back_tip),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(CommonUtils.getLocale(context).app_cancel)),
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text(CommonUtils.getLocale(context).app_ok)),
              ],
            ));
  }

  _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            icon,
            size: 16.0,
          ),
          new Text(text)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(ZpjICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic),
      _renderTab(ZpjICons.MAIN_QS, CommonUtils.getLocale(context).home_trend),
      _renderTab(ZpjICons.MAIN_MY, CommonUtils.getLocale(context).home_my)
    ];
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new TabBarWidget(
        type: TabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: <Widget>[

        ],
        drawer: HomeDrawer(),
        backgroundColor: ZPJColors.primarySwatch,
        indicatorColor: Color(ZPJColors.white),
        title: TitleBar(
          title: ZpjLocalizations.of(context).currentLocalized.app_name,
          iconData: ZpjICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onPressed: () {
            print("搜索");
          },
        ),
      ),
    );
  }
}
