import 'package:flutter/material.dart';

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
        title: const Text("Example of Gesture"),
      ),
      body: GestureDetector(
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
        onDoubleTap: () {
          print("onDoubleTap");
        },
        onLongPress: () => print("onLongPress"),
        //向坐标值减小方向的滑动就是Horizon?
        onHorizontalDragStart: (dragDetails) =>
            print("onHorizontalDragStart: ${dragDetails.localPosition}"),
        //向坐标值增加方向的滑动就是Verti?
        onVerticalDragStart: (dragDetails) =>
            print("onVerticalDragStart: ${dragDetails.localPosition}"),
      ),
    );
  }
}
