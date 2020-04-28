import 'package:kail/kail_schedule.dart';

class KailActivity{
  String name;
  KailSchedule schedule;
  String nextOccurence;
  String imageLocation;

  KailActivity(){
    
  }
  
  KailActivity.from3(String _name,String _nextOccurence, String _imageLocation){
    this.name = _name;
    this.nextOccurence = _nextOccurence;
    this.imageLocation = _imageLocation;
  }
}