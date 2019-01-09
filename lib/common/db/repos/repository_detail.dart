import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/Repository.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/30 0030-10:07
 *   note:仓库详情数据库
 */
class RepositoryDetailDbProvider extends BaseDbProvider {
  final String name = "RepositoryDetail";
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  RepositoryDetailDbProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnData: data, columnFullName: fullName};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryDetailDbProvider.fromJson(Map map) {
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
      $columnData text not null,
      $columnFullName text not null)
    ''';
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db
        .query(name,
        columns: [columnId,columnFullName,columnData],
        where: "$columnFullName = ?", whereArgs: [fullName]);
    if (maps.length > 0) {
      RepositoryDetailDbProvider provider =
          RepositoryDetailDbProvider.fromJson(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String data) async {
    Database database = await getDataBase();
    RepositoryDetailDbProvider provider =
        await _getProvider(database, fullName);
    if (provider != null) {
      await database
          .delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await database.insert(name, toMap(fullName, data));
  }

  ///获取详情
  Future<Repository> getRepository(String fullName) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      return Repository.fromJson(json.decode(provider.data));
    }
    return null;
  }
}
