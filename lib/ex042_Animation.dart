import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExAnimation extends StatefulWidget {
  const ExAnimation({Key? key}) : super(key: key);

  @override
  State<ExAnimation> createState() => _ExAnimationState();
}

///动画步骤
/// 1. 创建AnimationController有一个必选参数vsync表示屏幕刷新时是否通知当前界面，传递了this给它。
/// 因此state类混入了SingleTickerProviderStateMixin类。可以在这里设置动画播放时间
/// 2. 创建Curve对象，主要用来控制动画的插值
/// 3. 创建Tween对象，主要用来控制动画的开始值和结束值
/// 4. 创建动画widget,主要用来更新动画，本质上是AnimatedWidget的子类,通过类的构造方法加入前面步骤中的动画参数；
/// 5. 创建动画Builder,主要用来更新动画，和自定义动画类的功能相同,通过类参数加入前面步骤中的动画参数；
/// 步骤4和5选择一种就可以，常用的是步骤5
/// 步骤4可以用来控制颜色，大小，位置，角度。把它放到组件的color,size,transform等属性中就可以实现缩放，平移，旋转，渐变动画。
///
class _ExAnimationState extends State<ExAnimation> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController;
  late final CurvedAnimation _animationCurve;
  late final Animation _animationTween;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this,duration: const Duration(seconds: 3),);
    _animationCurve = CurvedAnimation(parent: _animationController, curve:Curves.linear);
    _animationTween = Tween(begin: 100.0,end: 300.0).animate(_animationCurve);
    ///监听动画变化的状态，只要动画变化就会回调
    _animationController.addListener(() {
      ///do nothing
      ///可以在这里做一些事情，比如更新进度
      debugPrint('listener running');
    });

    ///监听动画变化的状态，只有状态变化时才回调，这里的状态是AnimationStatus中的枚举值
    _animationController.addStatusListener((status) {
      debugPrint("states: ${status.toString()}");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Animation'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///使用自定义的动画类
          CustomerAnimatedWidget(animation: _animationTween),
          ///使用动画辅助类
          AnimatedBuilder(
            animation: _animationTween,
            builder: (context,child){
              ///如何平移?而且要有方向
              return Icon(Icons.face,size: _animationTween.value,);},
            ///这个child和builder中child参数相同
            // child: Icon(Icons.surround_sound,size: _animationTween.value,),
          ),
          ElevatedButton(
            onPressed: () {
              _animationController.forward();
            },
            child: const Text('start animation'),
          ),
          ///自动旋转组件,其它以Animated开头的组件也有动画功能，这类动画是显式动画
          const AnimatedRotation(
            child: Text("hi"),
            duration: Duration(seconds: 3),
            turns: pi/3,
          ),
          AnimatedOpacity(opacity: 1.0, duration: const Duration(seconds: 3),
            child: Container(width: 100,height: 100,color: Colors.red,),
          ),

        ],
      ),
    );
  }
}

///自定义动画类是为了提高性能，当动画更新时只调用当前类的build方法，不会调用当前类外层的build方法
class CustomerAnimatedWidget extends AnimatedWidget {
  ///listenable是必选参数
  CustomerAnimatedWidget({super.key, required this.animation}):super(listenable: animation);

  Animation animation;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Icon(Icons.surround_sound,size: animation.value,);
  }

}