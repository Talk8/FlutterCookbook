import 'package:flutter/material.dart';

//对应21回中的内容
class ExConstrainedBox extends StatelessWidget {
  const ExConstrainedBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of All kinds of Constrained box"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //最小和最大约束，最大不指定默认为无限大，不过不能大过父约束
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 30,
              minWidth: 30,
            ),
            child: const Text("This is the column 1"),
          ),
          //固定大小约束
          const SizedBox(
            width: 300,
            height: 50,
            child: Text("This is the column 2"),
          ),
          //按照比例约束，需要在外面套一个约束才可以运行,不然报运行时错误
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: 100,
            child: const FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.2,
              child: Text("This is the column 3"),
            ),
          ),
          const SizedBox(
            width: 300,
            height: 20,
            child: Text("This is the column 4"),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: const Text("This is the column 5"),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.deepPurple,
              alignment: Alignment.centerRight,
              child: const Text("This is the column 6"),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue,
              alignment: Alignment.center, //对齐会让child组件的宽度从自身大小变为填满父布局
              child: const Text("This is the column 7"),
            ),
          ),
        ],
      ),
    );
  }
}
