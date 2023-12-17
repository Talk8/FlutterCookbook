import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ttc_ble/flutter_ttc_ble.dart';
import 'package:fluttercookbook/_private_data.dart';
import 'package:provider/provider.dart';

///这个示例使用flutter_ttc_ble包中的内容实现,包含扫描，连接，发送和接收数据功能。
///扫描和发送数据有专门的按钮，连接设备没有，通过点击设备名称实现连接功能
class ExBleWithTTC extends StatefulWidget {
  const ExBleWithTTC({super.key});

  @override
  State<ExBleWithTTC> createState() => _ExBleWithTTCState();
}

class _ExBleWithTTCState extends State<ExBleWithTTC> with BleCallback2{
  final _ScanViewModel viewModel = _ScanViewModel();
  String _deviceId = "";

  @override
  void initState() {
    // TODO: implement initState
    FlutterTtcBle.init();
    bleProxy.addBleCallback(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bleProxy.removeBleCallback(this);
    super.dispose();
  }
  @override
  void onScanStart() {
    // TODO: implement onScanStart
    debugPrint("--> onScanStart");
    viewModel.clearDevices();
    // super.onScanStart();
  }

  @override
  void onLeScan(BLEDevice device) {
    debugPrint("--> add device");
    viewModel.addDevice(device);
    // super.onLeScan(device);
  }
  @override
  void onConnected(String deviceId) {
    debugPrint("--> device is connected");
    BleManager().enableNotification(deviceId: deviceId);
    super.onConnected(deviceId);
  }

  @override
  void onDisconnected(String deviceId) {
    debugPrint("--> device is disconnected");
    super.onDisconnected(deviceId);
  }

  @override
  void onDataSend(String deviceId, String serviceUuid, String characteristicUuid, Uint8List? data, int status) {
    debugPrint("--> device send data: ${data?.toHex()}");
    super.onDataSend(deviceId, serviceUuid, characteristicUuid, data, status);
  }
  @override
  void onDataReceived(String deviceId, String serviceUuid, String characteristicUuid, Uint8List data) {
    debugPrint("<-- device recv data: ${data.toHex()}");
    super.onDataReceived(deviceId, serviceUuid, characteristicUuid, data);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ScanViewModel>(
      create:(_) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Example of ble"),
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 32,
              right: 32,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed:  (){
                      bleProxy.startScan();
                      ///3s秒后停止扫描
                      Future.delayed(const Duration(seconds: 3),(){
                       bleProxy.stopScan();
                      });
                    },
                    child: const Text("Scan Device"),),
                  ElevatedButton(
                    onPressed: (){
                      List<int> oriValue = PrivateKey.value;
                      Uint8List value = Uint8List.fromList(oriValue);

                      debugPrint("send data id: $_deviceId");

                      bleProxy.write(deviceId: _deviceId,
                          serviceUuid: PrivateKey.writeServiceUuid,
                          characteristicUuid: PrivateKey.writeCharacteristicUuid,
                          value: value);
                    },
                    child: const Text("Send data"),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              // child: Container(
              //   width: 300,
              //   height: 400,
              //   color: Colors.blue,
              // ),
              child: SizedBox(
                width: 400,
                height: 600,
                child: Consumer<_ScanViewModel>(
                  builder: (context,vm,child){
                    debugPrint("consumer: -----> ");
                    return Container(
                      color: Colors.blue,
                      child: ListView.separated(
                        itemBuilder: (context,index){
                          return Listener(
                           onPointerDown: (event){
                             _deviceId = vm._devices[index].deviceId;
                             bleProxy.connect(deviceId: _deviceId);
                           },
                           child: Text("item : $index ${vm._devices[index].name}"),
                          );
                        },
                        separatorBuilder:(context,index) => const Divider(),
                        itemCount: vm._devices.length),
                    );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ScanViewModel extends ChangeNotifier {
  final List<BLEDevice> _devices = [];

  void addDevice(BLEDevice device) {
    if(device.name == null) {
      return;
    }

    if(device.name!.isNotEmpty && device.name!.contains("WY")) {
    int index = _devices.indexOf(device);
    if (index == -1) {
      _devices.add(device);
    } else {
      _devices[index] = device;
    }
    notifyListeners();
    }
  }

  void clearDevices() {
    if (_devices.isNotEmpty) {
      _devices.clear();
      notifyListeners();
    }
  }

  // void _sortDevices() {
  //   _devices.sort((device1, device2) => device2.rssi - device1.rssi);
  //   notifyListeners();
  // }
}


class BleManager {
  static final BleManager _bleManager = BleManager._sharedInstance();

  BleManager._sharedInstance();

  factory BleManager() => _bleManager;

  ///发送数据
  void sendData({required String deviceId, required Uint8List data}) {
    debugPrint('send data');
    FlutterTtcBle.writeCharacteristic(
        deviceId: deviceId,
        // serviceUuid: uuidService,
        // characteristicUuid: uuidWrite,
        serviceUuid: PrivateKey.writeServiceUuid,
        characteristicUuid: PrivateKey.writeCharacteristicUuid,
        value: data,
        // writeType: CharacteristicWriteType.write);
        writeType: CharacteristicWriteType.writeNoResponse);
  }

  ///开启通知以接收设备端数据
  /*
  void enableNotification({required String deviceId}) {
    FlutterTtcBle.setCharacteristicNotification(
        deviceId: deviceId,
        serviceUuid: uuidService,
        characteristicUuid: uuidNotify,
        enable: true);
  }
   */
  void enableNotification({required String deviceId}) {
    FlutterTtcBle.setCharacteristicNotification(
        deviceId: deviceId,
        serviceUuid: PrivateKey.notifyServiceUuid,
        characteristicUuid: PrivateKey.notifyCharacteristicUuid,
        enable: true);
  }
}
