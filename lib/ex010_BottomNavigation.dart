import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttercookbook/ex005_Stack.dart';
import 'package:fluttercookbook/ex007_Button.dart';

import 'ex008_Text.dart';

//此代码是第17回,18回和第19回的配套代码
class ExBottomNavigation extends StatefulWidget {
  const ExBottomNavigation({Key? key}) : super(key: key);
  @override
  State<ExBottomNavigation> createState() => _ExBottomNavigation();
}

class _ExBottomNavigation extends State<ExBottomNavigation> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    //这里必须再嵌套一个StatefullWidget,不然无法响应事件
    return const BodyWidget();
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});
  @override
  State<BodyWidget> createState() => _bodyWidget();
}

class _bodyWidget extends State<BodyWidget> {
  int selectIndex = 0;

  final Widget _floatingActionButton = Container(
    width: 90.0,
    height: 90.0,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(60),
    ),
    child: FloatingActionButton(
      backgroundColor: Colors.purpleAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          width: 2,
          color: Colors.black87,
        ),
      ),
      //     //可以是文字或者icon，它会显示在FloatingButton上，默认是蓝色圆形
      // child: const Text("Float Button"),
      child: const Icon(Icons.add),
      onPressed: () {
        print("FloatingButton onClicked");
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgetList = const [
      ExStack(),
      ExButton(),
      ExText(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("BottomNavigationBar Example "),
      ),
      // body: const Text("test"),
      body: bodyWidgetList[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        //超过3个item时需要使用type属性,不然无法显示文字
        backgroundColor: Colors.amber,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectIndex,
        fixedColor: Colors.blue,
        //放在iconsize,同时bottomBar整体也跟着放大
        iconSize: 40,
        onTap: (index) {
          setState(() {
            // print(index);
            selectIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting")
        ],
      ),
      floatingActionButton: _floatingActionButton,
      //控制FloatingActionButton的位置，默认在屏幕右下角
      //centerFloat和centerDocked的区别在于Docked会让FloatingButton一半位于屏幕，一半位于BottomNavigationBar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
