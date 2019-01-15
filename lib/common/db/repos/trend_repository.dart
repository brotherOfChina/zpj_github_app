import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/TrendingRepoModel.dart';

/**
 *   author：Administrator
 *   create_date:2019/1/9 0009-13:49
 *   note:趋势表
 */
class TrendRepositoryDbProvider extends BaseDbProvider {
  final String name = "TrendRepository";
  final String columnId = "_id";
  final String columnLanguageTYpe = "languageType";
  final String columnSince = 'since';
  final String columnData = "data";

  int id;
  String fullName;
  String data;
  String since;
  String languageType;

  TrendRepositoryDbProvider();

  TrendRepositoryDbProvider.from(Map map) {
    id = map[columnId];
    fullName = map[fullName];
    languageType = map[columnLanguageTYpe];
    since = map[columnSince];
  }

  Map<String, dynamic> toMap(
      String language, String since, String dataMapString) {
    Map<String, dynamic> map = {
      columnLanguageTYpe: language,
      columnSince: since,
      columnData: dataMapString
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      $columnLanguageTYpe text not null,
      $columnSince text not null,
      $columnData text not null)
    ''';
  }

  Future insert(String language, String since, String dataMapString) async {
    Database db = await getDataBase();
    db.execute('delete from $name');
    return await db.insert(name, toMap(language, since, dataMapString));
  }

  ///获取事件数据
  Future<List<TrendingRepoModel>> getData(String language, String since) async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(name,
        columns: [columnId, columnLanguageTYpe, columnSince, columnData],
        where: '$columnLanguageTYpe =? and $columnSince = ?',
        whereArgs: [language, since]);
    List<TrendingRepoModel> list = List();
    if (maps.length > 0) {
      TrendRepositoryDbProvider provider =
          TrendRepositoryDbProvider.from(maps.first);
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(TrendingRepoModel.fromJson(item));
        }
      }
    }
    return list;
  }
}
