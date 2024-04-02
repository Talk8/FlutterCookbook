import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


///在Scaffold页面上层显示一蒙板,呈模糊状态与417内容匹配
class ExScaffoldOverlay extends StatefulWidget {
  const ExScaffoldOverlay({super.key});

  @override
  State<ExScaffoldOverlay> createState() => _ExScaffoldOverlayState();
}

class _ExScaffoldOverlayState extends State<ExScaffoldOverlay> {
  ///是否显示蒙板的条件
  bool isShowOverlay = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
     appBar: AppBar(
       title: const Text("Example of Scaffold Overlay"),
       backgroundColor: Colors.purpleAccent,
       ///这个值默认为true,如果设置为false就会隐藏返回箭头
       automaticallyImplyLeading: true,
       ///该属性和extendBodyBehindAppBar属性同时设置为true时才可以让body部分的内容覆盖到AppBar上面
       ///此时就会显示蒙板，不过它不会覆盖AppBar中的返回箭头和Title
       forceMaterialTransparency: true,
     ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ///正常页面
          Positioned(
            left: 0,
            top: 200,
            child: Column(
              children: [
                const Text("This is body"),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isShowOverlay = true;
                    });
                  },
                  child: const Text("show overlay"),
                ),
              ],
            ),
          ),
          ///蒙板页面
          Positioned(
            top: 0,
            left: 0,
            width: screenWidth,
            height: screenHeight,
            child: isShowOverlay ? Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child:  const Text("This is overlay"),
            )
            : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
