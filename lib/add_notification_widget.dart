
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kail/constants/activity_type_constants.dart';
import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';
import 'package:kail/service/kail_activity_service.dart';

class AddKailActivity extends StatefulWidget{
  KailActivity _existingActivity;
  AddKailActivity(KailActivity exisitingActivity){
    this._existingActivity = exisitingActivity;
  }
  @override
  AddKailActivityForm createState() {
    return AddKailActivityForm(this._existingActivity);
  }
}

class AddKailActivityForm extends State<AddKailActivity>{
  KailActivity _existingActivity;
  final _formKey = GlobalKey<FormState>();
  var _kailActivity = new KailActivity();
  var _kailSchedule = new KailSchedule();
  KailActivityService _kailActivityService = new KailActivityService();

  TextEditingController activityNameController = TextEditingController(text: "");
  int _hour = 0;
  int _minute = 0;
  Set<int> _days = new HashSet();
  TimeOfDay pickerTime = TimeOfDay.now();

  var _isSunday = false;
  var _isMonday = false;
  var _isTuesday = false;
  var _isWednesday = false;
  var _isThursday = false;
  var _isFriday = false;
  var _isSaturday = false;

  String _activityType = ActivityTypeConstants.REST;

  AddKailActivityForm(KailActivity existingActivity){
    this._existingActivity = existingActivity;
  }

  void initCheckBoxSelected(KailActivity kailActivity){
    for(KailSchedule schedule in kailActivity.schedules){
      switch(schedule.day){
        case 7 :
          _isSunday=true;
          break;
        case 1 :
          _isMonday=true;
          break;
        case 2 :
          _isTuesday=true;
          break;
        case 3 :
          _isWednesday=true;
          break;
        case 4 :
          _isThursday=true;
          break;
        case 5 :
          _isFriday=true;
          break;
        case 6 :
          _isSaturday=true;
          break;
      }
      this._days.add(schedule.day);
    }
  }

  void initTimePickerTime(KailActivity kailActivity){
    if(kailActivity.schedules.length>0){
      _hour = kailActivity.schedules[0].hour;
      _minute = kailActivity.schedules[0].minute;
      this.pickerTime = new TimeOfDay(
        hour: _hour,
        minute: _minute);
    }

  }

  void initActivityName(KailActivity kailActivity){
    this.activityNameController.text = kailActivity.name;
  }

  void initActivityType(KailActivity kailActivity){
    this._activityType = kailActivity.activityType;
  }

  @override
  void initState() {
      super.initState();
      if(this._existingActivity != null){
        initActivityName(this._existingActivity);
        initActivityType(this._existingActivity);
        initTimePickerTime(this._existingActivity);
        initCheckBoxSelected(this._existingActivity);
        _kailActivity.id = _existingActivity.id;
      }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text('Add new acitvity'),
      ),
      body : Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Activity Name",style:TextStyle(fontSize: 21)),
            TextFormField(
              controller: activityNameController,
              decoration: const InputDecoration(
                hintText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String value) {
                  this._kailActivity.name = value;
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Activity Type",style:TextStyle(fontSize: 21)),getActivityTypeDropDown()],
              ),
            Text("Days",style:TextStyle(fontSize: 21)),
            getDaysCheckbox(_kailSchedule),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_hour.toString().padLeft(2, "0"),style: TextStyle(fontSize: 21)),
                Text(':',style: TextStyle(fontSize: 21)),
                Text(_minute.toString().padLeft(2, "0"),style: TextStyle(fontSize: 21)),          
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('HH',style: TextStyle(fontSize: 21)),
                Text(':',style: TextStyle(fontSize: 21)),
                Text('MM',style: TextStyle(fontSize: 21)),          
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  // if (_formKey.currentState.validate()) {
                  //   // Process data.
                  // }
                    Future<TimeOfDay> selectedTime = showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );
                    selectedTime.then(
                      (timeValue) => setState((){
                        _hour = timeValue.hour;
                        _minute = timeValue.minute;
                      })
                    );
                  // _formKey.currentState;
                },
                child: Text('Pick Time'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  // if (_formKey.currentState.validate()) {
                  //   // Process data.
                  // }
                  if (_formKey.currentState.validate()) {
                    if(_days.isEmpty){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Days not selected"),
                            content: Text("Please select one or more days to schedule"),
                          )
                      );
                    } else {
                      _formKey.currentState.save();
                      _kailActivity.activityType = _activityType;
                      _kailActivity.schedules = new List();
                      for(int day in _days){
                        _kailActivity.schedules.add(
                          KailSchedule.from3(day,_hour,_minute)
                        );
                      }
                      _kailActivityService.saveAndScheduledActivity(_kailActivity)
                      // .timeout(Duration(seconds: 10))
                      .then((value) => {
                          Navigator.pop(context)
                      });
                    }

                  }
                  // _formKey.currentState;
                },
                child: Text('Submit'),
              ),
            ),
            ]
              
            )
            
          ],
        ),
      )
    );

  }

  Widget getDaysCheckbox(KailSchedule _kailSchedule) {
    return 
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text("S")),
          Checkbox(
            value: _isSunday,
            onChanged: (bool newValue) {
              setState(() {
                _isSunday = newValue;
                if(newValue){
                  _days.add(7);
                } else if (_days.contains(7)){
                  _days.remove(7);
                }
              });
            },
          ),
          Expanded(child: Text("M")),
          Checkbox(
            value: _isMonday,
            onChanged: (bool newValue) {
              setState(() {
                _isMonday = newValue;
                if(newValue){
                  _days.add(1);
                } else if (_days.contains(1)){
                  _days.remove(1);
                }
              });
            },
          ),
          Expanded(child: Text("T")),
          Checkbox(
            value: _isTuesday,
            onChanged: (bool newValue) {
              setState(() {
                _isTuesday = newValue;
                if(newValue){
                  _days.add(2);
                } else if (_days.contains(2)){
                  _days.remove(2);
                }
              });
            },
          ),
          Expanded(child: Text("W")),
          Checkbox(
            value: _isWednesday,
            onChanged: (bool newValue) {
              setState(() {
                _isWednesday = newValue;
                if(newValue){
                  _days.add(3);
                } else if (_days.contains(3)){
                  _days.remove(3);
                }
              });
            },
          ),
          Expanded(child: Text("T")),
          Checkbox(
            value: _isThursday,
            onChanged: (bool newValue) {
              setState(() {
                _isThursday = newValue;
                if(newValue){
                  _days.add(4);
                } else if (_days.contains(4)){
                  _days.remove(4);
                }
              });
            },
          ),
          Expanded(child: Text("F")),
          Checkbox(
            value: _isFriday,
            onChanged: (bool newValue) {
              setState(() {
                _isFriday = newValue;
                if(newValue){
                  _days.add(5);
                } else if (_days.contains(5)){
                  _days.remove(5);
                }
              });
            },
          ),
          Expanded(child: Text("S")),
          Checkbox(
            value: _isSaturday,
            onChanged: (bool newValue) {
              setState(() {
                _isSaturday = newValue;
                if(newValue){
                  _days.add(6);
                } else if (_days.contains(6)){
                  _days.remove(6);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget getActivityTypeDropDown(){
    return DropdownButton<String>(
      value: _activityType,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        color: Colors.deepPurple
      ),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          _activityType = newValue;
        });
      },
      items: <String>[
        ActivityTypeConstants.REST,
        ActivityTypeConstants.MUSIC, 
        ActivityTypeConstants.FITNESS, 
        ActivityTypeConstants.FOOD,
        ActivityTypeConstants.FAMILY,
        ActivityTypeConstants.CALL,
        ActivityTypeConstants.GAMES,
        ActivityTypeConstants.READING,
      ]
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        })
        .toList(),
    );
  }

}