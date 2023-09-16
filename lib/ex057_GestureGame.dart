import 'package:flutter/material.dart';

///创建拖动的小球游戏，手指拖动到哪里小球移动到哪里，手指点到哪里小球移动到哪里，松开手指后小球回到原位,与145内容匹配
///缺点是区域大小和，小球原始位置(100,100)都是固定的,也就是使用了绝对坐标
///位置不够精准，因为移动时没有考虑小球的大小，最好是减去它的半径
/// 外层是矩形坐标用big表示，里层是小圆坐标用small表示
class ExGestureGame extends StatefulWidget {
  const ExGestureGame({super.key});

  @override
  State<ExGestureGame> createState() => _ExGestureGameState();
}

class _ExGestureGameState extends State<ExGestureGame> {
  ///外层矩形的大小
  double bigX = 400;
  double bigY = 400;
  ///内层小圆的原始坐标
  double smallX = 100;
  double smallY = 100;
  ///内层小圆的半径,这个值是Boll大小的一半
  double smallR = 30;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Gesture Game"),
        backgroundColor: Colors.purpleAccent,
      ),
      ///container在外层时只有点到ball时才有响应手势，只能响应拖动事件
      ///这个外层容器看不到了
      body:Container(
        color: Colors.blue,
        width: bigX,
        height: bigY,
        ///container在内层时不用点到ball时才有响应手势，可以响应任意位置的点击事件
        child: GestureDetector(
          child: Container(
            color: Colors.yellow,
            width: bigX,
            height: bigY,
            child: Stack(
              children: [
                Positioned(
                  left: smallX,
                  top: smallY,
                  child:const Ball(),),
              ],
            ),
          ),
          ///响应拖动事件，注意事件中的坐标值是偏移值
          ///global是相对于屏幕的坐标，local是相对于父组件,delta是相对和偏移值
          onPanUpdate: (DragUpdateDetails details) {
            debugPrint('drag-global( ${details.globalPosition.dx}, ${details.globalPosition.dy} )');
            debugPrint('drag-local ( ${details.localPosition.dx}, ${details.localPosition.dy} )');
            debugPrint('drag-delta ( ${details.delta.dx}, ${details.delta.dy} )');
            setState(() {
              ///使用偏移值的方法修改小圆坐标,不需要考虑ball的大小，因为得到的是偏移量
              smallX += details.delta.dx;
              smallY += details.delta.dy;
              ///使用当前坐标值的方法修改小圆坐标,需要考虑ball的大小，否则不够精确
              // smallX = details.localPosition.dx - smallR;
              // smallY = details.localPosition.dy - smallR;
            });
          },
          ///响应停止拖动事件,停止拖动后ball回到原位
          onPanEnd: (DragEndDetails details) {
            setState(() {
              smallX = smallY = 100;
            });
          },
          ///响应点击按下事件，点到哪里ball移动到哪里，注意使用的是localPosition中的坐标值
          ///global是相对于屏幕的坐标，local是相对于父组件
          onTapDown: (TapDownDetails details) {
            setState(() {
              ///不能使用global坐标值
              // smallX = details.globalPosition.dx;
              // smallY = details.globalPosition.dy;
              smallX = details.localPosition.dx - smallR;
              smallY = details.localPosition.dy - smallR;
              debugPrint('global( ${details.globalPosition.dx}, ${details.globalPosition.dy} )');
              debugPrint('local ( ${details.localPosition.dx}, ${details.localPosition.dy} )');
            });
          },
          ///响应点击弹起事件，松开后ball回到原位
          onTapUp: (TapUpDetails details) {
            setState(() {
              smallX = smallY = 100;
            });
          },
        ),
      ),
    );
  }
}
class Ball extends StatelessWidget {
  const Ball({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}

