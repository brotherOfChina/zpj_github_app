import 'dart:async';
import 'dart:convert';

import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
/**
 *   created by zpj
 *   updateTime:
 *   createdTime: 2018/12/16 19:13
    用户信息
 */

class UserInfoDbProvider extends BaseDbProvider {
  final String name = "UserInfo";
  final String columnId = "_id";
  final String columnUserName = "userName";
  final String columnData = "data";

  int id;
  String userName;
  String data;

  UserInfoDbProvider();

  Map<String, dynamic> toMap(String userName, String data) {
    Map<String, dynamic> map = {columnUserName: userName, columnData: data};
    if (id != null) {
      {
        map[columnId] = id;
      }
    }
    return map;
  }

  UserInfoDbProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnUserName text not null,
      $columnData text not null)
    ''';
  }

  Future _getUserProvider(Database db, String userName) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnUserName, columnData],
        where: "$columnUserName=?",
        whereArgs: [userName]);
    if (maps.length > 0) {
      UserInfoDbProvider provider = UserInfoDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String userName, String eventMapString) async {
    Database db = await getDataBase();
    var userProvider = _getUserProvider(db, userName);
    if (userProvider != null) {
      await db.delete(name, where: "$columnUserName=?", whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, eventMapString));
  }

  Future<User> getUserInfo(String userName) async {
    Database db = await getDataBase();
    var userProvider = await _getUserProvider(db, userName);
    if (userProvider != null) {
      return User.fromJson(json.decode(userProvider.data));
    }
    return null;
  }
}
