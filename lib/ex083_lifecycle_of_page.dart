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
          }, child: Text("jump 080"),),
        ],
      ),
    );
  }
}
