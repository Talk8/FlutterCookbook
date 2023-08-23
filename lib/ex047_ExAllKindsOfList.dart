import 'package:flutter/material.dart';

class ExAllKindsOfList extends StatefulWidget {
  const ExAllKindsOfList({Key? key}) : super(key: key);

  @override
  State<ExAllKindsOfList> createState() => _ExAllKindsOfListState();
}

class _ExAllKindsOfListState extends State<ExAllKindsOfList> {
  final List<int> _radioListValue = List.generate(3, (index) => index + 1);
  var _groupValue = 1;
  var _checkState = 1;
  bool? _checkBoxState = false;
  bool _switchState = false;


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

  ///是否选中状态需要单独管理，现在是所有组件使用一个状态值
  CheckboxListTile _checkBoxListTile(index) {
    _checkState = index;
    return CheckboxListTile(
      //在checkBox左侧显示标题
      title: Text("This is item: $index"),
      //控制radio和title的颜色
      activeColor: Colors.green,
      value: _checkBoxState,
      onChanged: (v) {
        //v的值就是index
        print("value of list $v");
        setState(
          () {
            _checkBoxState = v;
            // if (_checkBoxState ?? false) {
            //   _checkBoxState = false;
            // } else {
            //   _checkBoxState = true;
            // }
          },
        );
      },
    );
  }

  ///开关状态需要单独管理，现在是所有组件使用一个状态值
  SwitchListTile _switchListTile(index) {
    _checkState = index;
    return SwitchListTile(
      //在switch左侧显示标题
      title: Text("This is item: $index"),
      //控制radio和title的颜色
      activeColor: Colors.green,
      value: _switchState,
      //属性值为true时title颜色为ActiveColor,否则为默认值
      // selected: (_groupValue == _checkState),
      onChanged: (v) {
        //v的值就是index
        print("value of list $v");
        setState(
          () {
            _switchState = v;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of All kinds of list'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              _radioListTile(_radioListValue[0]),
              _radioListTile(_radioListValue[1]),
              _radioListTile(_radioListValue[2]),
              _checkBoxListTile(0),
              _checkBoxListTile(0),
              _checkBoxListTile(0),
              _switchListTile(0),
              _switchListTile(1),
              _switchListTile(2),
            ],
          )
        ],
      ),
    );
  }
}
