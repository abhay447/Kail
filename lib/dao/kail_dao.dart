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
      List<KailSchedule> schedules = await getSchedulesForActivity(activity);
      activity.schedules = schedules;
      activityList.add(activity);
    }

    return activityList;
  }

  Future<List<KailActivity>> listKailActivitiesbyNameAndType(String name,String type) async {
    List<KailActivity> activityList = new List();
    var activityResultSet = await _kailDatabase.query(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME,
      where: 'name=? and activity_type=?',
      whereArgs: [name,type]
    );
    for(var activityRow in activityResultSet){
      var activity = new KailActivity.from3(
          activityRow["name"], 
          "_nextOccurence", 
          activityRow["activity_type"] 
        );
      activity.id = activityRow["id"];
      List<KailSchedule> schedules = await getSchedulesForActivity(activity);
      activity.schedules = schedules;
      activityList.add(activity);
    }

    return activityList;
  }

  Future<List<KailActivity>> listKailActivitiesbyID(int id) async {
    List<KailActivity> activityList = new List();
    var activityResultSet = await _kailDatabase.query(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME,
      where: 'id=?',
      whereArgs: [id]
    );
    for(var activityRow in activityResultSet){
      var activity = new KailActivity.from3(
          activityRow["name"], 
          "_nextOccurence", 
          activityRow["activity_type"] 
        );
      activity.id = activityRow["id"];
      List<KailSchedule> schedules = await getSchedulesForActivity(activity);
      activity.schedules = schedules;
      activityList.add(activity);
    }

    return activityList;
  }

  Future<List<KailSchedule>> getSchedulesForActivity(KailActivity kailActivity) async {
    List<KailSchedule> schedules = new List();
    var scheduleResultSet = await _kailDatabase.query(
      DBConstants.KAIL_SCHEDULE_TABLE_NAME,
      where: 'activity_id=?',
      whereArgs: [kailActivity.id]
    );
    for(var scheduleRow in scheduleResultSet){
      KailSchedule schedule = new KailSchedule();
      schedule.day = scheduleRow["days"];
      schedule.hour = scheduleRow["hour"];
      schedule.minute = scheduleRow["minute"];
      schedule.notificationID = scheduleRow["notification_id"];
      schedule.id = scheduleRow['id'];
      schedules.add(schedule);
    }
    return schedules;
  }

  // Future<List<int>> getNotificationsForActivity(KailActivity kailActivity) async {
  //   List<int> notification_ids = new List();
  //   var scheduleResultSet = await _kailDatabase.query(
  //     DBConstants.KAIL_SCHEDULE_TABLE_NAME,
  //     where: 'activity_id=?',
  //     whereArgs: [kailActivity.id]
  //   );
  //   for(var scheduleRow in scheduleResultSet){
  //       notification_ids.add(scheduleRow["notification_id"]);
  //   }
  //   return notification_ids;
  // }

  Future<int> deleteKailAcitvity(KailActivity kailAcitivity) async{
    return _kailDatabase.delete(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME,
      where: 'id=?',
      whereArgs: [kailAcitivity.id]
    );
  }
  

  Future<int> deleteKailAcitvitySchedules(KailActivity kailAcitivity) async{
    return _kailDatabase.delete(
      DBConstants.KAIL_SCHEDULE_TABLE_NAME,
      where: 'activity_id=?',
      whereArgs: [kailAcitivity.id]
    );
  }

  Future<KailActivity> saveKailAcitivity(KailActivity kailActivity) async {
    Map<String,dynamic> insertionMap = {
      'name': kailActivity.name,
      'activity_type': kailActivity.activityType,
    };
    kailActivity.id = await _kailDatabase.insert(
      DBConstants.KAIL_ACTIVITY_TABLE_NAME, 
      insertionMap
    );

    return kailActivity;
  }

  Future<KailActivity> saveKailSchedules(
    KailActivity kailActivity) async {
    
    for(var schedule in kailActivity.schedules){
      Map<String,dynamic> insertionMap = {
        'activity_id': kailActivity.id,
        'day':schedule.day,
        'hour': schedule.hour,
        'minute': schedule.minute,
        'notification_id': schedule.notificationID
      };
      await _kailDatabase.insert(
        DBConstants.KAIL_SCHEDULE_TABLE_NAME, 
        insertionMap
      );
    }
    
    return kailActivity;
  }

  Batch getBatch(){
    return _kailDatabase.batch();
  }

  factory KailDao() {
    return _singleton;
  }

  KailDao._internal();
}
