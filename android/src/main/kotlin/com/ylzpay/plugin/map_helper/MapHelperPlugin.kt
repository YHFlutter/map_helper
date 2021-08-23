package com.ylzpay.plugin.map_helper

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import com.blankj.utilcode.util.GsonUtils
import com.ylzpay.plugin.map_helper.entity.NavigationParam

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MapHelperPlugin */
class MapHelperPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var activity : Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "map_helper")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "openMap") {

      val navigationParam: NavigationParam? = GsonUtils.fromJson(call.arguments.toString(), NavigationParam::class.java)
      if (navigationParam != null) {
        goToWebMapNavi(
          context = this.activity,
          keyword = navigationParam.address,
          lat = navigationParam.lat,
          lng = navigationParam.lng)
      }
      result.success("success")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  /**
   * 启动网页地图进行导航
   */
  private fun goToWebMapNavi(context: Context, keyword: String?, lat: String?, lng: String?) {
    val url = "http://api.map.baidu.com/place/search?query=${keyword}&location=${lat},${lng}&radius=1000&region=&output=html&src=ylz"
    val intent = Intent()
    intent.action = "android.intent.action.VIEW"
    intent.data = Uri.parse(url)
    context.startActivity(intent)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

}
