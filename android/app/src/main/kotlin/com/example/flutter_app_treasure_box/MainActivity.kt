package com.example.flutter_app_treasure_box

import android.annotation.SuppressLint
import android.hardware.Camera
import android.os.Bundle
import android.widget.Toast

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL_FLASH = "flutter.io/flash"

    var flashlight: FlashlightUtils? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        flashlight = FlashlightUtils()

        // 直接 new MethodChannel，然后设置一个Callback来处理Flutter端调用
        MethodChannel(flutterView, CHANNEL_FLASH).setMethodCallHandler { call, result ->
            when {
                call?.method.equals("turnOnFlash") -> flashlight?.lightsOn(this)
                call?.method.equals("turnOffFlash") -> flashlight?.lightsOff()
                else -> result?.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        flashlight?.lightsOff()
    }

    
}
