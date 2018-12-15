import 'UserRedux.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/model/Event.dart';
import 'package:zpj_github_app/common/model/TrendingRepoModel.dart';
import 'package:flutter/material.dart';
import 'package:zpj_github_app/common/redux/event_redux.dart';
import 'package:zpj_github_app/common/redux/TrendRedux.dart';
import 'package:zpj_github_app/common/redux/ThemeRedux.dart';
import 'package:zpj_github_app/common/redux/LocaleRedux.dart';
class ZpjState {
  ///用户信息
  User userInfo;

  ///用户接受到的时间列表
  List<Event> eventList = new List();

  ///用户接收到的事件列表
  List<TrendingRepoModel> trendList = new List();

  ///主题数据
  ThemeData themeData;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;

  ZpjState(
      {this.userInfo,
      this.eventList,
      this.trendList,
      this.themeData,
      this.locale});
}

ZpjState appReducer(ZpjState state, action) {
  return ZpjState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: userReducer(state.userInfo, action),

    ///通过 EventReducer 将 GSYState 内的 eventList 和 action 关联在一起
    eventList: EventReducer(state.eventList, action),

    ///通过 TrendReducer 将 GSYState 内的 trendList 和 action 关联在一起
    trendList: TrendReducer(state.trendList, action),

    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),

    ///通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
  );
}
