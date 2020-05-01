import 'dart:async';
import 'dart:developer';

import 'package:kail/constants/db_constants.dart';
import 'package:kail/kail_activity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class KailDao {
  static final KailDao _singleton = KailDao._internal();
  bool _isInit = false;

  Database _kailDatabase;

  init() async{
    if(!_singleton._isInit){
      _singleton._kailDatabase = await openDatabase(
        join(await getDatabasesPath(), DBConstants.KAIL_DB_PATH),
        version: 1,
        onCreate: (db,version) async {
          await db.execute(DBConstants.KAIL_ACTIVTITY_CREATE_TABLE_SQL_V1);
          await db.execute(DBConstants.KAIL_SCHEDULE_CREATE_TABLE_SQL_V1);
        }
      );
      _singleton._isInit = true;
      log("DB init complete");
    }
    log("DB already initialized, skipping");
  }

  Future<KailActivity> insertKailAcitivity(KailActivity kailActivity) async {
    Map<String,dynamic> insertionMap = {
      'name': kailActivity.name,
      'acitivity_type': kailActivity.activityType,
    };
    kailActivity.id = await _kailDatabase.insert(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME, 
      insertionMap
    );
    return kailActivity;
  }

  factory KailDao() {
    return _singleton;
  }

  KailDao._internal();
}