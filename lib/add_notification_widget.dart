
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kail/dao/kail_dao.dart';
import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';

class AddKailActivity extends StatefulWidget{
  @override
  AddKailActivityForm createState() {
    return AddKailActivityForm();
  }
}

class AddKailActivityForm extends State<AddKailActivity>{
  final _formKey = GlobalKey<FormState>();
  var _kailActivity = new KailActivity();
  var _kailSchedule = new KailSchedule();
  KailDao _kailDao = KailDao();
  String _hour = "00";
  String _min = "00";
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
            Text("Days",style:TextStyle(fontSize: 21)),
            getDaysCheckbox(_kailSchedule),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('$_hour',style: TextStyle(fontSize: 21)),
                Text(':',style: TextStyle(fontSize: 21)),
                Text('$_min',style: TextStyle(fontSize: 21)),          
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
                        _hour = timeValue.hour.toString().padLeft(2, "0");
                        _min = timeValue.minute.toString().padLeft(2, "0");
                        _kailSchedule.hour = timeValue.hour;
                        _kailSchedule.minute = timeValue.minute;
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
                    if(_kailSchedule.days.isEmpty){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Days not selected"),
                            content: Text("Please select one or more days to schedule"),
                          )
                      );
                    } else {
                      _formKey.currentState.save();
                      _kailActivity.schedule = _kailSchedule;
                      Navigator.pop(context);
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

  var _isSunday = false;
  var _isMonday = false;
  var _isTuesday = false;
  var _isWednesday = false;
  var _isThursday = false;
  var _isFriday = false;
  var _isSaturday = false;

  getDaysCheckbox(KailSchedule _kailSchedule) {
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
                  _kailSchedule.days.add(0);
                } else if (_kailSchedule.days.contains(0)){
                  _kailSchedule.days.remove(0);
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
                  _kailSchedule.days.add(1);
                } else if (_kailSchedule.days.contains(1)){
                  _kailSchedule.days.remove(1);
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
                  _kailSchedule.days.add(2);
                } else if (_kailSchedule.days.contains(2)){
                  _kailSchedule.days.remove(2);
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
                  _kailSchedule.days.add(3);
                } else if (_kailSchedule.days.contains(3)){
                  _kailSchedule.days.remove(3);
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
                  _kailSchedule.days.add(4);
                } else if (_kailSchedule.days.contains(4)){
                  _kailSchedule.days.remove(4);
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
                  _kailSchedule.days.add(5);
                } else if (_kailSchedule.days.contains(5)){
                  _kailSchedule.days.remove(5);
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
                  _kailSchedule.days.add(6);
                } else if (_kailSchedule.days.contains(6)){
                  _kailSchedule.days.remove(6);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
