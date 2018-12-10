import 'UserRedux.dart';
import 'package:zpj_githup_app/model/User.dart';


class ZpjState{
  User userInfo;
  ZpjState({this.userInfo});

}
ZpjState appReducer(ZpjState state, action) {
  return ZpjState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: userReducer(state.userInfo, action),

//    ///通过 EventReducer 将 GSYState 内的 eventList 和 action 关联在一起
//    eventList: EventReducer(state.eventList, action),
//
//    ///通过 TrendReducer 将 GSYState 内的 trendList 和 action 关联在一起
//    trendList: TrendReducer(state.trendList, action),
//
//    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
//    themeData: ThemeDataReducer(state.themeData, action),
//
//    ///通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
//    locale: LocaleReducer(state.locale, action),
  );
}