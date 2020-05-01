import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityTypeConstants{
  static final String REST = "REST";
  static final String MUSIC = "MUSIC";
  static final String FITNESS = "FITNESS";
  static final String FOOD = "FOOD";
  static final String FAMILY = "FAMILY";
  static final String CALL = "CALL";
  static final String GAMES = "GAMES";
  static final String READING = "READING";
  static final Map<String,Icon> _activity_icon_map = {
    REST : Icon(Icons.battery_alert,color: Colors.white),
    MUSIC : Icon(Icons.library_music,color: Colors.white),
    FITNESS : Icon(Icons.fitness_center,color: Colors.white),
    FOOD : Icon(Icons.restaurant,color: Colors.white),
    FAMILY : Icon(Icons.people,color: Colors.white),
    CALL : Icon(Icons.call,color: Colors.white),
    GAMES : Icon(Icons.videogame_asset,color: Colors.white),
    READING : Icon(Icons.book,color: Colors.white),
  };

  static getIconforActivityType(String activity_type){
    return _activity_icon_map[activity_type];
  }
}