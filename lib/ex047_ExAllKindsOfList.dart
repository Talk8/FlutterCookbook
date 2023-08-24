import 'package:flutter/material.dart';

///与123章回匹配，radioList内容可以参考44章回
class ExAllKindsOfList extends StatefulWidget {
  const ExAllKindsOfList({Key? key}) : super(key: key);

  @override
  State<ExAllKindsOfList> createState() => _ExAllKindsOfListState();
}

class _ExAllKindsOfListState extends State<ExAllKindsOfList> {
  final List<int> _radioListValue = List.generate(3, (index) => index + 1);
  var _groupValue = 1;
  var _checkState = 1;

  ///创建编译时的值需要static,如果是编译时常量需要static const
  ///这里不加static会导致编译出错，因为组件无法在编译时知道初始值是什么。
  static int listSize = 3;
  static final List<bool?> _checkBoxState = List.generate(listSize, (index) => false);
  static final List<bool> _switchState = List.generate(listSize, (index) => false);

  RadioListTile _radioListTile(index) {
    _checkState = index;
    return RadioListTile(
      ///在radio右侧显示标题
      title: Text("This is item: $index"),

      ///控制radio被选择时的颜色
      activeColor: Colors.green,
      value: _checkState,
      ///控制是否被选择
      groupValue: _groupValue,

      ///属性值为true时title颜色为ActiveColor,否则为默认值
      selected: (_groupValue == _checkState),
      onChanged: (v) {
        ///v的值就是index，与_radioListValue中的值相对应
        debugPrint("value of list $v");
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

  ///通过_checkBoxState数组管理复选框是否选中的状态值
  CheckboxListTile _checkBoxListTile(index) {
    return CheckboxListTile(
      ///在checkBox左侧显示标题
      title: Text("This is item: $index"),

      ///相当于整个title的背景颜
      tileColor: Colors.blue,

      ///控制checkbox被选中时的颜色
      activeColor: Colors.green,

      ///true表示选中false表示未选中
      value: _checkBoxState[index],
      onChanged: (v) {
        //v的值就是index
        debugPrint("value of list $v");
        setState(
          () {
            _checkBoxState[index] = v;
          },
        );
      },
    );
  }

  ///通过_switchState数组管理单个开关是否选中的状态值
  SwitchListTile _switchListTile(index) {
    return SwitchListTile(
      ///在switch左侧显示标题
      title: Text("This is item: $index"),
      ///控制switch的颜色
      activeColor: Colors.green,
      ///用来控制title中文字被选中时的颜色
      selected: _switchState[index],
      value: _switchState[index],
      ///点击switch或者它前面的文字时都会回调此方法
      onChanged: (v) {
        ///v的值就是index
        debugPrint("value of list $v");
        setState(
          () {
            _switchState[index] = v;
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: listSize,
            itemBuilder: (context,index){
              return _switchListTile(index);
            }),
          ListView(
            shrinkWrap: true,
            children: [
              _radioListTile(_radioListValue[0]),
              _radioListTile(_radioListValue[1]),
              _radioListTile(_radioListValue[2]),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: listSize,
            itemBuilder: (context, index) {
              return _checkBoxListTile(index);
            },
          ),
        ],
      ),
    );
  }
}
