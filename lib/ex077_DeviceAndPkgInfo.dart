import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

///与199-204中的内容相匹配
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

    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Device and Package Info"),
        backgroundColor: Colors.purpleAccent,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(pkgInfo),
          ///获取包信息:介绍package_info_plus包
          ElevatedButton(
            onPressed: () => getPackageInfo(),
            child: const Text("Show Pkg Info"),
          ),
          Text(deviceInfo),
          ///获取设备信息:介绍device_info_plus包
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

          ///可以弹出复杂窗口，窗口可以自定义，不过风格不能修改，比如文字颜色大小
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
          ///与203修改组件风格内容匹配
          Theme(
            data: themeData.copyWith(
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.purpleAccent),
                displayMedium: TextStyle(color: Colors.blue),
                displaySmall: TextStyle(color: Colors.greenAccent),
                titleLarge: TextStyle(color: Colors.purpleAccent),
                titleMedium: TextStyle(color: Colors.purpleAccent),
                titleSmall: TextStyle(color: Colors.purpleAccent),
              ),
              textButtonTheme: TextButtonThemeData(
               style: TextButton.styleFrom(foregroundColor: Colors.greenAccent,textStyle: const TextStyle(color: Colors.redAccent,),),
              ),
              dialogBackgroundColor: Colors.redAccent,
              ///只有这个起作用，其它的都不起作用，估计嵌套导致的
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style:ElevatedButton.styleFrom(foregroundColor: Colors.redAccent,), ),
              dialogTheme: const DialogTheme(
                backgroundColor: Colors.redAccent,
                contentTextStyle: TextStyle(color: Colors.redAccent,),
              ),
              primaryColor: Colors.greenAccent,

            ),
            child: ElevatedButton(
              onPressed: (){
                BluetoothEnable.customBluetoothRequest(
                    context, dialogTitle,
                    true, dialogContent,
                    cancelBtnText, acceptBtnText,
                    dialogRadius, barrierDismissible);
              },
              child: const Text("Open BT by Dialog"),
            ),
          ),

          ///使用页面模拟一个对话框窗口，主要用来打开蓝牙开关，与204内容匹配
          ElevatedButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return showCustomDialog();
                })
              );

            },
            child: const Text("Custom Dialog"),
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


    ///获取屏幕尺寸和倍率
    String size= androidDeviceInfo.displayMetrics.sizeInches.toStringAsFixed(2);
    String width = androidDeviceInfo.displayMetrics.widthPx.toString();
    String height = androidDeviceInfo.displayMetrics.heightPx.toString();
    ///获取sdk版本号
    String sdkVersion = androidDeviceInfo.version.sdkInt.toString();
    debugPrint("device info: $result, display: $width");
    debugPrint(" display: $size resolution: ($width x $height)");
    debugPrint("device info version : $sdkVersion");

    ///把相关信息整理成自己需要的格式
    result = " br size:$size ($width*$height),Android$sdkVersion";
    debugPrint("device info : $result");
    ///从androidDeviceInfo中可以得到以下关键信息，也可以像上面一样单独获取这些信息
    // widthPx: 1080.0, heightPx: 2460  sdkInt: 33

    if(defaultTargetPlatform == TargetPlatform.android) {
    }
    return result;
  }

  ///获取当前app的版本信息
  void getPackageInfo() async {
    var pkgInfo = await PackageInfo.fromPlatform();
    debugPrint("package info: ${pkgInfo.toString()}");

    String version = pkgInfo.version;
    debugPrint("package info version: $version");
    ///打印出的信息如下：
    ///appName: fluttercookbook, buildNumber: 1, packageName: com.cookbook.flutter.fluttercookbook, version: 1.0.0
  }

  ///使用页面模拟一个对话框窗口，主要用来打开蓝牙开关，与204内容匹配
  Widget showCustomDialog() {
    return Scaffold(
      ///对话框的背景
      body: Container(
        color: Colors.black26,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        ///对话框的背景
        child: Container(
          width: 272,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          ///三行内容：标题行，内容行，按钮行
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ///这个空间可以用来存放标题
              const SizedBox(height: 16,),
              const Text("Message of Dialog"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    ///点击Yes跳转到蓝牙开关设置页面，这个是手机上默认的设置页面
                    onPressed: () {OpenSettings.openBluetoothSetting();},
                    child: const Text("Yes",style: TextStyle(color: Colors.black),),
                  ),
                  TextButton(onPressed: () {
                    ///点击No，退出模拟对话框窗口，回到上一级页面
                    Navigator.pop(context);
                  }, child: const Text("No",style: TextStyle(color: Colors.black),),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
