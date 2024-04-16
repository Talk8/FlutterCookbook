import 'package:flutter/material.dart';

///上一个ex086使用的是自定义的overlay,我叫它蒙板，本文件中使用的是官方SDK中提供的Overlay组件
///官方通过overlayState来显示OverlayEntry,但是不能管理多个OverlayEntry。OverlayEntry可以删除自己，
///官方的这个OverlayEntry适合显示单个Overlay，不适合做功能引导:onBoarding Overlay
class ExOverlayEntry extends StatefulWidget {
  const ExOverlayEntry({super.key});

  @override
  State<ExOverlayEntry> createState() => _ExOverlayEntryState();
}

class _ExOverlayEntryState extends State<ExOverlayEntry> {
  OverlayEntry? _overlayEntry1;
  OverlayEntry? _overlayEntry2;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text("Example of Overlay Entry") ,
      ),
      body: Column(
        children: [
          const Text("this is body"),
          ElevatedButton(
            onPressed: () => _showOverlay(context),
            child: const Text("Show Overlay"),
          ),
          ElevatedButton(
            onPressed: () => _showCurrentOverlay(context),
            child: const Text("Show current Overlay"),
          ),
        ],
      ),
    );
  }

  ///显示一个全屏的Overlay
  void _showOverlay(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    _overlayEntry1 = OverlayEntry(builder: (context) {
      ///Overlay上显示的内容
      return Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.lightBlueAccent,
            width: screenWidth,
            height: screenHeight,
            child:const Text("This is a Overlay Entry"),
          ),
      );
    },
      ///控制透明度
    opaque: true,
    );

    final OverlayState overlayState = Overlay.of(context);
    overlayState.insert(_overlayEntry1!);
    // overlayState.insert(_overlayEntry1!,below: _overlayEntry1!);

    Future.delayed(const Duration(seconds: 5,),() {
      if(_overlayEntry1 != null) {
        _overlayEntry1!.remove();
        _overlayEntry1 = null;
      }
    });
  }
  ///显示一个在组件位置下方的Overlay,宽度和宽度是固定的，这个例子可以当作模板来使用
  void _showCurrentOverlay(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    ///这个方法可以获取到对象，但是获取时机不好掌握，当前这种时机获取到的坐标值为0
    final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    double currentX = renderBox.localToGlobal(Offset.zero).dx;
    double currentY = renderBox.localToGlobal(Offset.zero).dy;

    debugPrint("current : x:$currentX, y:$currentY");

    _overlayEntry2 = OverlayEntry(builder: (context) {
      ///Overlay上显示的内容
      ///使用Stack和Opacity可以控制Overlay底层的颜色和透明度，通常是黑色
      ///或者使用Contain+透明颜色来实现
      return Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              color:Colors.black,
              ///这个是透明颜色，没有Opacity时可以通过它来实现透明效果
              // color: Color(0xDF8C8C8C),
            ),
          ),
          Positioned(
            ///这个值计算成显示Overlay位置的坐标值最好，这样可以在这个位置显示Overlay
            top: 300,
            left: 100,
            ///通过容器来控制Overlay当前的颜色和内容，通常是白色
            child: Container(
              color: Colors.lightBlueAccent,
              width: screenWidth,
              height: screenHeight/3,
              ///默认显示的文本格式是红色大号，而且有下划线
              child:const Text("This is a Overlay Entry with position",
                style: TextStyle(color: Colors.black,fontSize: 16,decoration: TextDecoration.none),
              ),
            ),
          ),
        ],
      );
    },
      ///控制透明度,设置为false时才有透明效果
      opaque: false,
    );

    ///显示Overlay,并且在5秒后自动移除Overlay
    final OverlayState overlayState = Overlay.of(context);
    overlayState.insert(_overlayEntry2!);

    Future.delayed(const Duration(seconds: 5,),() {
      if(_overlayEntry2 != null) {
        _overlayEntry2!.remove();
        _overlayEntry2 = null;
      }
    });
  }
}
