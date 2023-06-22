import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExChip extends StatefulWidget {
  const ExChip({Key? key}) : super(key: key);

  @override
  State<ExChip> createState() => _ExChipState();
}

class _ExChipState extends State<ExChip> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Example of Chip"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Chip(
          label: Text('label'),
          //该属性只有设置onDeleted属性时才起作用，否则看不到图标,图标在尾部和头部相对应
          deleteIcon: Icon(Icons.delete),
          deleteIconColor: Colors.redAccent,
          onDeleted:()=>print('onDeleted callback'),
          //修改label中文字的style
          labelStyle: TextStyle(
            color: Colors.pink,
            fontSize: 21,
            backgroundColor: Colors.grey,
          ),
          //该属性为什么不起作用？
          side: BorderSide(
            color: Colors.black87,
            width: 3.0,
            style: BorderStyle.none,
          ),
        ),
        const Chip(
          label: Text("weather"),
          //修改整个chip的背景颜色
          backgroundColor: Colors.purpleAccent,
        ),
        const Chip(
          label: Text("name"),
          //在label前面添加一个圆形文字或者图标
          avatar: CircleAvatar(
            backgroundColor: Colors.lightBlue,
            child: Text("Avatar"),
          ),
        ),
        const Chip(
          label: Text("name"),
          avatar: CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            child: Text("Avatar"),
            backgroundImage: AssetImage("images/ex.png"),
          ),
        ),
        //All kinds of chip
        InputChip(
          label: Text('input chip'),
          //两个属性不能同时赋值，不然会有运行时错误
          // onPressed: () => print('on pressed'),
          onSelected: (v) => print('on selected'),
        ),
        ChoiceChip(
          label: Text('ChoiceChip'),
          //true时背景颜色比较浅，反之比较深
          selected: true,
        ),
        ActionChip(
          label: Text('Action chip'),
          onPressed: () {
            print('Action chip pressed');
          },
        ),
      ]),
    );
  }
}
