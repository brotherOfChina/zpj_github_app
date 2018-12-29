import 'dart:convert';

import 'package:zpj_github_app/common/config/Config.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/model/Repository.dart';
/**
 *   author：Administrator
 *   create_date:2018/12/29 0029-11:11
 *   note:阅读历史
 */

/// 1. 声明  数据库名称，  id，  fullname .readDate, data
///2. toMap  及  fromMap
///3. 生成创建数据库的string
///4. 创建数据库
///5. 插入数据库
///6. 获取详情
///7. 从数据删除
class ReadHistoryDbProvider extends BaseDbProvider {
  final String name = "ReadHistory";
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnReadDate = "readDate";
  final String columnData = "data";

  int id;
  String fullName;
  String readDate;
  String data;

  ReadHistoryDbProvider();

  Map<String, dynamic> toMap(String fullName, DateTime readDate, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnReadDate: readDate.millisecondsSinceEpoch,
      columnData: data
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ReadHistoryDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    readDate = map[columnReadDate];
    data = map[columnData];
  }

  @override
  tableName() {
    // TODO: implement tableName
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnFullName text not null,
      $columnReadDate int not null,
      $columnData text not null)
      
    ''';
  }

  Future _getProviderMaps(Database db, int page) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData, columnReadDate],
        limit: Config.PAGE_SIZE,
        offset: (page - 1) * Config.PAGE_SIZE,
        orderBy: "$columnReadDate DESC");
    if (maps.length > 1) {
      return maps;
    } else {
      return null;
    }
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(
      name,
      columns: [columnId, columnFullName, columnData, columnReadDate],
      where: "$columnFullName = ?",
      whereArgs: [fullName],
    );
    if (maps.length > 0) {
      ReadHistoryDbProvider provider =
          ReadHistoryDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  Future insert(
      String fullName, DateTime dateTime, String dataMapString) async {
    Database database = await getDataBase();
    var provider = _getProvider(database, fullName);
    if (provider != null) {
      await database
          .delete(name, where: "$columnFullName= ?", whereArgs: [fullName]);
    }
    return await database.insert(
        name, toMap(fullName, dateTime, dataMapString));
  }

  Future<List<Repository>> getData(int page) async {
    Database db = await getDataBase();
    var provider = await _getProviderMaps(db, page);
    if (provider != null) {
      List<Repository> lists = new List();
      for (var repositoryMap in provider) {
        ReadHistoryDbProvider provider =
            ReadHistoryDbProvider.fromMap(repositoryMap);
        Map map = json.decode(provider.data);
        lists.add(Repository.fromJson(map));
      }
      return lists;
    }
    return null;
  }
}
