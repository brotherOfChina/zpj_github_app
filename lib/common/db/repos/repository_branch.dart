

import 'package:zpj_github_app/common/db/sql_provider.dart';

/**
*   author：Administrator
*   create_date:2018/12/29 0029-17:22
*   note:branch
*/
class RepositoryBranchDbProvider extends BaseDbProvider{
  final String name="RepositoryBranch";
  final String columnId="_id";
  final String columnFullName="fullName";
  final String columnData="data";

  int id;
  String fullName;
  String data;

  Map<String,dynamic> toMap(String fullName,String data){
    Map<String,dynamic> map={columnFullName:fullName,columnData:data};
    if(id!=null){
      map[columnId]=id;
    }
    return map;
  }
  RepositoryBranchDbProvider();
  RepositoryBranchDbProvider.fromMap(Map map){
    id=map[columnId];
    fullName=map[columnFullName];
    data=map[columnData];
  }

  @override
  tableName() {

    return name;
  }

  @override
  tableSqlString() {

    return null;
  }


}