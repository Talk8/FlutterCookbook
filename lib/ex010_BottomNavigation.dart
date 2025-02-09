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
        debugPrint("FloatingButton onClicked");
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
      /*
      ///嵌套剪切组件用来把导航栏左右两侧切成圆角
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
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
      ),

       */
      ///上面是Material2的用法，下面是Material3的用法
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft:Radius.circular(30),topRight: Radius.circular(30)),
        child: NavigationBar(
          backgroundColor: Colors.lightBlueAccent,
          selectedIndex: selectIndex,
          onDestinationSelected: (index){
            setState(() {
              selectIndex = index;
            });
          },
          destinations:[
            ///让每个按钮之间有间隔，不过要用颜色来显示，不然看不出效果来
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                color: Colors.green,
                child: const NavigationDestination(icon: Icon(Icons.home), label: "Home")),
            ),
            ///单独修改某个按钮的形状和颜色，需要ClipRRect和Container组件同时使用才可以修改形状
            ClipRRect(
                borderRadius: const BorderRadius.only(topLeft:Radius.circular(30),topRight: Radius.circular(30)),
                child: Container(
                  color: Colors.orange,
                    child: const NavigationDestination(icon: Icon(Icons.favorite), label: "Favorite"))),
            const NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
      floatingActionButton: _floatingActionButton,
      //控制FloatingActionButton的位置，默认在屏幕右下角
      //centerFloat和centerDocked的区别在于Docked会让FloatingButton一半位于屏幕，一半位于BottomNavigationBar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
