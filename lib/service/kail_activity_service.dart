import 'dart:developer';

import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';
import 'package:kail/notifications/notification_manager.dart';

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

  deleteScheduledActivity(KailActivity kailActivity) async {
    var batch = _singleton._kailDao.getBatch();
    _deleteScheduledActivity(kailActivity);
    batch.commit();
  }

  _deleteScheduledActivity(KailActivity kailActivity) async{
    // 1. Fetch all activity_ids and schedules fromDB using ID or Name+Type : DAO
    // 2. Cancel all notifications in those schedules : notification manager
    // 3. Delete all schedules from DB for an activity: DAO
    // 4. Delete all activities from DB : DAO
    
    // 1.
    List<KailActivity> oldActivities ;
    if(kailActivity.id != null){
      oldActivities = await _singleton._kailDao.listKailActivitiesbyID(kailActivity.id);
    } else {
      oldActivities = await _singleton._kailDao.listKailActivitiesbyNameAndType(kailActivity.name,kailActivity.activityType);
    }

    // 2. 
    for(KailActivity oldActivity in oldActivities){
      List<KailSchedule> oldSchedules = await _singleton._kailDao.getSchedulesForActivity(oldActivity);
      List<int> oldNotificationIDs = new List();
      for (KailSchedule oldSchedule in oldSchedules){
        oldNotificationIDs.add(oldSchedule.notificationID);
      }
      _singleton._notificationManager.deleteNotifications(oldNotificationIDs);
    }

    // 3.
    for(KailActivity oldActivity in oldActivities){
      await _singleton._kailDao.deleteKailAcitvitySchedules(oldActivity);
    }

    // 4.
    for(KailActivity oldActivity in oldActivities){
      await _singleton._kailDao.deleteKailAcitvity(oldActivity);
    }

  }

  saveAndScheduledActivity(KailActivity kailActivity) async {
    var batch = _singleton._kailDao.getBatch();
    _saveAndScheduledActivity(kailActivity);
    batch.commit();
  }

  _saveAndScheduledActivity(KailActivity kailActivity) async {
    // 1. Delete Existing Activity
    // 2. Save Activity in DB : DAO
    // 3. Schedule all notifications for activity : notification manager
    // 4. Save Schedules in DB : DAO
    
    // 1.
    _deleteScheduledActivity(kailActivity);

    // 2.
    kailActivity = await _singleton._kailDao.saveKailAcitivity(kailActivity);

    // 3.
    _singleton._notificationManager.scheduleNotificationForActivity(kailActivity);

    // 4.
    _singleton._kailDao.saveKailSchedules(kailActivity);

    

  }
}