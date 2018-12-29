import 'package:zpj_github_app/common/db/sql_provider.dart';

/**
 *   author：Administrator
 *   create_date:2018/12/29 0029-17:32
 *   note:仓库提交详情
 */
class RepositoryCommitInfoDetailDbProvider extends BaseDbProvider {
  final String name = "RepositoryCommit";
  final String columnId = "_id";
  final String columnCommitTime = "coomitTime";
  final String columnData = "data";
  final String columnFullName = "fullName";

  int id;
  String fullName;
  String data;
  String commitTime;

  RepositoryCommitInfoDetailDbProvider();

  Map<String, dynamic> toMap(
      String fullName, DateTime commitTime, String data) {
    Map<String, dynamic> map = {
      columnFullName: fullName,
      columnCommitTime: commitTime.millisecondsSinceEpoch,
      columnData: data
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryCommitInfoDetailDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[fullName];
    data = map[data];
    commitTime = map[commitTime];
  }

  Future _getProvider() {}

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {}
}
