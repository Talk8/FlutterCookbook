import 'package:flutter/material.dart';

class ExRadio extends StatefulWidget {
  const ExRadio({Key? key}) : super(key: key);

  @override
  State<ExRadio> createState() => _ExRadioState();
}

class _ExRadioState extends State<ExRadio> {
  var _checkState = 0;
  var _groupValue = 10;
  var _checkStateStr = "no";
  var _groupValueStr = "groupOne";
  var _selectedState = false;

  Radio _radio(index) {
    _checkState = index;
    return Radio(
      //这两个值相等时才会显示选中状态，这里用的是int类型
      value: _checkState,
      groupValue: _groupValue,
      onChanged: (v) {
        //v的值就是index
        print("value $v");
        setState(
          () {
            if (_checkState == _groupValue) {
              _groupValue = v + 1;
            } else {
              _groupValue = v;
            }
          },
        );
      },
    );
  }

  //索引值是String类型的值也可以
  Radio _radioStr(index) {
    _checkStateStr = index;
    return Radio(
      //这两个值相等时才会显示选中状态，这里用的是string类型
      value: _checkStateStr,
      groupValue: _groupValueStr,
      onChanged: (v) {
        //v的值就是index
        print("value $v");
        setState(
          () {
            if (_checkStateStr == _groupValueStr) {
              _groupValueStr = v + "1";
            } else {
              _groupValueStr = v;
            }
          },
        );
      },
    );
  }

  RadioListTile _radioListTile(index) {
    _checkState = index;
    return RadioListTile(
      //在radio右侧显示标题
      title: Text("This is item: $index"),
      //控制radio和title的颜色
      activeColor: Colors.green,
      value: _checkState,
      groupValue: _groupValue,
      //属性值为true时title颜色为ActiveColor,否则为默认值
      selected: (_groupValue == _checkState),
      onChanged: (v) {
        //v的值就是index
        print("value of list $v");
        setState(
          () {
            if (_checkState == _groupValue) {
              _groupValue = v + 1;
            } else {
              _groupValue = v;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Radio"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _radio(1),
          _radio(2),
          _radio(3),
          _radio(4),
          _radio(5),
          _radioStr("Mon"),
          _radioStr("Tue"),
          _radioStr("Wen"),
          _radioListTile(6),
          _radioListTile(7),
          _radioListTile(8),
          _radioListTile(9),
        ],
      ),
    );
  }
}
