import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/User.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/31 0031-11:47
 *   note:仓库收藏用户表
 */
class RepositoryStarDbProvider extends BaseDbProvider {
  final String name = "RepositoryStar";

  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  RepositoryStarDbProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryStarDbProvider.formMap(Map map) {
    id = map[columnId];
    data = map[columnData];
    fullName = map[columnFullName];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnFullName text not null,
      $columnData text not null)
    ''';
  }

  Future _getProvider(Database db, String data) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData],
        where: "$columnFullName = ?",
        whereArgs: [fullName]);
    if (maps.length > 0) {
      RepositoryStarDbProvider provider =
          RepositoryStarDbProvider.formMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(String fullName, String data) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db
          .delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, data));
  }

  Future<List<User>> getData(String fullName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<User> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(User.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
