import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      // 1.获取FlutterViewController
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      // 2.通过Controller创建FlutterMethodChannel对象
      let channel = FlutterMethodChannel(name:"www.acf.com/battery", binaryMessenger:controller.binaryMessenger)
      // 3. 设置监听器来监听channel中的方法，就是flutter代码中的invokeMethod()方法调用的方法
      channel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) in
          //判断是否是获取电量的方法，不是则返回错误,返回内容通过监听器中的result参数返回
          guard call.method == "getBattery" else {
              result(FlutterMethodNotImplemented)
              return
          }
          
          //获取电池信息
          let device = UIDevice.current
          device.isBatteryMonitoringEnabled = true
         
          /* 使用真机时打开此代码
          //获取电池电量
          if device.batteryState == UIDevice.BatteryState.unknown {
              result(FlutterError(code: "300", message: "unKnown battery", details: nil))
          }else {
//                  result(Int(device.batteryLevel))
                  result(Int(50))
          }
           */
          //使用模拟器时无法获取到电池信息，直接返回一个数据
          result(Int(50))
      }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
