import 'package:kail/kail_schedule.dart';

class KailActivity{
  int id;
  String name;
  List<KailSchedule> schedules;
  String nextOccurence;
  String activityType;

  KailActivity(){
    
  }
  
  KailActivity.from3(String _name,String _nextOccurence, String _activityType){
    this.name = _name;
    this.nextOccurence = _nextOccurence;
    this.activityType = _activityType;
  }
}