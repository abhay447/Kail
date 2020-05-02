import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kail/constants/notification_constants.dart';
import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';

class NotificationManager{
  static final NotificationManager _singleton = NotificationManager._internal();
  static final _androidPlatformChannelSpecifics =
    AndroidNotificationDetails(NotificationConstants.notification_channel_id,
        NotificationConstants.notification_channel_name, NotificationConstants.notification_channel_desscription);
  static final _iOSPlatformChannelSpecifics =IOSNotificationDetails();
  static final _platformChannelSpecifics = NotificationDetails(
      _androidPlatformChannelSpecifics, _iOSPlatformChannelSpecifics);

  bool _isInit = false;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  init() async{
    if(!_singleton._isInit){
      var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: selectNotification);
      _singleton._isInit = true;
      log("notification Manager init complete");
    }
    log("notification Manager already initialized, skipping");
  }


  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
  }
  
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    // );
}

  KailActivity scheduleNotificationForActivity(KailActivity _kailActivity){
    for(KailSchedule schedule in _kailActivity.schedules){
      var notificationID = (DateTime.now().millisecondsSinceEpoch/1000).floor();
      _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        notificationID, 
        _kailActivity.name, 
        _kailActivity.activityType, 
        NotificationConstants.index_day_map[schedule.day], 
        Time(schedule.hour, schedule.minute, 0), 
        _platformChannelSpecifics
      );
      schedule.notificationID = notificationID;
    }
    return _kailActivity;
  }

  void deleteNotifications(List<int> _notification_ids) async{
    for (int id in _notification_ids){
        _flutterLocalNotificationsPlugin.cancel(id);
    }
  }

  factory NotificationManager() {
    return _singleton;
  }

  NotificationManager._internal();
}