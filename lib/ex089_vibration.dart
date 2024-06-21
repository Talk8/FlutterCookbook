import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ExVibrate extends StatefulWidget {
  const ExVibrate({super.key});

  @override
  State<ExVibrate> createState() => _ExVibrateState();
}

class _ExVibrateState extends State<ExVibrate> {
  @override
  void initState() {
    // TODO: implement initState
    ///检查是否有振动的权限,使用前先检查是否有此功能，再调用功能，可以封装成一个独立的函数
    Future.delayed(const Duration(seconds: 1), () async {
      if(await Vibration.hasVibrator() ?? false) {
        debugPrint("has vibrator");
      } else {
        debugPrint("has not vibrator");
      }

      ///检查是否可以调整振幅
      if(await Vibration.hasAmplitudeControl() ?? false) {
        debugPrint("has amplitude");
      } else {
        debugPrint("has not amplitude");
      }

      ///检查是否可以自定义振动
      if(await Vibration.hasCustomVibrationsSupport() ?? false) {
        debugPrint("has custom Vibration ");
      } else {
        debugPrint("has not custom Vibration ");
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: const Text("Example of Vibration"),
     ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Vibration.vibrate(duration: 500);
            },
            child: const Text("Vibration Default"),
          ),

          TextButton(
            onPressed: () {
            ///duration用来控制振动时间，默认500ms,amplitude表示振幅,intensities表示振动强度，最大255
            ///振动时间有变化可以感觉到，其它两个值修改后效果不明显，估计需要专门设备来测试
              ///不过我的设备不支持调整振幅：amplitude
            Vibration.vibrate(duration: 200,amplitude: 20,intensities: [10-20]);
          },
            child: const Text("Vibration Custom"),
          ),

          TextButton(
            onPressed: () {
              ///pattern用来设置振动频率，可以连接振动（等待1s，振动200ms,再等待2s,振动500ms).
              Vibration.vibrate(pattern: [1000,200,2000,500],intensities: [10-20]);
            },
            child: const Text("Vibration Custom More"),
          )
        ],
      ),
    );
  }
}
