package com.example.kail

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
class MainActivity: FlutterActivity(), PluginRegistrantCallback{
  
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this);
    AlarmService.setPluginRegistrant(this);
  }

  override fun registerWith(registry: PluginRegistry?) {
        //Register sharedPreferences here        
        GeneratedPluginRegistrant.registerWith(registry);
    }
}
