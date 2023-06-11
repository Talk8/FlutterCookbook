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
        height: 300,
        //控制容器内成员的对齐方式，有系统提供的默认值，比如center,也可以自定义
        alignment: Alignment.center,
        // alignment: Alignment(0.3,-0.6),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        transform: Matrix4.rotationZ(0.0),
        // transformAlignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: Colors.green[300],
            border: Border.all(color: Colors.red, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: const Row(
          //主轴对齐方式，cross表示与主轴垂直方向的对齐方式
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: const [
                  Icon(Icons.chat),
                  Text("Contact"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: const [
                  Icon(Icons.contacts),
                  Text("WeChat"),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: const [
                Icon(Icons.shutter_speed),
                Text("Around"),
              ],
            )),
            Expanded(
                child: Column(
              children: const [
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
