import 'package:flutter/material.dart';

class ExCheckbox extends StatefulWidget {
  const ExCheckbox({Key? key}) : super(key: key);

  @override
  State<ExCheckbox> createState() => _ExCheckboxState();
}

class _ExCheckboxState extends State<ExCheckbox> {
  var _checkState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Checkbox and Transform"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        alignment: Alignment.topRight,
        color: Colors.blueGrey,
        width: 300,
        height: 300,
        //checkbox无法修改大小，通过Transform来修改它的大小
        child: Transform.scale(
          scale: 1.6,
          child: Checkbox(
            //是否选中的状态
            value: _checkState,
            //对号周围的颜色，默认是蓝色
            activeColor: Colors.deepPurpleAccent,
            //对号的颜色，默认是白色
            checkColor: Colors.amber,
            hoverColor: Colors.greenAccent,
            //shape只能修改形状，边框粗细和颜色没有效果，需要配置side属性才能修改边框粗细颜色
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.greenAccent,
                width: 3,
              ),
            ),
            side: const BorderSide(
              color: Colors.greenAccent,
              width: 2,
            ),
            //选择时的回调方法，通过修改状态值来切换选择/非选择状态
            onChanged: (value) {
              setState(() {
                if (_checkState) {
                  _checkState = false;
                } else {
                  _checkState = true;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
