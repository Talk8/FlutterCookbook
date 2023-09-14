import 'package:flutter/material.dart';

//这个第三中Column和Row的配套代码,同时也包含了第四回中Contain的代码
class ExColumnRow extends StatelessWidget {
  const ExColumnRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Column and Row Example",
        ),
      ),
      body: Container(
        width: 900,
        height: 100,
        //控制容器内成员的对齐方式，有系统提供的默认值，比如center,也可以自定义
        alignment: Alignment.center,
        // alignment: Alignment(0.3,-0.6),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(20),
        transform: Matrix4.rotationZ(0.0),
        // transformAlignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: Colors.green[300],
            border: Border.all(color: Colors.red, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: const Row(
          ///主轴对齐方式，cross表示与主轴垂直方向的对齐方式
          /// spaceBetween 靠近start/end的间距为0，其它组件之间的边距平分
          /// spaceAround 靠近start/end的间距为其它组件间距的一半，其它组件之间的边距平分
          /// spaceEvenly 所有组件之间的边距平分
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          ///用来控制每个组件的大小，默认是不max表示组件占用row中最大空间，类似android中的match_parent,
          ///可以修改成min,表示依据组件占用row中空间包裹自己就可以，类似android中的wrap_content
          ///交叉轴cross默认情况下，组件占用空间包裹自己就可以,可以修改crossAxisAlignment的属性值为stretch
          ///这样交叉轴上的组件就会占用最大空间,类似android中的match_parent,
          mainAxisSize: MainAxisSize.max,
          children: [
            ///expanded会自动扩展或者伸缩，如果屏幕上有扩展空间就扩展，没有扩展空间就收缩，可以通过flex控制伸缩或者扩展比例
            ///flex就类似于android中的weight，表示比重
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.chat),
                  Text("Contact"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.contacts),
                  Text("WeChat"),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Icon(Icons.shutter_speed),
                Text("Around"),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Icon(Icons.person),
                Text("My self"),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
