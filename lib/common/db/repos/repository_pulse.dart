import 'package:zpj_github_app/common/db/sql_provider.dart';

class RepositoryPulseDbProvider extends BaseDbProvider {
  final String name = "RepositoryPulse";
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  Map<String, dynamic> toMap(String fullName, String data) {
    Map map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryPulseDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {}
}
