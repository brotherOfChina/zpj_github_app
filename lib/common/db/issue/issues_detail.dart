import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/db/repos/repository_issue.dart';
/**
 *   author：Administrator
 *   create_date:2018/12/29 0029-10:35
 *   note:详情表
 */
class IssueDetailDbProvider extends BaseDbProvider {
  final String name = "IssueDetail";
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnNumber = "number";
  final String columnData = "data";

  int id;
  String fullName;
  String number;
  String data;

  IssueDetailDbProvider();

  Map<String, dynamic> toMap(String fullNma, String number, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullNma,
      columnData: data,
      columnNumber: number
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  IssueDetailDbProvider.fromMap(Map map) {
    id = map[columnId];
    number = map[columnNumber];
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
      $columnNumber text not null,
      $columnData text not null)
    ''';
  }
  Future _getProvider(Database db,String fullName,String number)async{
    List<Map<String ,dynamic>> maps=await db.query(name,
      columns: [columnId,columnFullName,columnNumber,columnData],
      where: "$columnFullName = and $columnNumber =?",
      whereArgs: [fullName,number]);
    if(maps.length>0){

    }
  }



































}
