//本代码和第七回的内容匹配，主要介绍GridView这个Widget

import 'dart:math';

import 'package:flutter/material.dart';

class ExGirdView extends StatelessWidget {
  const ExGirdView({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget girdViewEx = GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 0.5,
      children: const [
        Icon(Icons.light),
        Icon(Icons.arrow_back),
        Icon(Icons.light),
        Icon(Icons.hail),
        Icon(Icons.nat),
        Icon(Icons.hail),
        Icon(Icons.mail),
        Icon(Icons.hail),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("GirdView Example"),
        backgroundColor: Colors.purpleAccent,
      ),
      // body: girdViewEx,
      body: ColorPaletteByGridView(),
    );
  }
}

///使用GirdView的构造方法创建GirdView,主要是gridDelegate属性是必选属性
class ColorPaletteByGridView extends StatelessWidget {
  const ColorPaletteByGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      ///list中无法添加最左和最右侧的边距，通过padding添加
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          ///主轴中组件的数量
          crossAxisCount: 3,
          ///宽高比
          childAspectRatio: 1.8,
          ///主轴和交叉轴的边距
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        children: List.generate(45, (index) {
          return Container(
            child: Center(
              ///使用按钮来响应事件
              child: TextButton(
                onPressed: ()=>print('$index clicked'),
                ///文本使用索引值
                child: Text('$index',style: TextStyle(color: Colors.white),),),
            ),
            ///颜色使用随机数生成
            color: Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)),);
        }),
      ),
    );
  }
}