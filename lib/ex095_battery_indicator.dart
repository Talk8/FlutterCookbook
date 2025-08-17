import 'package:flutter/material.dart';
import 'package:realtime_battery_indicator/realtime_battery_indicator.dart';
// import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart'as cup_battery;

class Ex095BatteryIndicator extends StatefulWidget {
  const Ex095BatteryIndicator({super.key});

  @override
  State<Ex095BatteryIndicator> createState() => _Ex095BatteryIndicatorState();
}

class _Ex095BatteryIndicatorState extends State<Ex095BatteryIndicator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of BatteryIndicator"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          ///这个三方组件显示一个水平的电池图标，图标在右侧，电量的文字在左侧，它显示的是当前
          ///手机上的电量，从原理上看，它通过battery_plus这个插件来获取手机上的电量
          ///这个组件的功能就是用来显示手机上的电池量，不过没有自定义电量显示外观的属性，比如电量颜色,圆角角度
          const BatteryIndicator(
            showBatteryLevel: true, ///是否显示电量文字，文字在图标左侧显示
            textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ///这个时间是电量从0到当前值动画的时间
            duration: Duration(milliseconds: 200),
          ),
          ///这个组件也是realtime_battery_indicator插件包中的组件，上面的组件基于这个组件来实现
          const DefaultBatteryIndicator(
            status: DefaultBatteryStatus(value: 30,type:DefaultBatteryStatusType.normal),
            // curve: Curves.bounceOut,
            curve: Curves.easeInOutCirc,
          ),
          ///通过上面的两个示例总结出：realtime_battery_indicator这个插件适合用来显示当前手机的电量，
          ///它的自定义属性比较少，如果想显示非手机的电量，需要用Default这个插件，该插件包最大的缺点是文字在电量左侧显示，而不是在中间显示
          ///看了下源代码，发现是文字和图标是通过Row来布局的，因此无法修改文字的位置。注意：这个插件依赖了battery_plus和upower包，改动较大
          SizedBox(height: 64,),
          ///cupertino_battery_indicator这个插件提供的组件自定义的可能性高，不过由于Flutter版本低于3.27不能通过编译以后升级Flutter后再使用此插件
          ///通过github中上的分析：https://github.com/flutter/flutter/issues/160163
          /*
          cup_battery.BatteryIndicator(
            value: 3.0,
            // barColor: Colors.black,
            // trackColor: Colors.green,
            // trackBorderColor: Colors.white,
          ),
           */

        ],
      ),
    );
  }
}
