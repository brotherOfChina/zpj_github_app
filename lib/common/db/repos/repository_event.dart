import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/Event.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/31 0031-9:39
 *   note:仓库活跃时间表
 */
class RepositoryEventDbProvider extends BaseDbProvider {
  final String name = "RepositoryEvent";
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  RepositoryEventDbProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryEventDbProvider.fromMap(Map map) {
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
      RepositoryEventDbProvider provider =
          RepositoryEventDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String data) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db
          .delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, data));
  }

  ///获取事件数据
  Future<List<Event>> getEvents(String fullName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<Event> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Event.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
