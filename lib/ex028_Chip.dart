import 'package:flutter/material.dart';

//对应chip和wrap相关的知识
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
      //使用Column当作chip的容器
      // body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      //使用Wrap当作chip的容器
      body: Wrap(
        //控制Wrap中组件的排列方向，默认是水平排列
        // direction: Axis.vertical,
        //用来控制主轴方向上子组件之前的间隔
        // spacing: 206,
        //用来控制纵轴方向上子组件之前的间隔和对齐方式
        // runSpacing: 8,

        //对齐方式不同时尺寸要求也不一样
        direction: Axis.horizontal,
        spacing: 8,
        runSpacing: 19,

        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,

        children: [
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
        Chip(
          label: Text("weather"),
          //修改整个chip的背景颜色
          backgroundColor: Colors.purpleAccent,
          //只添加该属性时显示默认的图标：带x的小圆
          onDeleted: ()=>print('onDelete callback'),
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
