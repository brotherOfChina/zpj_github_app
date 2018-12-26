import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/common/config/IgnoreConfig.dart';
import 'package:zpj_github_app/common/local/LocalStorage.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/model/UserOrg.dart';
import 'package:zpj_github_app/common/net/Api.dart';
import 'package:zpj_github_app/common/net/Address.dart';
import 'package:zpj_github_app/common/net/ResultData.dart';
import 'package:zpj_github_app/common/dao/DaoResult.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:zpj_github_app/common/redux/UserRedux.dart';
import 'package:zpj_github_app/common/db/user/user_follower.dart';
import 'package:zpj_github_app/common/db/user/user_followed.dart';
import 'package:zpj_github_app/common/model/Notification.dart';
import 'package:zpj_github_app/common/db/user/user_orgs.dart';

/**
 *   created by zpj
 *   updateTime:
 *   createdTime: 2018/12/16 18:11
    用户数据
 */
class UserDao {
  ///登录
  static login(userName, password, store) async {
    String type = userName + ":" + password;
    var bytes = utf8.encode(type);
    var base64String = base64.encode(bytes);
    if (Config.DEBUG) {
      print("base64 str:" + base64String);
    }
    await LocalStorage.save(Config.USER_NAME_KEY, userName);
    await LocalStorage.save(Config.USER_BASIC_CODE, base64String);
    Map requestParams = {
      "": [],
      "note": "admin_script",
      "client_id": NetConfig.CLIENT_ID,
      "client_secret": NetConfig.CLIENT_SECRET,
    };
    HttpManager.clearAuthorization();
    var res = await HttpManager.netFetch(Address.getAuthorization(),
        json.encode(requestParams), null, new Options(method: "post"));
    var resultData = null;
    if (res != null && res.result) {
      await LocalStorage.save(Config.PW_KEY, password);
      var resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result;" + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      store.dispatch(new UpdateUserAction(resultData.data));
    }
    return new DaoResult(resultData, res.result);
  }

  ///获取用户信息
  static getUserInfo(userName, {needDb = false}) async {}

  ///获取本地用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return new DaoResult(user, true);
    } else {
      return new DaoResult(null, false);
    }
  }

  ///初始化用户信息
  static initUserInfo(Store store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.reslut && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }

    ///读取主题
    String themeIndex = await LocalStorage.get(Config.THEME_COLOR);
    if (themeIndex != null && themeIndex.length != 0) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }

    ///切换语言
    String localeIndex = await LocalStorage.get(Config.LOCALE);
    if (localeIndex != null && localeIndex.length != 0) {
      CommonUtils.changeLocale(store, int.parse(localeIndex));
    }
    return new DaoResult(res.data, (res.result && (token != null)));
  }

  ///清楚全部
  static clearAll(Store store) async {
    HttpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(new UpdateUserAction(User.empty()));
  }

  ///在header中提取stared count;
  static getUserStaredCountNet(userName) async {
    String url = Address.userStar(userName, null) + "&per_page=1";
    var res = await HttpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> link = res.headers['link'];
        if (link != null) {
          int indexStart = link[0].lastIndexOf("page=") + 5;
          int indexEnd = link[0].lastIndexOf(">");
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = link[0].substring(indexStart, indexEnd);
            return new DaoResult(count, true);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return new DaoResult(null, false);
  }

  ///获取用户粉丝列表
  static getFollowerListDao(userName, page, {needDb = false}) async {
    UserFollower userProvider = new UserFollower();
    next() async {
      String url =
          Address.getUserFollower(userName) + Address.getPageParams("?", page);
      var res = await HttpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DaoResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        if (needDb) {
          userProvider.insert(userName, json.encode(data));
        }
        return new DaoResult(list, true);
      } else {
        return new DaoResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await userProvider.getData(userName);
      if (list != null) {
        return await next();
      }
      DaoResult daoResult = new DaoResult(list, true, next: next());
      return daoResult;
    }
    return await next();
  }

  ///获取用户关注列表
  static getFollowedListDao(userName, page, {needDb = false}) async {
    UserFollowedDbProvider provider = new UserFollowedDbProvider();
    next() async {
      String url =
          Address.getUserFollow(userName) + Address.getPageParams("?", page);
      var res = await HttpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return DaoResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DaoResult(list, true);
      } else {
        return new DaoResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      DaoResult daoResult = new DaoResult(list, true, next: next());
      return daoResult;
    }
    return await next();
  }

  ///获取用户相关通知
  static getNotifyDao(bool all, bool participating, page) async {
    String tag = (!all && !participating) ? "?" : "&";
    String url = Address.getNotifation(all, participating) +
        Address.getPageParams(tag, page);
    var res = await HttpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Notification> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DaoResult([], false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Notification.fromJson(data[i]));
      }
      return new DaoResult(list, true);
    } else {
      return new DaoResult(null, false);
    }
  }

  ///设置单个通知已读
  static setNotificationReadDao(id) async {
    String url = Address.setNotificationAsRead(id);
    var res = await HttpManager.netFetch(url, null, null,
        new Options(method: "PUT", contentType: ContentType.text));
    return new DaoResult(res.data, res.result);
  }

  ///设置所有通知已读
  static setAllNotificationReadDao() async {
    String url = Address.setAllNotificationAsRead();
    var res = await HttpManager.netFetch(url, null, null,
        new Options(method: "PUT", contentType: ContentType.text),
        noTip: true);
    return new DaoResult(res.data, res.result);
  }

  ///检查用户关注状态
  static checkFollowDao(name) async {
    String url = Address.doFollow(name);
    var res = HttpManager.netFetch(
        url, null, null, new Options(contentType: ContentType.text),
        noTip: true);
    return new DaoResult(res.data, res.result);
  }

  ///关注用户
  static doFollowDao(name, bool followed) async {
    String url = Address.doFollow(name);
    var res = HttpManager.netFetch(
        url, null, null, new Options(method: !followed ? "put" : "delete"),
        noTip: true);
    return new DaoResult(res.data, res.result);
  }

  ///组织成员
  static getMemberDao(userName, page) async {
    String url = Address.getMember(userName) + Address.getPageParams("?", page);
    var res = await HttpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<User> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DaoResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(User.fromJson(data[i]));
      }
      return new DaoResult(list, true);
    } else {
      return new DaoResult(null, false);
    }
  }

  ///更新用户信息
  static updateUserInfo(params, Store store) async {
    String url = Address.getMyUserInfo();
    var res = await HttpManager.netFetch(
        url, params, null, new Options(method: "PATCH"));
    if (res != null && res.result) {
      var localResult = await getUserInfoLocal();
      User newUser = User.fromJson(res.data);
      newUser.starred = localResult.data.starred;
      await LocalStorage.save(Config.USER_INFO, json.encode(newUser.toJson()));
      store.dispatch(new UpdateUserAction(newUser));
      return new DaoResult(newUser, null);
    } else {
      return new DaoResult(null, false);
    }
  }

  ///获取用户通知
  static getUserOrgsDao(userName, page, {needDb = false}) async {
    UserOrgDbProvider provider = new UserOrgDbProvider();
    next() async {
      String url =
          Address.getUserOrgs(userName) + Address.getPageParams("?", page);
      var res = HttpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<UserOrg> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DaoResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(UserOrg.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DaoResult(list, true);
      } else {
        return new DaoResult(null, false);
      }
    }

    if (needDb) {
      List<UserOrg> list = await provider.getData(userName);
      if (list == null) {
        return await next();
      }
      DaoResult daoResult = new DaoResult(list, true, next: next());
      return daoResult;
    }
    return await next();
  }
}
