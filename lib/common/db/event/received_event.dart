import 'dart:async';
import 'dart:convert';

import 'package:zpj_github_app/common/db/sql_provider.dart';
import 'package:zpj_github_app/common/model/Event.dart';
import 'package:sqflite/sqflite.dart';

/**
 *   author：Administrator
 *   create_date:2019/1/11 0011-14:20
 *   note:用户接受事件表
 */
class ReceiveEventDbProvider extends BaseDbProvider {
  final String name = "ReceivedEvent";
  final String columnId = "_id";
  final String columnData = "data";

  int id;
  String data;

  ReceiveEventDbProvider();

  Map<String, dynamic> toMap(String data) {
    Map<String, dynamic> map = {columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ReceiveEventDbProvider.from(Map map) {
    id = map[columnId];
    data = map[columnData];
  }

  @override
  tableName() {
    return tableBaseString(name, columnId) +
        '''
    $columnData text not null)
    ''';
  }

  @override
  tableSqlString() {
    return name;
  }

  ///插入到数据库
  Future insert(String eventMapString) async {
    Database db = await getDataBase();
    db.execute('delete from $name');
    return await db.insert(name, toMap(eventMapString));
  }

  ///获取事件数据
  Future<List<Event>> getEvents() async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(name, columns: [columnId, columnData]);
    List<Event> list = new List();
    if (maps.length > 0) {
      ReceiveEventDbProvider provider = ReceiveEventDbProvider.from(maps.first);
      List<dynamic> eventMap = json.decode(provider.data);
      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(Event.fromJson(item));
        }
      }
    }
    return list;
  }
}
