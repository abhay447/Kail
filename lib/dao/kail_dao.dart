import 'dart:async';
import 'dart:developer';

import 'package:kail/constants/db_constants.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';
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

  Future<List<KailActivity>> listKailActivities() async {
    List<KailActivity> activityList = new List();
    var activityResultSet = await _kailDatabase.query(DBConstants.KAIL_ACTIVITY_TABLE_NAME);
    for(var activityRow in activityResultSet){
      var activity = new KailActivity.from3(
          activityRow["name"], 
          "_nextOccurence", 
          activityRow["activity_type"] 
        );
      activity.id = activityRow["id"];
      KailSchedule schedule = await getScheduleForActivity(activity);
      activity.schedule = schedule;
      activityList.add(activity);
    }

    return activityList;
  }

  Future<KailSchedule> getScheduleForActivity(KailActivity kailActivity) async {
    KailSchedule schedule = new KailSchedule();
    var scheduleResultSet = await _kailDatabase.query(
      DBConstants.KAIL_SCHEDULE_TABLE_NAME,
      where: 'activity_id=?',
      whereArgs: [kailActivity.id]
    );
    for(var scheduleRow in scheduleResultSet){
        schedule.days.add(scheduleRow["days"]);
    }
    schedule.hour = scheduleResultSet[0]["hour"];
    schedule.minute = scheduleResultSet[0]["minute"];
    return schedule;
  }

  Future<KailActivity> saveKailAcitivity(KailActivity kailActivity) async {
    var batch = _kailDatabase.batch();
    await _kailDatabase.delete(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME,
      where: 'name=? and activity_type=?',
      whereArgs: [kailActivity.name,kailActivity.activityType]
    );
    Map<String,dynamic> insertionMap = {
      'name': kailActivity.name,
      'activity_type': kailActivity.activityType,
    };
    kailActivity.id = await _kailDatabase.insert(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME, 
      insertionMap
    );
    await saveKailSchedules(kailActivity);
    batch.commit();
    return kailActivity;
  }

  Future<KailActivity> saveKailSchedules(KailActivity kailActivity) async {
    await _kailDatabase.delete(
      DBConstants.KAIL_SCHEDULE_TABLE_NAME,
      where: 'activity_id=?',
      whereArgs: [kailActivity.id]
    );
    for(int day in kailActivity.schedule.days){
      Map<String,dynamic> insertionMap = {
        'activity_id': kailActivity.id,
        'day': day,
        'hour': kailActivity.schedule.hour,
        'minute': kailActivity.schedule.minute
      };
      await _kailDatabase.insert(
        DBConstants.KAIL_SCHEDULE_TABLE_NAME, 
        insertionMap
      );
    }
    
    return kailActivity;
  }

  factory KailDao() {
    return _singleton;
  }

  KailDao._internal();
}