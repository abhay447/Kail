
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kail/add_notification_widget.dart';
import 'package:kail/constants/notification_constants.dart';
import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';

import 'constants/activity_type_constants.dart';

scheduleNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: selectNotification);
  
  var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(NotificationConstants.notification_channel_id,
        NotificationConstants.notification_channel_name, NotificationConstants.notification_channel_desscription);
  var iOSPlatformChannelSpecifics =
      IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0, 'plain title', 'plain body', platformChannelSpecifics,
    payload: 'item x');
    
  return flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
      'repeating body', RepeatInterval.Hourly, platformChannelSpecifics);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KailDao().init();
  runApp(MyApp());
  await scheduleNotifications();
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: KailWidget(),
      theme: ThemeData(          // Add the 3 lines from here... 
        primaryColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),  
    );
  }
}

class KailWidgetState extends State<KailWidget> {
  final _suggestions = <KailActivity>[];
  final _biggerFont = const TextStyle(fontSize: 18.0); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text('Howdy'),
        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.add), onPressed: _addKailActivity),
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],    
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      color: Colors.white,
      child : ListView.builder(
      
      padding: const EdgeInsets.all(5.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/
        _s
        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.add(KailActivity.from3("yoga","09:30 am",ActivityTypeConstants.FITNESS));
          _suggestions.add(KailActivity.from3("sleep","23:00 pm",ActivityTypeConstants.REST));
        }
        return _buildRow(_suggestions[index]);
      })
    );
  }

  Widget _buildRow(KailActivity kailActivity) => 
    Container(
      decoration: BoxDecoration(

            color: Colors.blueAccent,

            shape: BoxShape.rectangle,

            borderRadius: BorderRadius.only(

              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)

            ) 

          ),
      child : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        
        children: [
          ActivityTypeConstants.getIconforActivityType(kailActivity.activityType),

          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                        kailActivity.name + " @ " + kailActivity.nextOccurence,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children : [
                    IconButton(icon: Icon(Icons.edit), color: Colors.white, onPressed: _pushSaved),
                    IconButton(icon: Icon(Icons.snooze),color: Colors.white, onPressed: _pushSaved),
                    IconButton(icon: Icon(Icons.delete_forever,color: Colors.white,), onPressed: _pushSaved),
                  ]
                )
              ]
            ),
        ]
      ),
        // )
    );

  void _pushSaved() {
  }

  void _addKailActivity(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AddKailActivity();
        }
      )
    );
  }
}

class KailWidget extends StatefulWidget {
  @override
  KailWidgetState createState() => KailWidgetState();
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
