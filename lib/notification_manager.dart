import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  static final initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  static final initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

  static final NotificationManager _singleton = NotificationManager._internal();
  init() async {
    if(!_isInitialized){
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: selectNotification);
      _isInitialized = true;
    }
  }

  factory NotificationManager() {
    // _singleton.flutterLocalNotificationsPlugin
    return _singleton;
  }

  NotificationManager._internal();
}

Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
}

Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    // );
}