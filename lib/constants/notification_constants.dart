import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationConstants {
  static final String notification_channel_id = "weekly_notification_channel_id";
  static final String notification_channel_name = "weekly_notification_channel_name";
  static final String notification_channel_desscription = "weekly_notification_channel_description";
  static final Map<int,Day> index_day_map = {
    7:Day.Sunday,
    1:Day.Monday,
    2:Day.Tuesday,
    3:Day.Wednesday,
    4:Day.Thursday,
    5:Day.Friday,
    6:Day.Saturday
  }; 
}