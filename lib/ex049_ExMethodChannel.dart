import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExChannel extends StatefulWidget {
  const ExChannel({Key? key}) : super(key: key);

  @override
  State<ExChannel> createState() => _ExChannelState();
}

class _ExChannelState extends State<ExChannel> {
  ///创建channel对象时最好使用域名/功能名这样的形式,在原生代码中会获取该channel
  static const platform = MethodChannel("www.acf.com/battery");
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
            child: const Text('Get')),
          Text('Battery: $batteryLevel'),
        ],
      ),
    );
  }

  ///调用Native中的方法,方法名就是invokeMethod()方法的参数
  void getBattery() async {
    final result = await platform.invokeMethod("getBattery");
    setState(() {
      batteryLevel = result;
    });
  }
}
