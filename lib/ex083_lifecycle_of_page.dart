import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

class ExPageLifeCycle extends StatefulWidget {
  const ExPageLifeCycle({super.key});

  @override
  State<ExPageLifeCycle> createState() => _ExPageLifeCycleState();
}

///LLifecycle的这两个接口还有顺序要求
///WidgetsBindingObserver只在Material的子组件中才有效果，这里没有效果，监听不到任何事件，因此不会输出日志
class _ExPageLifeCycleState extends State<ExPageLifeCycle> with WidgetsBindingObserver,LifecycleAware,LifecycleMixin{
  @override
  void onLifecycleEvent(LifecycleEvent event) {
    /// TODO: implement onLifecycleEvent
    debugPrint("life event: $event");
    ///界面从从出现到消失时事件：visible -> active -> inactive -> invisible
    switch(event) {
      case LifecycleEvent.visible:
        break;
      case LifecycleEvent.active:
        break;
      case LifecycleEvent.inactive:
        break;
      case LifecycleEvent.invisible:
        break;
      case LifecycleEvent.push:
        break;
      case LifecycleEvent.pop:
        break;
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState

    debugPrint(" check state: ${state.toString()}");
    super.didChangeAppLifecycleState(state);
  }
  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    debugPrint(" check didPopRoute ");
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    debugPrint(" check didPushRoute ");
    return super.didPushRoute(route);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Example of LifeCycle"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '080Page',);
          }, child: const Text("jump 080"),),

          ///snackBar在页面跳转时仍然会带到下一个页面中，如果下一个中上包含bottomNavigationBar
          ///或者floatingActionButton，那么snackBar会从这两个bar的高度上计算自己的margin.
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '010Page',);
            ScaffoldMessenger.of(context).showSnackBar(createSnackBar(20,2));
          }, child: const Text("jump 010"),),

          ///两个切换两个bar显示的时间达到页面切换时snackBar的高度一致。比如当前页面90，但是
          ///只显示了1秒，页面跳转后在上面的跳转处理再次显示2秒，这样就可以延长显示它，并且两次显示时的乙高度相同
          ///当然，这种做法不是很好
          ElevatedButton(onPressed: (){
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hello"),),);
            ScaffoldMessenger.of(context).showSnackBar(createSnackBar(90,1));
          }, child: const Text("Show SnackBar"),),
        ],
      ),
    );
  }

  SnackBar createSnackBar(double bottom,int time) {

    return SnackBar(
      content: const Text("This is SnackBar"),
      backgroundColor: Colors.amberAccent,
      //修改形状，默认为矩形
      // shape:CircleBorder(
      //   side: BorderSide(),
      // ),
      behavior: SnackBarBehavior.floating,
      ///控制snackBar与屏幕之间的距离，相当于外边距，不能与width同时使用
      margin: EdgeInsets.only(left:16,right:16,bottom:bottom),
      //显示时间
      duration:Duration(seconds: time),
    );
  }
}
