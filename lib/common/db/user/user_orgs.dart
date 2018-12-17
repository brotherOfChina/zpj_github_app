import 'dart:async';
import 'dart:convert';

import 'package:zpj_github_app/common/model/User.dart';
import 'package:zpj_github_app/common/model/UserOrg.dart';
import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
/**
 *   created by zpj
 *   updateTime:
 *   createdTime: 2018/12/16 19:13
    用户组织
 */

class UserOrgDbProvider extends BaseDbProvider {
  final String name = "UserOrg";
  final String columnId = "_id";
  final String columnUserName = "userName";
  final String columnData = "data";

  int id;
  String userName;
  String data;

  UserOrgDbProvider();

  Map<String, dynamic> toMap(String userName, String data) {
    Map<String, dynamic> map = {columnUserName: userName, columnData: data};
    if (id != null) {
      {
        map[columnId] = id;
      }
    }
    return map;
  }

  UserOrgDbProvider.fromMap(Map map) {
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
        columns: [columnId, columnUserName, columnData],
        where: "$columnUserName=?",
        whereArgs: [userName]);
    if(maps.length>0){
      UserOrgDbProvider provider=UserOrgDbProvider.fromMap(maps.first);
      return  provider;
    }
    return null;
  }
  ///插入到数据库
  Future insert(String userName,String eventMapString) async{
    Database db=await getDataBase();
    var provider=_getProvider(db, userName);
    if(provider!=null){
      await db.delete(name,where: "$columnUserName=?",whereArgs: [userName]);
    }
    return await db.insert(name, toMap(userName, eventMapString));

  }
  Future<List<UserOrg>> getData(String userName) async {
    Database db=await getDataBase();
    var provider=await _getProvider(db, userName);
    if(provider!=null){
      List<UserOrg> list=new List();
      List<dynamic> eventMap=json.decode(provider.data);
      if(eventMap.length>0){
        for(var item in eventMap){
          list.add(UserOrg.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}
