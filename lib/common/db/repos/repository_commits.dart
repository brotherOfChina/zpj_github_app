import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/RepoCommit.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/29 0029-17:42
 *   note:提交列表
 */
class RepositoryCommitsDbProvider extends BaseDbProvider {
  final String name = 'RepositoryCommits';
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnBranch = "branch";
  final String columnData = "data";

  int id;
  String fullName;
  String data;
  String branch;

  RepositoryCommitsDbProvider();

  Map<String, dynamic> toMap(String fullName, String data, String branch) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnBranch: branch,
      columnData: data
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryCommitsDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
    branch = map[branch];
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
      $columnData next not null,
      $columnBranch next not null)
    ''';
  }

  Future _getProvider(Database db, String fullName, String branch) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnFullName, columnBranch, columnData],
        where: "$columnFullName = ? and $columnBranch = ?",
        whereArgs: [fullName, branch]);
    if (maps.length > 0) {
      RepositoryCommitsDbProvider provider =
          RepositoryCommitsDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(String fullName, String branch, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      await db.delete(name,
          where: "$columnFullName = ? and $columnData = ?",
          whereArgs: [columnFullName, columnData]);
    }
    return await db.insert(name, toMap(fullName, dataMapString, branch));
  }

  ///获取事件数据
  Future<List<RepoCommit>> getData(String fullName, String branch) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      List<RepoCommit> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(RepoCommit.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
