import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/Repository.dart';

/**
 * author：Administrator
 * create_date:2018/12/31 0031-10:07
 * note:仓库分支表
 */
class RepositoryForkDbProvider extends BaseDbProvider {
  final String name = "RepositoryFork";
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";
  int id;
  String fullName;
  String data;

  RepositoryForkDbProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnData: columnData
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryForkDbProvider.from(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
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
      $columnFullName text not null,
      $columnData text not null)
    ''';
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData],
        where: "$columnFullName = ?",
        whereArgs: [fullName]);
    if (maps.length > 0) {
      RepositoryForkDbProvider provider =
          RepositoryForkDbProvider.from(maps.first);
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

  Future<List<Repository>> getData(String fullName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<Repository> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Repository.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
