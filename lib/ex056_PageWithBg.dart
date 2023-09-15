import 'package:flutter/material.dart';

class ExPageWithBg extends StatefulWidget {
  const ExPageWithBg({super.key});

  @override
  State<ExPageWithBg> createState() => _ExPageWithBgState();
}

class _ExPageWithBgState extends State<ExPageWithBg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      ///如果不指定appBar，背景图片可以顶到屏幕status栏中
      appBar: AppBar(
        title: const Text('Example of Page with image background '),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: Text("This is the title")),
          ///页面中带有背景图片，使用stack实现
          const Stack(
            children: [
              Image(
                width: 200,
                height: 200,
                opacity: AlwaysStoppedAnimation(0.5),
                image: AssetImage('images/ex.png'),
                fit: BoxFit.fill,
              ),
              Center(child: Text('This is the body')),
            ],
          ),
          ///页面中带有背景图片，使用container实现
          Container(
            width: 200,
            height: 200,
            decoration:const BoxDecoration(
              ///修改图片的填充方式和模糊效果
              image: DecorationImage(
                opacity: 0.5,
                // colorFilter: ColorFilter.mode(Color.fromARGB(100, 200, 20,30),BlendMode.difference),
                image: AssetImage("images/ex.png"),
                fit: BoxFit.fill,
              ),
            ),
            child:const Text('This is the body'),
          ),
        ],
      ),
    );
  }
}
