
import 'package:flutter/material.dart';

class ExBackgroundImage extends StatefulWidget {
  const ExBackgroundImage({super.key});

  @override
  State<ExBackgroundImage> createState() => _ExBackgroundImageState();
}

class _ExBackgroundImageState extends State<ExBackgroundImage> {
  @override
  Widget build(BuildContext context) {
    ///获取statusBar的高度
    // var statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Background Image"),

        ///让appBar变成透明色，不然会覆盖扩展的body内容
        forceMaterialTransparency: true,
      ),

      ///让body中的内容扩展到AppBar和statusBae,需要在runAppBar前设置状态栏为透明色
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            image: AssetImage("images/ex.png"),
          ),
          Padding(
            //需要添加边距:status+appBar的高度，不然会上升屏幕最上方
            padding: const EdgeInsets.only(top: 56*2),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,

              ///调试时使用，方便观察容器的大小
              // color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 32,
                      ),
                      "body of page"),
                  ElevatedButton(onPressed: () {}, child: const Text("button"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
