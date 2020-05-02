import 'dart:collection';

class KailSchedule{
  int id;
  int day;
  int hour;
  int minute;
  int notificationID;

  KailSchedule() {
    this.day = 0;
    this.hour = 0;
    this.minute = 0;
  }

  KailSchedule.from3(int _day,int _hour, int _minute){
    this.day = _day;
    this.hour = _hour;
    this.minute = _minute;
  }
}