import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';
import 'package:zpj_github_app/common/db/sql_manager.dart';
/**
*   created by zpj
*   updateTime:
*   createdTime: 2018/12/16 19:15
        sql基类
*/
abstract class BaseDbProvider{
  bool isTableExits=false;

  tableSqlString();
  tableName();
  tableBaseString(String name,String columnId){
    return '''
        create table $name (
        $columnId integer primary key autoincrement, 
      ''';
  }
  Future<Database> getDataBase() async{
    return await open();

  }
  @mustCallSuper
  prepare(name ,String createSql)async{


  }
  @mustCallSuper
  open() async{
    if(!isTableExits){
//      await prepare()
    }

  }


}