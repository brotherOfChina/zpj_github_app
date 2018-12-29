import 'dart:async';
import 'dart:convert';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/model/Issue.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/29 0029-8:56
 *   note:仓库表
 */

class RepositoryIssueDbProvider extends BaseDbProvider {
  final String name = 'RepositoryIssue';
  int id;
  String fullName;
  String data;
  String state;

  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnState = "state";
  final String columnData = "data";

  RepositoryIssueDbProvider();

  Map<String, dynamic> toMap(String fullName, String state, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnState: state,
      columnData: data
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryIssueDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
    state = map[columnState];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnFullName text  not null,
      $columnState text not null,
      $columnData text not null)
    ''';
  }

  Future _getProvider(Database db, String fullName, String state) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnState, columnData],
        where: "$columnFullName = ? and $columnState = ?",
        whereArgs: [fullName, state]);
    if (maps.length > 0) {
      RepositoryIssueDbProvider provider =
          RepositoryIssueDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(String fullName, String state, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, state);
    if (provider != null) {
      await db.delete(name,
          where: "$columnFullName = ? and $columnState =?",
          whereArgs: [fullName, state]);
    }
    return await db.insert(name, toMap(fullName, state, dataMapString));
  }

  ///获取事件数据
  Future<List<Issue>> getData(String fullName, String branch) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName, branch);
    if (provider != null) {
      List<Issue> list = new List();
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Issue.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
