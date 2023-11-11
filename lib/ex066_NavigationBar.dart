import 'package:flutter/material.dart';

class ExNavigationBar extends StatefulWidget {
  const ExNavigationBar({super.key});

  @override
  State<ExNavigationBar> createState() => _ExNavigationBarState();
}

class _ExNavigationBarState extends State<ExNavigationBar> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const  Text("Example of Navigation")),
      body: const Text("Hello NavigationBar"),
      /*
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft:Radius.circular(60),topRight: Radius.circular(60)),
        child: NavigationBar(
          backgroundColor: Colors.lightBlueAccent,
          selectedIndex: currentIndex,
          onDestinationSelected: (index){
            setState(() {
              currentIndex = index;
            });
          },
          destinations:const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.favorite), label: "Favorite"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),

      */


      bottomNavigationBar: Container(
        ///使用该属性会使外层嵌套的容器形状发生变化，不过导航条仍然无法被外层容器切成圆角，
        ///它会覆盖在外层容器上,使用Decoration属性也不可以把导航条切成圆角
        foregroundDecoration: BoxDecoration(
          ///不能使用color，它会覆盖在导航条上面，导航条的所有内容都被遮挡了
          // color: Colors.green[300],
          ///设置边框颜色
          border: Border.all(color: Colors.red, width: 3),
          borderRadius: const BorderRadius.vertical(top:Radius.circular(20),),
        ),
          // shape: BoxShape.rectangle,
          //   borderRadius: BorderRadius.circular(16)),
        child: NavigationBar(
          //控制destination中Icon外围的形状，默认是16圆角矩形
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          //按钮被选中时外围的颜色
          indicatorColor: Colors.yellow,
          backgroundColor: Colors.lightBlueAccent,
          //阴影颜色，不是很明显
          shadowColor: Colors.green,
          //这个颜色在背景色后面，不设置背景色时才能看到，而且有阴影效果
          surfaceTintColor: Colors.redAccent,
          //调整高度
          height: 80,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          //可以单独添加选择时显示的按钮
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person_2_rounded),
                label:"Person" ),
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
          ],
        ),
      ),

    );
  }
}
