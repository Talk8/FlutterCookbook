import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

///两个包导入后会发生错误，因为有些类名相同
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import '_private_data.dart';

class ExBle extends StatefulWidget {
  const ExBle({Key? key}) : super(key: key);

  @override
  State<ExBle> createState() => _ExBleState();
}

class _ExBleState extends State<ExBle> {
  List<ScanResult>? scanDeviceList;

  ///扫描超时时间，单位是秒
  final scanTimeout = 5;
  StreamSubscription<List<ScanResult>>? subscription;

  ///与flutter_reactive_ble相关的代码注释掉，不再使用
  /*
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? streamSubscription;

  ///这个方法本身没有问题，但是scan无法停止，导致list无法显示
  Widget BleDeviceList() {
    return StreamBuilder<DiscoveredDevice>(
      stream: flutterReactiveBle.scanForDevices(
          withServices:[Uuid.parse(PrivateKey.uuid)],),
      builder: (context,dataSource){
        debugPrint('builder running');
       return ListView.builder(
         shrinkWrap: true,
         itemBuilder: (context,index){
           debugPrint('builder running $index');
        return ListTile(
          title: Text('${dataSource.data?.name}'),
          subtitle:Text('${dataSource.data?.id}'),
        );
       },);
      } ,
    );
  }
   */

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();

    initBLE();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build func running');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Example of BLE'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    debugPrint('start scan');
                    // bleScan();
                    startScan();
                  },
                  child: const Text('Scan')),
              ElevatedButton(
                  onPressed: () {
                    debugPrint('stop scan');
                    stopScan();
                  },
                  child: const Text('Stop Scan')),
              // BleDeviceList(),
              SizedBox(
                height: 500,
                // child: DeviceListNeedUpdateStae(),),
                child: deviceList(),
              ),
            ],
          ),
        ));
  }

  ///与flutter_reactive_ble相关的代码注释掉，不再使用
  /*
  _onData(data) {
    debugPrint("onData: ${data.toString()}");
  }
  void bleScan() {
    streamSubscription = flutterReactiveBle.scanForDevices(
      requireLocationServicesEnabled: false,
      withServices: [Uuid.parse(PrivateKey.uuid)], scanMode: ScanMode.lowPower)
        .listen(
          (event) { debugPrint('event: ${event.toString()}'); _onData(event);},
          onError: (handlerError) {
            debugPrint("onError: ${handlerError.toString()}"); },
          onDone: () {
           debugPrint("onDone");
          });

        ///这个onError Listen返回内容:stream中的方法
        // .onError((handlerError) {
      // debugPrint("listen Error: ${handlerError.toString()}");
    // });
  }

  ///scan启动后无法stop
  void stopScan() {
    debugPrint('stop scan');
    streamSubscription?.cancel();
  }

   */

  ///这个widget需要主动更新界面才可以出现内容，因为设备列表开始为空，扫描后虽然有值了但是没有更新界面
  Widget deviceListNeedUpdateState() {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,

          ///指定list中第个item的宽度
          height: 56,
          child: ListTile(
            title: Text(
              ' ${scanDeviceList?[index].device.localName}',
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              ' ${scanDeviceList?[index].rssi}',
              style: const TextStyle(fontSize: 12),
            ),
            leading: const Icon(
              Icons.bluetooth,
              color: Colors.blue,
              size: 32,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.lightBlue,
        );
      },
      itemCount: scanDeviceList?.length ?? 0,
    );
  }

  ///这个widget比较好，使用了streamBuilder.设备列表变化后，该组件会自动更新界面
  Widget deviceList() {
    return StreamBuilder(
      ///扫描结果以stream对象返回
      stream: FlutterBluePlus.scanResults,

      ///builder属性用来创建一个ListView
      builder: (context, data) {
        debugPrint('stream builder');
        List<ScanResult> deviceList = [];
        var size = 0;
        // debugPrint('data： ${data.toString()}');
        ///返回的数据可能为空，因为有扫描不到设备的情况
        if (data.data != null) {
          deviceList = data.data as List<ScanResult>;
          ///把没有设备名称的设备过滤掉
          deviceList = deviceList
              .where((element) => element.device.localName.isNotEmpty)
              .toList();
          size = deviceList.length;
          debugPrint('data list： ${deviceList.length}');
        }
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            debugPrint('index: $index');
            return Container(
              alignment: Alignment.center,

              ///指定list中第个item的宽度
              height: 56,
              child: ListTile(
                title: Text(
                  ' ${deviceList[index].device.localName}',
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  '${deviceList[index].rssi}',
                  style: const TextStyle(fontSize: 12),
                ),
                leading: const Icon(
                  Icons.bluetooth,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.lightBlue,
            );
          },
          itemCount: size,
        );
      },
    );
  }

  void checkPermission() async {
    var status = await Permission.bluetooth.status;
    if (status.isDenied) {
      requestPermission();
    }
  }

  void requestPermission() async {
    Map<Permission, PermissionStatus> permissionMap = await [
      // Permission.locationAlways,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    debugPrint("permission state: ${permissionMap[Permission.location]}");
  }

  void initBLE() {
    subscription = FlutterBluePlus.scanResults.listen(
      (result) {
        scanDeviceList = result;
      },
      ///这两个方法都没有回调
      onError: (e) => debugPrint('onError ${e.toString()}'),
      onDone: () => debugPrint('onDone'),
    );
  }

  void startScan() {
    debugPrint('start scan');
    FlutterBluePlus.startScan(
      // withServices: [Guid(PrivateKey.uuid)],
      timeout: Duration(seconds: scanTimeout),
    );
  }

  void stopScan() {
    debugPrint('stop scan');
    FlutterBluePlus.stopScan();
  }
}
