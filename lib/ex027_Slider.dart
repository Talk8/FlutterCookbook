import 'package:flutter/material.dart';

class ExSlider extends StatefulWidget {
  const ExSlider({Key? key}) : super(key: key);

  @override
  State<ExSlider> createState() => _ExSliderState();
}

class _ExSliderState extends State<ExSlider> {
  double _slideValue = 0.2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Slider Widget'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Slider(
          //指定滑动值的范围，如果不指定，默认值的范围在0.0 - 1.0之间
          min: 0.0,
          max: 10.0,
          //步进值
          divisions: 10,
          //设定当前值
          value: _slideValue,
          //用来显示当前的滑动值,文字位于滑块上方
            //使用text修改label中的文字没有效果
          label:Text("Value is: ${_slideValue.toInt()}",
          style: TextStyle(
            color: Colors.purpleAccent,
            backgroundColor: Colors.lightBlue,
            fontSize: 24,
          ),).toString(),
          //变化时回调，在回调中修改slider当前显示的值
          onChanged: (value) {
            setState(() {
              _slideValue = value;
              print("value = $value");
            });
          },
          activeColor: Colors.purpleAccent,
          inactiveColor: Colors.green,
          ),
        ]
      ),
    );
  }
}
