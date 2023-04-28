import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BottomNavigationBar Example "),
        ),
        body: const Text("test"),
        bottomNavigationBar: BottomNavigationBar(
          //超过3个item时需要使用type属性
          backgroundColor: Colors.amber,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectIndex,
          fixedColor: Colors.blue,
          //放在iconsize,同时bottomBar整体也跟着放大
          iconSize: 40,
          onTap: (index) {
            setState( () {
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
      );
  }
}



