import 'package:kail/kail_schedule.dart';

class KailActivity{
  String name;
  KailSchedule schedule;
  String nextOccurence;
  String activity_type;

  KailActivity(){
    
  }
  
  KailActivity.from3(String _name,String _nextOccurence, String _activity_type){
    this.name = _name;
    this.nextOccurence = _nextOccurence;
    this.activity_type = _activity_type;
  }
}