import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:zpj_github_app/common/db/event/user_event.dart';
import 'package:zpj_github_app/common/model/Event.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/net/Address.dart';
import 'package:zpj_github_app/common/net/Api.dart';
import 'package:zpj_github_app/common/redux/ZpjRedux.dart';
import 'package:zpj_github_app/common/db/event/received_event.dart';
import 'package:zpj_github_app/common/redux/event_redux.dart';
import 'package:zpj_github_app/common/dao/DaoResult.dart';

class EventDao {
  static getEventReceived(Store<ZpjState> store,
      {page = 1, bool needDb = false}) async {
    User user = store.state.userInfo;
    if (user == null || user.login == null) {
      return null;
    }
    ReceiveEventDbProvider provider = new ReceiveEventDbProvider();
    if (needDb) {
      List<Event> dbList = await provider.getEvents();
      if (dbList.length > 0) {
        store.dispatch(new RefreshEventAction(dbList));
      }
    }
    String userName = user.login;
    String url =
        Address.getEventReceived(userName) + Address.getPageParams("?", page);
    var res = await HttpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Event> list = new List();
      var data = res.data;
      if (data != null || data.length == 0) {
        return null;
      }
      if (needDb) {
        await provider.insert(json.decode(data));
      }
      for (int i = 0; i < data.lenth; i++) {
        list.add(Event.fromJson(data[i]));
      }
      if (page == 1) {
        store.dispatch(new RefreshEventAction(list));
      } else {
        store.dispatch(new LoadMoreEventAction(list));
      }
      return list;
    } else {
      return null;
    }
  }

  ///用户行为事件
  static getEventDao(userName, {page = 0, bool needDb = false}) async {
    UserEventDbProvider provider = new UserEventDbProvider();
    next() async {
      String url =
          Address.getEvent(userName) + Address.getPageParams("?", page);
      var res = await HttpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Event> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DaoResult(list, true);
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Event.fromJson(data[i]));
        }
        return new DaoResult(list, true);
      } else {
        return null;
      }
    }

    if (needDb) {
      List<Event> dbList = await provider.getEvents(userName);
      if (dbList == null || dbList.length == 0) {
        return await next();
      }
      DaoResult daoResult = new DaoResult(dbList, true, next: next());
      return daoResult;
    }
    return await next();
  }

  static clearEvent(Store store) {
    store.state.eventList.clear();
    store.dispatch(new RefreshEventAction([]));
  }
}
