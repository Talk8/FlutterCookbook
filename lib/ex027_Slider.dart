import 'dart:math';

import 'package:flutter/material.dart';

class ExSlider extends StatefulWidget {
  const ExSlider({Key? key}) : super(key: key);

  @override
  State<ExSlider> createState() => _ExSliderState();
}

class _ExSliderState extends State<ExSlider> {
  double _slideValue = 0.2;
  Widget _slider() {
    return Slider(
      //指定滑动值的范围，如果不指定，默认值的范围在0.0 - 1.0之间
      min: 0.0,
      max: 10.0,
      //步进值
      divisions: 10,
      //设定当前值
      value: _slideValue,
      //用来显示当前的滑动值,文字位于滑块上方
      label: "Value is: ${_slideValue.toInt()}",
      //使用text修改label中的文字没有效果,如何修改label中的文字样式？
      // label: Text(
      //   "Value is: ${_slideValue.toInt()}",
      //   style: TextStyle(
      //     color: Colors.purpleAccent,
      //     backgroundColor: Colors.lightBlue,
      //     fontSize: 24,
      //   ),
      // ).toString(),
      //变化时回调，在回调中修改slider当前显示的值
      onChanged: (value) {
        setState(() {
          _slideValue = value;
          debugPrint("value = $value");
        });
      },
      activeColor: Colors.purpleAccent,
      inactiveColor: Colors.green,
    );
  }

  RangeValues rangeSliderValue = const RangeValues(1, 13);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Slider Widget'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [ Slider(
          //指定滑动值的范围，如果不指定，默认值的范围在0.0 - 1.0之间
          min: 0.0,
          max: 10.0,
          //步进值
          divisions: 10,
          //设定当前值
          value: _slideValue,
          //用来显示当前的滑动值,文字位于滑块上方
          //使用text修改label中的文字没有效果
          label: "Value is: ${_slideValue.toInt()}",
          //变化时回调，在回调中修改slider当前显示的值
          onChanged: (value) {
            setState(() {
              _slideValue = value;
              debugPrint("value = $value");
            });
          },
          activeColor: Colors.purpleAccent,
          inactiveColor: Colors.green,
        ),
        //把slider放在容器中，并且设置容器的宽度和高度，宽度和高度值保持不同，
        // 在每列中添加一个文本控件，对比文本控件和容器之间的距离就能看出来
        //transform组件没有旋转布局，
        const Text("start widget"),
        // RotatedBox(
        //   quarterTurns: 1,
        //   child: Container(
        //     color: Colors.blue,
        //     width: 300,
        //     height:200,
        //     child: _slider(),
        //   ),
        // ),
        const Text("end widget"),
        Transform.rotate(
          //通过指定的弧度进行旋转
          angle: pi / 2,
          // child: _slider(),
          child: Container(
            color: Colors.yellowAccent,
            width: 100,
            height: 300,
            child: _slider(),
          ),
        ),
        const Text("end text"),
        //通过Theme组件修改label中的背景和颜色
        SliderTheme(
            data:const SliderThemeData(
              valueIndicatorColor: Colors.white,
                valueIndicatorTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                ),
            ),
            child: _slider(),
        ),
            ///双向滑动的slider，可以控制一个范围
            RangeSlider(
              ///最大小值
              min: 0,
              max: 15,
              ///不给这个属性赋值，就不会显示label
              divisions: 15,
              ///label有两个：开始和结束。loble的主题可以像上一个slider一样使用SliderTheme
              labels: RangeLabels(rangeSliderValue.start.toString(),rangeSliderValue.end.toString()),
              values: rangeSliderValue,
              ///修改滑动条的颜色，
              activeColor: Colors.orange,
              inactiveColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  rangeSliderValue = value;
                });
                debugPrint(value.toString());
              },
            ),
      ],
      ),
    );
  }
}
