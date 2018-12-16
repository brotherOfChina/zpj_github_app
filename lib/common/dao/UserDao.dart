import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/common/config/IgnoreConfig.dart';
import 'package:zpj_github_app/common/local/LocalStorage.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/net/Api.dart';
import 'package:zpj_github_app/common/net/Address.dart';
import 'package:zpj_github_app/common/net/ResultData.dart';
import 'package:zpj_github_app/common/dao/DaoResult.dart';
import 'package:zpj_github_app/common/utils/CommonUtils.dart';
import 'package:zpj_github_app/common/redux/UserRedux.dart';

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
      if (Config.DEBUG) {
        print("user result;" + resultData.result.toString());
        print(resultData.data);
      }
      store.dispatch();
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
  static getFollowListDao(){

  }
  


























}
