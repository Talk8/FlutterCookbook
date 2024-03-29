import 'package:flutter/material.dart';

///创建一个可以添加图片做为背景的组件，可以修改组件的大小，边框，圆角,与144内容匹配
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
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            child: Container(
              width: 200,
              height: 200,
              decoration:const BoxDecoration(
                ///使用圆形后不能同时使用borderRadius
                // shape: BoxShape.circle,
                ///设置容器的边框和圆角，下面的方法可以运行
                // border: Border.all(color: Colors.deepPurpleAccent,width: 3),
                // borderRadius: BorderRadius.circular(30),
                ///部分边框时不能设置borderRadius,需要在container外层再嵌套一层clipRRect
                // border: Border.symmetric(horizontal: BorderSide(color: Colors.deepPurple,width: 3,)),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
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
          ),
        ],
      ),
    );
  }
}
