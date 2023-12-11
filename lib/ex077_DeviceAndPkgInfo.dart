import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ExDeviceInfo extends StatefulWidget {
  const ExDeviceInfo({super.key});

  @override
  State<ExDeviceInfo> createState() => _ExDeviceInfoState();
}

class _ExDeviceInfoState extends State<ExDeviceInfo> {
  String pkgInfo = "unKnown";
  String deviceInfo = "unKnown";

  @override
  Widget build(BuildContext context) {

    String dialogTitle ="title";
    String dialogContent = "Pls open bluetooth of phone";
    String cancelBtnText = "No";
    String acceptBtnText = "Yes";
    double dialogRadius = 30;
    bool barrierDismissible = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Device and Package Info"),
        backgroundColor: Colors.purpleAccent,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(pkgInfo),
          ElevatedButton(
            onPressed: () => getPackageInfo(),
            child: const Text("Show Pkg Info"),
          ),
          Text(deviceInfo),
          ElevatedButton(
            onPressed: () {
              getAndroidDeviceInfo();
              ///内容太长了，整个屏幕上都显示不完整
              // setState(() {
              // getAndroidDeviceInfo().then(
              //         (value){ deviceInfo = value;}
              // );
              // });
            },
            child: const Text("Show Device Info"),
          ),
          ///与open_settings包内容匹配
          ElevatedButton(
            onPressed: (){
              OpenSettings.openBluetoothSetting();
            },
            child: const Text("Open BT"),
          ),
          ///使用bluetooth_enable_fork包
          ///只弹出一个简单窗口
          ElevatedButton(
            onPressed: (){
              BluetoothEnable.enableBluetooth.then((value) {
                debugPrint("value is: $value");
              });
            },
            child: const Text("Open BT"),
          ),

          ///可以弹出复杂窗口，窗口可以自定义，不过风格不能修改
          ElevatedButton(

            onPressed: (){
              BluetoothEnable.customBluetoothRequest(
                context, dialogTitle,
                true, dialogContent,
                cancelBtnText, acceptBtnText,
                dialogRadius, barrierDismissible);
            },
            child: const Text("Open BT by Dialog"),
          ),
        ],
      ),
    );
  }

  ///获取手机上的软件和硬件信息
   Future<String> getAndroidDeviceInfo() async {
    String result = "";
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    result = androidDeviceInfo.toString();


    debugPrint("device info: $result");

    ///可以得到以下关键信息
    // widthPx: 1080.0, heightPx: 2460  sdkInt: 33

    return result;
  }

  ///获取当前app的版本信息
  void getPackageInfo() async {
    var pkgInfo = await PackageInfo.fromPlatform();
    debugPrint("package info: ${pkgInfo.toString()}");
    ///打印出的信息如下：
    ///appName: fluttercookbook, buildNumber: 1, packageName: com.cookbook.flutter.fluttercookbook, version: 1.0.0
  }
}
