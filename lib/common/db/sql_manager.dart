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
}
