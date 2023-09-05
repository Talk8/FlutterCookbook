import 'package:flutter/material.dart';
import 'package:flutter_ttc_ble/flutter_ttc_ble.dart';
import 'package:flutter_ttc_ble/scan_screen.dart';

import 'communication.dart';

///这个目录下文件都是来自TTCSDK在github上的demo.这个demo的思路十分清晰。所有的功能都在communication文件中
///ble_manager文件封装了发送数据和设置notify功能。还有一个oad功能没有详细看，有时间了再看。
///这个包的功能和思路完全与Android中使用notify通信的方法相同。包中的API也是按照Android封装的
///其缺点就是接收数据仍然使用回调方法，而不是Flutter中的异步操作：stream.设备的连接状态也是使用回调方法。
///包中的代码我只修改了发送数据和notify中的内容：demo中的uuid替换成我手里设置的uuid。其它内容没有修改。
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      ///这个界面在SDK中，而不是在demo中,通过下拉刷新功能实现扫描BLE功能,扫描不能通过uuid做过滤，不过可以使用右上角的图标来对uuid排序。
      home: ScanScreen(
        title: 'TTC Flutter BLE Demo',
        onDeviceClick: (BuildContext context, BLEDevice device) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommPage(device: device)));
        },
      ),
    );
  }
}
