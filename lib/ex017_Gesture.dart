import 'package:flutter/material.dart';

///与31内容对应
class ExGesture extends StatefulWidget {
  const ExGesture({Key? key}) : super(key: key);

  @override
  State<ExGesture> createState() => _ExGestureState();
}

class _ExGestureState extends State<ExGesture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text("Example of GestureDetector"),
      ),
      body: Container(
        width: 400,
        height: 500,
        color: Colors.yellow,
        ///如果不指定对齐，child中的container会覆盖父container
        ///因此不建议两个container嵌套使用，最好使用stack
        alignment: Alignment.center,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            color: Colors.greenAccent,
            width: 300,
            height: 300,
            child: const Text("Gesture Test"),
          ),
          onTap: () {
            print("onTap");
          },
          onTapDown: (details) {
            print('onTapDown Clicked:'
                'GlobalPos: ${details.globalPosition}'
                'LocationPos: ${details.localPosition}');
          },
          onDoubleTap: () {
            print("onDoubleTap");
          },
          onLongPress: () => print("onLongPress"),
          //向坐标值减小方向的滑动就是Horizon?
          onHorizontalDragStart: (dragDetails) =>
              print("onHorizontalDragStart: local: ${dragDetails.localPosition}"
                  "global: ${dragDetails.globalPosition}"),
          //向坐标值增加方向的滑动就是Verti?
          onVerticalDragStart: (dragDetails) =>
              print("onVerticalDragStart: local: ${dragDetails.localPosition}"
                  "global: ${dragDetails.globalPosition}"),
        ),
      ),
    );
  }
}
