
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kail/add_notification_widget.dart';
import 'package:kail/constants/notification_constants.dart';
import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/service/kail_activity_service.dart';

import 'constants/activity_type_constants.dart';
import 'util/time_utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KailDao().init();
  await KailActivityService().init();
  runApp(MyApp());
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
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<KailActivity> _suggestions = new List<KailActivity>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text('Upcoming Checkpoints'),
        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.add), onPressed: () => _addKailActivity(null)),
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],    
      ),
      // body: FutureBuilder<List<KailActivity>>(
      //   future: KailDao().listKailActivities(),
      //   builder : (BuildContext context, AsyncSnapshot<List<KailActivity>> snapshot){
      //     if(snapshot.hasData){
      //       return _buildSuggestions(snapshot.data);
      //     } else{
      //       return _buildSuggestions(new List<KailActivity>());
      //     }
      //   }
      // )
      body: StreamBuilder<List<KailActivity>>(
        stream: Stream.fromFuture(KailActivityService().listAllActivities()),
        builder : (BuildContext context, AsyncSnapshot<List<KailActivity>> snapshot){

          if (snapshot.hasError)
            return _buildSuggestions();
          switch (snapshot.connectionState) {
            case ConnectionState.none: return _buildSuggestions();
            case ConnectionState.waiting: return _buildSuggestions();
            case ConnectionState.active: {
              _suggestions = snapshot.data;
              return _buildSuggestions();
            }
            case ConnectionState.done: {
              _suggestions = snapshot.data;
              return _buildSuggestions();
            }
          }
          return _buildSuggestions(); 
        }
      )
    );
  }

  Widget _buildSuggestions() {
    return Container(
      color: Colors.white,
      child : ListView.builder(
      
      padding: const EdgeInsets.all(5.0),
      itemCount: _suggestions.length*2,
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/
        final index = i ~/ 2; /*3*/

        if(_suggestions.length > 0){
          return _buildRow(index);
        } else {
          return new Text("such empty");
        }
      })
    );
  }

  Widget _buildRow(int index ) {
    KailActivity kailActivity = _suggestions[index];
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.start,
        
        children: [
          Container(
            width: 50.0,
            child : ActivityTypeConstants.getIconforActivityType(kailActivity.activityType),
          ),
          Container(
            width: 250.0,
            child : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kailActivity.name.padRight(30) ,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                ),
                Text(
                  TimeUtils.getNextOccurenceString(kailActivity),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                ),
              ]
            ),
          ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children : [
                    IconButton(icon: Icon(Icons.edit), color: Colors.white, onPressed: () => _addKailActivity(kailActivity)),
                    IconButton(icon: Icon(Icons.delete_forever,color: Colors.white,), 
                      onPressed: () => deleteActivity(index,kailActivity)),
                  ]
            )
        ]
      ),
        // )
    );
  }

  void deleteActivity(int index,KailActivity kailActivity) {
    KailActivityService()
      .deleteScheduledActivity(kailActivity)
      .then((value) => {
        setState(() {
        _suggestions..removeAt(index);
        build(context);
        })
      } );
     
  }

  void _pushSaved(){

  }

  void _addKailActivity(KailActivity  kailActivity) {
    Navigator.of(context).push(
      MaterialPageRoute<int>(
        builder: (context) {
          return AddKailActivity(kailActivity);
        }
      )
    ).then((value) => {
      setState(() {
        build(context);
      })
    });
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
