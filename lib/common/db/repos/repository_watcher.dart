import 'dart:convert';
import 'dart:async';

import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/User.dart';
import 'package:sqflite/sqflite.dart';

/**
 *   author：Administrator
 *   create_date:2019/1/9 0009-11:44
 *   note:仓库订阅用户表
 */

class RepositoryWatcherDbProvider extends BaseDbProvider {
  static final String name = 'Repository';
  static final columnId = '_id';
  static final columnFullName = 'fullName';
  final String columnData = 'data';

  int id;
  String fullName;
  String data;
  RepositoryWatcherDbProvider();
  @override
  tableName() {
    return name;
  }

  Map<String, dynamic> toMap(String name, String data) {
    Map<String, dynamic> map = {fullName: name, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryWatcherDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnFullName text not null,
      $columnData text not null)
    ''';
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData],
        where: '$columnFullName = ?',
        whereArgs: [fullName]);
    if (maps.length > 0) {
      RepositoryWatcherDbProvider provider =
          RepositoryWatcherDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db
          .delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, data));
  }

  ///获取事件数据
  Future<User> getUserInfo(String userName) async {
    Database db = await getDataBase();
    var userProvider = await _getProvider(db, userName);
    if (userProvider != null) {
      return User.fromJson(json.decode(userProvider.data));
    }
    return null;
  }
}
