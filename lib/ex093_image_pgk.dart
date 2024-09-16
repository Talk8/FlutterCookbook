import 'package:flutter/material.dart';

///这个示例代码用来演示image插件，演示如何加载pgm文件
///这种pgm是一种2d栅格图文件

class Ex4View extends StatefulWidget {
  const Ex4View({super.key});

  @override
  State<Ex4View> createState() => _Ex4ViewState();
}

class _Ex4ViewState extends State<Ex4View> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint(" build running");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image file of 2d format"),
      ),
      body: const Column(
        children: [
          Text("c1 "),
          Text("c2 "),
          Text("c3 "),
        ],
      ),
    );


    // return threeJs.build();
  }
}
