
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kail/constants/asset_constants.dart';
import 'package:kail/constants/notification_constants.dart';
import 'package:kail/kail_activity.dart';

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
        primaryColor: Colors.black,
        brightness: Brightness.dark,
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
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],    
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.add(KailActivity("yoga","09:30 am",AssetConstants.IMG_YOGA));
          _suggestions.add(KailActivity("sleep","23:00 pm",AssetConstants.IMG_SLEEP));
        }
        return _buildRow(_suggestions[index]);
      });
  }

  Widget _buildRow(KailActivity kailActivity) => Stack(
      alignment: const Alignment(-1.0, 0.95),
      children: [
        Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: Image.asset(kailActivity.imageLocation)
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children : [
                  Text(
                      kailActivity.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  Text(
                      kailActivity.nextOccurence,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ]
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children : [
                  IconButton(icon: Icon(Icons.edit), onPressed: _pushSaved),
                  IconButton(icon: Icon(Icons.snooze), onPressed: _pushSaved),
                  IconButton(icon: Icon(Icons.delete_forever), onPressed: _pushSaved),
                ]
              )
            ]
          ),
        )
      ]
    );

  void _pushSaved() {
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
