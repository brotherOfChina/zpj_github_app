import 'package:zpj_github_app/common/db/sql_provider.dart';

/**
*   author：Administrator
*   create_date:2018/12/17 0017-15:29
*   note:组织成员表
*/
class OrgMemberDbProvider extends BaseDbProvider{
  final String name='OrgMember';
  final String columnId="_id";
  final String columnOrg="org";
  final String columnData="data";

  int id;
  String org;
  String data;
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map ={columnOrg:org,columnData:data};
    if(id!=null){
      map[columnId]=id;
    }
    return map;
  }
  OrgMemberDbProvider.fromMap(Map map){
    id=map[columnId];
    org=map[columnOrg];
    data=map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {

  }

}