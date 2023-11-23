import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'dart:math' as math;

class ExSliderSwitcher extends StatefulWidget {
  const ExSliderSwitcher({super.key});

  @override
  State<ExSliderSwitcher> createState() => _ExSliderSwitcherState();
}

class _ExSliderSwitcherState extends State<ExSliderSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Slider Switch"),
      ),
      body: Column(
        children: [
          ///这个组件的脸优点是可以定义开关状态的组件，但是滑动条只能是颜色，不能是组件
          SlideSwitcher(
            containerHeight: 50,
            containerWight: 200,
            onSelect: (value){
            },
            children:const [
              Text("Open"),
              Text("Close"),],),
           const SizedBox(height: 16.0,),
           ///可以垂直显示，但是滑动条无法垂直滑动
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
          // const AdvancedSwitch(
          //   activeChild: Icon(Icons.add),
          //   inactiveChild: Icon(Icons.abc),
          //   thumb: Icon(Icons.hail),
          // ),
          const SizedBox(height: 16.0,),
          Transform.rotate(angle: math.pi/2,
            ///如何调整大小？
            child: SizedBox(
              child: Switch(
                value: true,
                onChanged: (value){},
                thumbIcon:MaterialStatePropertyAll<Icon>(Icon(Icons.headset_mic),),
              ),
            ),
          ),
          const SizedBox(height: 16.0,),
          Container(
            transform: Matrix4.rotationZ(30),
            transformAlignment:Alignment.center ,
            child: Switch(value: true,onChanged: (value){},),
          )
        ],
      ),
    );
  }
}
