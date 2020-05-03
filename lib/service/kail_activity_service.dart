import 'dart:developer';

import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';
import 'package:kail/notifications/notification_manager.dart';
import 'package:sqflite/sqflite.dart';

class KailActivityService {
  static final KailActivityService _singleton = KailActivityService._internal();
  bool _isInit = false;
  KailDao _kailDao;
  NotificationManager _notificationManager;

  init() async{
    if(!_singleton._isInit){
      _singleton._kailDao = KailDao();
      _singleton._kailDao.init();
      _singleton._notificationManager = NotificationManager();
      _singleton._notificationManager.init();
      _singleton._isInit = true;
      log("notification Service init complete");
    }
    log("notification Service already initialized, skipping");
  }

  factory KailActivityService() {
    return _singleton;
  }

  KailActivityService._internal();

  Future<List<KailActivity>> listAllActivities() async {
    return await _singleton._kailDao.getDB().transaction((txn) async {
      return _singleton._kailDao.listKailActivities(txn);
    });
  }

  deleteScheduledActivity(KailActivity kailActivity) async {
    await _singleton._kailDao.getDB().transaction((txn) async {
      var batch = _singleton._kailDao.getBatch(txn);
      _deleteScheduledActivity(txn,kailActivity);
      await batch.commit();
    });
  }

  _deleteScheduledActivity(Transaction txn,KailActivity kailActivity) async{
    // 1. Fetch all activity_ids and schedules fromDB using ID or Name+Type : DAO
    // 2. Cancel all notifications in those schedules : notification manager
    // 3. Delete all schedules from DB for an activity: DAO
    // 4. Delete all activities from DB : DAO
    
    // 1.
    List<KailActivity> oldActivities ;
    if(kailActivity.id != null){
      oldActivities = await _singleton._kailDao.listKailActivitiesbyID(txn,kailActivity.id);
    } else {
      oldActivities = await _singleton._kailDao.listKailActivitiesbyNameAndType(txn,kailActivity.name,kailActivity.activityType);
    }

    // 2. 
    for(KailActivity oldActivity in oldActivities){
      List<KailSchedule> oldSchedules = await _singleton._kailDao.getSchedulesForActivity(txn,oldActivity);
      List<int> oldNotificationIDs = new List();
      for (KailSchedule oldSchedule in oldSchedules){
        oldNotificationIDs.add(oldSchedule.notificationID);
      }
      await _singleton._notificationManager.deleteNotifications(oldNotificationIDs);
    }

    // 3.
    for(KailActivity oldActivity in oldActivities){
      await _singleton._kailDao.deleteKailAcitvitySchedules(txn,oldActivity);
    }

    // 4.
    for(KailActivity oldActivity in oldActivities){
      await _singleton._kailDao.deleteKailAcitvity(txn,oldActivity);
    }

  }

  saveAndScheduledActivity(KailActivity kailActivity) async {
    await _singleton._kailDao.getDB().transaction((txn) async {
      var batch = _singleton._kailDao.getBatch(txn);
      _saveAndScheduledActivity(txn,kailActivity);
      await batch.commit();
    });
  }

  _saveAndScheduledActivity(Transaction txn,KailActivity kailActivity) async {
    // 1. Delete Existing Activity
    // 2. Save Activity in DB : DAO
    // 3. Schedule all notifications for activity : notification manager
    // 4. Save Schedules in DB : DAO
    
    // 1.
    _deleteScheduledActivity(txn,kailActivity);

    // 2.
    kailActivity = await _singleton._kailDao.saveKailAcitivity(txn,kailActivity);

    // 3.
    _singleton._notificationManager.scheduleNotificationForActivity(kailActivity);

    // 4.
    _singleton._kailDao.saveKailSchedules(txn,kailActivity);

    

  }
}