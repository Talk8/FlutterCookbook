import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExChannel extends StatefulWidget {
  const ExChannel({Key? key}) : super(key: key);

  @override
  State<ExChannel> createState() => _ExChannelState();
}

class _ExChannelState extends State<ExChannel> {
  ///创建channel对象时最好使用域名/功能名这样的形式,在原生代码中会获取该channel
  ///有三种channel:MethodChannel:可以实现flutter和原生代码双向通信，通信内容通过方法的参数来传递
  ///EventChannel:主要用来从原生给Flutter发消息
  ///BasicMessageChannel：可以实现flutter和原生代码双向通信，通信内容为简单字符串等内容
  static const flutterMethodChannel = MethodChannel("www.acf.com/battery");
  static const flutterEventChannel = EventChannel("www.acf.com/event");
  // static const flutterMessageChannel = BasicMessageChannel('name', )

  late int batteryLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("This is the example of MethodChannel"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => getBattery(),
            child: const Text('Get Data From Native platform')),
          Text('Battery: $batteryLevel'),
          ElevatedButton(
              onPressed: () => sendEventChannel(),
              child: const Text('Get event From Native platform')),
          Text('Battery: $batteryLevel'),
        ],
      ),
    );
  }

  ///调用Native中的方法,方法名就是invokeMethod()方法的参数,第二个参数用来传递数据
  void getBattery() async {
    String data = "send data";
    final result = await flutterMethodChannel.invokeMethod("getBattery",data);
    setState(() {
      batteryLevel = result;
    });
  }

  ///原生平台返回的是stream,通完listen方法监听里面发来的event
  void sendEventChannel() {
    var streamSubscription = flutterEventChannel.receiveBroadcastStream()
        .listen((event) { debugPrint("data: ${event.toString()}");},
    onError: (e) => debugPrint('error: ${e.toString()}'),
    onDone: () => debugPrint('event done'),
    cancelOnError: true);
  }
}
