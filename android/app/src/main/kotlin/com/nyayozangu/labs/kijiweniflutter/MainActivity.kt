package com.nyayozangu.labs.kijiweniflutter

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowManager
import android.view.ViewTreeObserver



class MainActivity(): FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    //make transparent status bar
    getWindow().setStatusBarColor(0x00000000);
    GeneratedPluginRegistrant.registerWith(this)
    //Remove full screen flag after load
    val vto = getFlutterView().getViewTreeObserver()
    vto.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
      override fun onGlobalLayout() {
        getFlutterView().getViewTreeObserver().removeOnGlobalLayoutListener(this)
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
      }
    })
  }
}
