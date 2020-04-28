import 'dart:collection';

class KailSchedule{
  Set<int> days;
  int hour;
  int minute;

  KailSchedule() {
    this.days = new HashSet();
    this.hour = 0;
    this.minute = 0;
  }
}