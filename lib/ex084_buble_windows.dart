import 'package:bubble/bubble.dart';
import 'package:bubble_box/bubble_box.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

///与BubbleBox的内容相匹配，这个插件简单易用，而且是国人写的
///与flutter_chat_bubble的内容相匹配，这个插件简单易用，
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///第一行：BubbleBox示例
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
          ///第二行：FlutterChatBubble示例
          ///nip就是箭头，这个叫法比较专业，可以通过参数控制它的高度和宽度，不过方向和位置无法控制.Clipper1箭头在右上，Clipper2箭头在右下
          ///Clipper一共9种，就是箭头的形状不一样，其它内容一样，不再一一列出。与BubbleBox相比，优点是可以控制箭头的长度和宽度，缺点是无法控制箭头的方向和位置
          ChatBubble(
            clipper: ChatBubbleClipper1(type: BubbleType.sendBubble,),
            alignment: Alignment.topRight,
            child: const Text("ChatBuble Window"),
          ),
          ChatBubble(
            clipper: ChatBubbleClipper2(type: BubbleType.sendBubble,nipWidth: 50,nipHeight: 30),
            alignment: Alignment.topRight,
            child: const Text("FlutterChatBubble Window"),
          ),
          ///第三行：Bubble示例.这个插件功能十分强大，虽然三年没有更新但是可以弥补BubbleBox的所有缺点，
          ///我觉得FlutterChatBubble就是在此基础上创建的。我十分推荐此插件
          Bubble(
            color: Colors.deepPurpleAccent,
            nip: BubbleNip.leftCenter,
            ///用来控制箭头的长度和宽度
            nipHeight: 16,
            nipWidth: 20,
            ///用来控制箭头的在边框上的具体位置
            nipOffset: 4,
            ///箭头的范围，一般不设置也可以，它必须小于长度和宽度的二分之一
            ///它会影响到箭头的尖锐程度
            nipRadius: 5,
            ///整个bubble父组件中的位置
            alignment: Alignment.centerRight,
            style: const BubbleStyle(borderColor: Colors.redAccent,borderUp:true),
            stick: true, ///用来控制左右两边的边距
            child: const Text("Bubble"),
          ),
          ///第四行：chat_bubble示例.这个插件功相当是个bubble,它可以嵌套声音和图片.这个插件主打聊天特色，比如发送，接收等，不过对箭头控制有限
          const BubbleSpecialThree(
            ///是否显示箭头nip
            tail: true,
           ///会在最右侧显示一个对号
            sent:false ,
            delivered: true,
            seen: true,
            ///窗口的背景颜色
            color: Colors.yellow,
            text: "chat_bubble window"),
          ///可以在图片，audio外层嵌套bubble，并且对它们进行控制,还有一个messageBar没有实践，需要时再使用
          BubbleNormalImage(id: "001", image: const Icon(Icons.favorite),
            tail: true,
            color: Colors.lightGreenAccent,
            onTap: (){},
          ),

        ],
      ),
    );
  }
}
