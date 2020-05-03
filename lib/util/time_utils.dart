import 'package:kail/kail_activity.dart';
import 'package:kail/kail_schedule.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimeUtils {
  static String getNextOccurenceString(KailActivity kailActivity){
    var currDate = DateTime.now();
    int weekMinutes = 7*24*60;
    int currMinuteDiff = (currDate.weekday-1)*24*60 + currDate.hour*60+currDate.minute;
    int leastMinuteDiff = 9223372036854775807;
    // Assume Monday 00:00 is the begining of each week
    for(KailSchedule schedule in kailActivity.schedules){
      int scheduleMinuteDiff = 
      (schedule.day - 1)*24*60
      + (schedule.hour)*60
      + schedule.minute;
      int scheduleCurrMinuteDiff = scheduleMinuteDiff - currMinuteDiff;
      if(scheduleCurrMinuteDiff<0){
        scheduleCurrMinuteDiff += weekMinutes;
      }

      if(scheduleCurrMinuteDiff < leastMinuteDiff){
        leastMinuteDiff = scheduleCurrMinuteDiff;
      }
    }

    var nextOccurenceDate = currDate.add(Duration(minutes: leastMinuteDiff));
    var nextOccurrenceString = 
      nextOccurenceDate.hour.toString().padLeft(2, "0")
      + ":"
      + nextOccurenceDate.minute.toString().padLeft(2, "0")
      + " "
      + DateFormat('EEE').format(nextOccurenceDate).toString();
    return nextOccurrenceString;
  }
}