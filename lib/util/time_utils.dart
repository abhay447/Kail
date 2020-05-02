import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';

class TimeUtils {
  static String getNextOccurenceString(KailActivity kailActivity){
    var curr_date = DateTime.now();
    for(KailSchedule schedule in kailActivity.schedules){
      int date_diff = (schedule.day - curr_date.weekday) % 7;
      int hour_diff = schedule.hour - curr_date.hour;
      if(hour_diff < 0){
        // date_diff
      }
    }
    return "";
  }
}