package com.cookbook.flutter.fluttercookbook

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Build.VERSION_CODES
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // 1.创建channel
    private val channel = "www.acf.com/battery"
    //重写方法来设置chanel监听器，用来监听channel中的方法
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //2.通过方法中的flutterEngine获取MethodChannel对象
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel)

        //3. 设置监听器用来监听channel中的方法，就是flutter代码中的invokeMethod()方法调用的方法
        methodChannel.setMethodCallHandler { call, result ->
            //判断是否是获取电量的方法，不是则返回错误,返回内容通过监听器中的result参数返回
            if(call.method == "getBattery") {
                val battery = getBattery()
                if(battery == -1) {
                    result.error("300","unKnowError",null)
                }else {
                    result.success(battery)
                }
            }else {
                result.notImplemented()
            }
        }
    }

    private fun getBattery(): Int {
        var res = 0
        if(Build.VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            res = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(
                Intent.ACTION_BATTERY_CHANGED))
        }
        return res;
        //测试数据
//        return  20;
    }

}
