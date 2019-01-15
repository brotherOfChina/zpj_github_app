import 'dart:async';
import 'dart:convert';

import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/Event.dart';
import 'package:sqflite/sqflite.dart';

/**
 *   author：Administrator
 *   create_date:2019/1/11 0011-14:37
 *   note:用户动态表
 */
class UserEventDbProvider extends BaseDbProvider {
  final String name = "UserEvent";
  final String columnId = "_id";
  final String columnUserName = "userName";
  final String columnData = "data";

  int id;
  String userName;
  String data;

  UserEventDbProvider();

  Map<String, dynamic> toMap(String userName, String eventMapString) {
    Map<String, dynamic> map = {
      columnUserName: userName,
      columnData: eventMapString
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserEventDbProvider.from(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
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
      $columnUserName text not null,
      $columnData text not null)
    ''';
  }

  Future _getProvider(Database db, String userName) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnData, columnUserName],
        where: '$columnUserName = ?',
        whereArgs: [userName]);
    if(maps.length>0){
      UserEventDbProvider provider=UserEventDbProvider.from(maps.first);
      return provider;
    }
    return null;
  }
  ///插入到数据库
  Future insert(String userName,String eventMapString)async{
    Database db=await getDataBase();
    var provider=await _getProvider(db, userName);
    if(provider!=null){
      List<Event>list=new List();

  }
  }






















}
