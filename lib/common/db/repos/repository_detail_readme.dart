import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/30 0030-11:40
 *   note:仓库readme文件表
 */
class RepositoryDetailReadmeDbProvider extends BaseDbProvider {
  final String name = "RepositoryDetailReadme";
  int id;
  String fullName;
  String data;
  String branch;

  final String columnFullName = 'fullName';
  final String columnData = 'data';
  final String columnId = "_id";
  final String columnBranch = "branch";

  @override
  tableName() {
    return name;
  }

  Map<String, dynamic> toMap(String fullName, String data, String branch) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnData: data,
      columnBranch: branch
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryDetailReadmeDbProvider.fromMap(Map map) {
    id = map[columnId];
    data = map[columnData];
    branch = map[columnBranch];
    fullName = map[columnFullName];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnFullName text not null,
      $columnData text not null,
      $columnBranch text not null)
    ''';
  }

  Future _getProvider(Database db, String fullName, String branch) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData],
        where: "$columnFullName = ? and $columnBranch = ?",
        whereArgs: [fullName, branch]);
    if (maps.length > 0) {
      RepositoryDetailReadmeDbProvider provider =
          RepositoryDetailReadmeDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(String fullName, String branch, String data) async {
    Database db = await getDataBase();
    var provider = _getProvider(db, fullName, branch);
    if (provider != null) {
      await db.delete(name,
          where: "$columnFullName =? amd $columnBranch = ? ",
          whereArgs: [columnFullName, columnBranch]);
    }
    return await db.insert(name, toMap(fullName, data, branch));
  }
  ///获取readme详情
  Future<String> getRepository(String fullName,String branch) async{
    Database db=await getDataBase();
    var provider=await _getProvider(db, fullName, branch);
    if(provider!=null){
      return provider.data;
    }
    return null;
  }
}
