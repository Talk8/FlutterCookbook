import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/material.dart';

///与BubbleBox的内容相匹配，这个插件简单易用，而且是国人写的
class ExBubleWidow extends StatefulWidget {
  const ExBubleWidow({super.key});

  @override
  State<ExBubleWidow> createState() => _ExBubleWidowState();
}

class _ExBubleWidowState extends State<ExBubleWidow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Example of Bubble Widow"),),
      body: Column(
        children: [
          BubbleBox(
            ///box的形状，border用来控制边框颜色，radius用来控制边框角度，如果不设置默认是矩形
            shape: BubbleShapeBorder(
              border: BubbleBoxBorder(
                color: Colors.blue,
                width: 4,
                ///虚线边框，默认是实线边框
                style: BubbleBoxBorderStyle.dashed,
              ),


              ///elliptical这个是椭圆角，角度比circular大，作者叫：enhanced radius
              // radius: const BorderRadius.only(topRight: Radius.elliptical(30,15),bottomLeft: Radius.circular(40),),
              // position: BubblePosition.center(0),
              ///边框外突出箭头的位置
              // position: BubblePosition.start(40),
              ///边框外突出箭头的方向
              direction: BubbleDirection.bottom,
              ///边框箭头尖头的角度,它同时会影响箭头下方三角的开口大小，值越大，尖头角度越大，下方三角开口越大,默认值是6
              arrowAngle: 5,
              ///边框外突出箭头的钝角，值越大越圆滑
              // arrowQuadraticBezierLength: 90,
            ),

            ///设置纯色或者渐变色背景
            // backgroundColor: Colors.orange,
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.yellow,
              Colors.blue,
            ]),
            blendMode: BlendMode.difference,
            child: const Text("Bubble Window"),
          ),

        ],
      ),
    );
  }
}
