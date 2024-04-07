import 'package:flutter/material.dart';


///在Scaffold页面上层显示一蒙板,呈模糊状态与417内容匹配
///这个是自定义的内容，也可以通过overlay_tooltip和onboarding_overlay两个包实现,不过它们的功能不同
///另外一个通过Overlay_tooltip包实现的Overlay在ex082中

///在页面下方介绍了MediaQuery相关的内容
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
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    ///使用下面的方法代替上面的方法，可以减少页面重绘
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    ///与403，405的内容匹配，404的内容在ex002_ListView中
    debugPrint("build running");
    ///键盘高度，没有键盘弹出时为0
    // debugPrint("keyboard 1: ${MediaQuery.of(context).viewInsets.bottom}");
    ///这个方法不会减少页面重绘,可见只对sizeof有效果。
    // debugPrint("keyboard 1: ${MediaQuery.viewInsetsOf(context).bottom}");
    ///底部安全区域高度，没有时为0
    // debugPrint("keyboard 2: ${MediaQuery.of(context).viewPadding.bottom}");
    ///没有实际意义
    // debugPrint("keyboard 3: ${MediaQuery.of(context).viewInsets.top}");
    ///顶部状态栏的高度
    // debugPrint("keyboard 4: ${MediaQuery.of(context).viewPadding.top}");

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
          Positioned(
            top: 400,
            left: 0,
            ///嵌套一层builder就不会引起页面重绘
            child: Builder(builder: (context) {
              double y = MediaQuery.of(context).size.height;
              debugPrint("build running of builder");
              return Text("check rebuilding value: ${y.toString()}");
            }),
          ),
          ///键盘自动弹出时会导到MediaQuery进行页面重绘，有两种解决方法：更换接口，嵌套builder
          const Positioned(
            top: 450,
            left: 0,
            width: 300,
            height: 56,
            child: TextField(),
          ),
        ],
      ),
    );
  }
}
