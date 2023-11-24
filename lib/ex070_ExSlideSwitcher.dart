import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:day_night_switch/day_night_switch.dart';
import 'dart:math' as math;

class ExSliderSwitcher extends StatefulWidget {
  const ExSliderSwitcher({super.key});

  @override
  State<ExSliderSwitcher> createState() => _ExSliderSwitcherState();
}

class _ExSliderSwitcherState extends State<ExSliderSwitcher> {
  final mController = ValueNotifier<bool>(true);
  var checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mController.addListener(() {
      setState(() {
        if(mController.value) {
          debugPrint("true");
        }else{
          debugPrint("false");
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Example of Slider Switch"),
      ),
      body: Column(
        children: [
          ///这个组件的优点是可以自定义开关状态的组件，但是滑动条只能是颜色，不能是组件
          SlideSwitcher(
            containerHeight: 50,
            containerWight: 200,
            slidersColors: [Colors.green],
            containerColor: Colors.redAccent,
            onSelect: (value){
            },
            children:const [
              // Image(image: AssetImage("images/pickdown.png"),),
              // Image(image: AssetImage("images/pickup.png"),),
              Text("Open"),
              Text("Close"),
            ],),
           const SizedBox(height: 16.0,),
           ///可以垂直显示，而且可以修改开关状态下的图片，不过无法修改thumb的形状
           SlideSwitcher(
            containerHeight: 200,
            containerWight: 60,
            direction: Axis.vertical,
            onSelect: (value){
            },
            children:const [
              Icon(Icons.keyboard_arrow_up),
              Icon(Icons.keyboard_arrow_down),],
           ),
          const SizedBox(height: 16.0,),

          ///无法垂直显示，但是可以修改开关状态下的图片和thumb的图片
          ///需要配合controller使用，不然无法显示开关状态,还有一个缺点，开关无法滑动使用，只能点击开和关位置，自动滑动。
          const AdvancedSwitch(
            width: 120,
            height: 60,
            // activeChild: Icon(Icons.arrow_left),
            // inactiveChild: Icon(Icons.arrow_right),
            // thumb: Icon(Icons.face),
            enabled: true,
          ),
          const SizedBox(height: 16.0,),

          AdvancedSwitch(
            width: 120,
            controller: mController,
            activeImage: AssetImage("images/pickdown.png"),
            inactiveImage: AssetImage("images/pickup.png"),
          ),
          const SizedBox(height: 16.0,),

          Transform.rotate(angle: math.pi/2,
            ///在外层嵌套一个容器后仍然无法调整switch的大小
            ///默认的switch无法垂直显示，可以修改开关状态下的图片和thumb的图片
            child: SizedBox(
              width: 100,
              height: 60,
              child: Switch(
                value: true,
                onChanged: (value){},
                activeThumbImage: const AssetImage("images/panda.jpeg"),
                inactiveThumbImage: const AssetImage("images/ex.png"),
                thumbIcon:const MaterialStatePropertyAll<Icon>(Icon(Icons.headset_mic),),
              ),
            ),
          ),
          const SizedBox(height: 16.0,),
          Container(
            transform: Matrix4.rotationZ(30),
            transformAlignment:Alignment.center ,
            child: Switch(value: true,onChanged: (value){},),
          ),

          ///无法垂直显示，但是可以修改开关状态下的图片，thumb的图片和开关的图片保持一致，类似advanceSwitch
          ///不过不需要配合controller使用，还有一个缺点，开关无法滑动使用，只能点击开和关位置，自动滑动。
          FlutterSwitch(value:checked, onToggle: (value){
            setState(() {
              checked = value;
            });
          },
            inactiveIcon: Icon(Icons.arrow_left),
            activeIcon: Icon(Icons.arrow_right),
            width: 120,
            height: 50,
          ),
          ///主题和颜色比较FlutterSwitch好看，功能差不多，好处是可以滑动开关，不再是点击来切换形状
          ///上面使用的所有switch都是把图片放在了thumb上，切换开关时切换图片，只有AdvancedSwitch是把图片放在track上，
          ///滑动开关时切换track，不过thumb不能被修改
          DayNightSwitch(
            sunImage: AssetImage("images/pickdown.png"),
            moonImage: AssetImage("images/pickup.png"),
            value: checked,
            onChanged: (value){
            setState(() {
              checked = value;
            });
            },
          ),

        ],
      ),
    );
  }
}
