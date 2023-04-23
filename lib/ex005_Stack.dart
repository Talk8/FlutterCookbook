//本代码与第8,9回的内容匹配，主要介绍Stack和CircleAvatar相关的内容
import 'package:flutter/material.dart';

class ExStack extends StatelessWidget {
  const ExStack({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget stackEx = Stack(
      //这个偏移只对没有设置位置的widget起作用
      //(0,0)是中央位置
      // alignment: const Alignment(0.0,0.0),
      alignment: Alignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          backgroundImage: AssetImage("images/ax.png"),
          foregroundColor: Colors.black87,
          foregroundImage: AssetImage("images/ax.png"),
          radius: 80,
          child: Text("avatar",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20),
          ),
        ),
        // const CircleAvatar(
        //   backgroundColor: Colors.blueAccent,
        //   //找不到图片使用颜色填充
        //   backgroundImage: AssetImage("images/ex.png"),
        //   radius: 80,
        //   //不添加时有边框，添加后没有边框
        //   foregroundColor: Colors.black87,
        // ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: const Text(
            'This is text',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Positioned(
            left: 140,
            top: 6,
            child: Icon(Icons.book)
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stack Example"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: stackEx,
    );
  }
}