import 'dart:async';
import 'dart:io';

import 'package:zpj_github_app/common/model/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zpj_github_app/common/dao/UserDao.dart';

class SqlManager {
  static const _VERSION = 1;
  static const _NAME = "githup_app_flutter.db";
  static Database _database;

  static init() async {
    var dataBasePath = await getDatabasesPath();

    var userRes = await UserDao.getUserInfoLocal();
    String dbName = _NAME;
    if (userRes != null && userRes.result) {
      User user = userRes.data;
      if (user != null && user.login != null) {
        dbName = user.login + "_" + _NAME;
      }
    }
    String path = dataBasePath + dbName;
    if (Platform.isIOS) {
      path = dataBasePath + "/" + dbName;
    }
    _database = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});
  }

  ///表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database.close();
    _database = null;
  }
}
