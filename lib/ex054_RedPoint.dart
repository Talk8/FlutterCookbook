import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

///RedPoint就是在组件右上角显示小红点,可以通过官方的Badge组件实现，也可以使用三方包实现
///三方包可以修改红点的样式，大小，以动画显示，并且可以响应点击事件

class ExRedPoint extends StatefulWidget {
  const ExRedPoint({Key? key}) : super(key: key);

  @override
  State<ExRedPoint> createState() => _ExRedPointState();
}

class _ExRedPointState extends State<ExRedPoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Red Point'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Badge(
            ///红点中显示的内容
            label: Text('3'),
            ///默认红底白字
            backgroundColor: Colors.purpleAccent,
            textColor: Colors.green,
            ///红点的位置,默认topRight
            alignment: Alignment.topLeft,
            ///红点的偏移，负值为向左和上，正值为向右和下
            offset: Offset(20.0, -10.0),
            ///在哪个组件右上角显示红点
            child: Icon(Icons.notifications),
          ),
          ///这个组件也可以显示红点，只不过红点中的内容固定为数字，其它属性和Badge组件完全相同
          Badge.count(
          count: 3,
          child: const Icon(Icons.notifications),
          ),
          ///使用三方包实现红点
          const badges.Badge(
            badgeContent: Text('3'),
            child: Icon(Icons.notifications_active),
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10,end: -15),
            onTap: () => debugPrint('onTap'),
            badgeContent: const Text('3'),
            badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(seconds: 2)),
            badgeStyle: const badges.BadgeStyle(
              shape: badges.BadgeShape.twitter,
            ),
            child: const Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}
