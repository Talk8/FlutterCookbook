import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

///两个包导入后会发生错误，因为有些类名相同
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ExBle extends StatefulWidget {
  const ExBle({Key? key}) : super(key: key);

  @override
  State<ExBle> createState() => _ExBleState();
}

class _ExBleState extends State<ExBle> {
  List<ScanResult>? scanDeviceList;

  ///存放过滤后的设备列表
  List<ScanResult>? filterDeviceList = [];
  BluetoothConnectionState connectionState =
      BluetoothConnectionState.disconnected;
  final DeviceViewModel _deviceViewModel = DeviceViewModel();
  late Logger log;

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
    initLogger();
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
                // child: deviceListWithState(context),
              ),
              ///下面两个组件用来测试设计思路是否正确，默认值为default,点击按钮后变成new value
              SizedBox(
                height: 50,
                child:Consumer<DeviceViewModel>(
                  builder: (context,data,child){
                    return Text(data.getShardData);
                    },
                ),
              ),
              const SizedBox(
                height: 50,
                child: DataWidget(),
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
          filterDeviceList = deviceList;

          ///初始化viewMode,key是设备名，value初始化为disconnected
          ///这个初始化没有用，先保留
          // deviceList.forEach((element) {
          //   _deviceViewModel.setDeviceModel(
          //       element.device.localName, 'Disconnected');
          // });

          debugPrint('data list： ${deviceList.length}');
        }
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            log.i('index: $index');

            ///在listTile外层嵌套一个GestureDetector组件用来响应各种事件
            return GestureDetector(
              onTap: () {
                log.w('$index is clicked');
                connectDevice(deviceList[index].device);
              },
              child: Container(
                alignment: Alignment.center,

                ///指定list中第个item的宽度
                height: 56,
                child: ListTile(
                  title: Text(
                    ' ${deviceList[index].device.localName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    '${deviceList[index].rssi}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  leading: const Icon(
                    Icons.bluetooth,
                    color: Colors.blue,
                    size: 32,
                  ),
                  ///这可以动态更新设备连接状态
                  subtitle: deviceStateWidget(deviceList[index].device),
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

  ///这个widget比较好，使用了provide/consumer.设备列表变化,以及设备状态变化后，该组件会自动更新界面
  ///不过由于在异步方法中更新数据状态，导致consumer中无法获取到更新后的数据，因此本组件不能正常运行,
  ///具体表现为：builder方法在数据更新后不会回调
  Widget deviceListWithState(BuildContext context) {
    return Consumer<DeviceViewModel>(
      ///builder属性用来创建一个ListView
      builder: (context, data, child) {
        debugPrint('consumer builder');
        List<String> deviceList = [];
        List<String> deviceStateList = [];
        var size = 0;

        ///返回的数据可能为空，因为有扫描不到设备的情况
        if (data != null) {
          // deviceList = data.data as List<ScanResult>;
          ///key的列表就是设备名称
          deviceList = data.deviceModel.keys.toList();
          deviceStateList = data.deviceModel.values.toList();
          size = deviceList.length;

          log.i("device list : ${deviceList.length}");
          log.i('origin device list: ${scanDeviceList?.length}');
        }else {
          log.w('data of consumer is null');
        }
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // debugPrint('index: $index');
            log.i('index: $index');

            ///在listTile外层嵌套一个GestureDetector组件用来响应各种事件
            return GestureDetector(
              onTap: () {
                log.w('$index is clicked');
                ///这里没有使用provider中的数据,这种设计不太好
                connectDevice((filterDeviceList?[index])!.device);
              },
              child: Container(
                alignment: Alignment.center,

                ///指定list中第个item的宽度
                height: 56,
                child: ListTile(
                  title: Text(
                    deviceList[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    deviceStateList[index],
                      style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    ///这里没有使用provider中的数据,这种设计不太好
                    '${filterDeviceList?[index].rssi}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  leading: const Icon(
                    Icons.bluetooth,
                    color: Colors.blue,
                    size: 32,
                  ),
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

  String getDeviceConnectedState(Stream<BluetoothConnectionState> data) {
    String result = 'Disconnected';

    data.listen((event) {
      if(event == BluetoothConnectionState.disconnected) {
        result = 'Disconnected';
      }

      if(event == BluetoothConnectionState.connected) {
        result = 'Connected';
      }
    });

    return result;
  }

  ///通过StreamBuilder来自动监听设备连接状态
  ///本来想使用provide/consumer来获取，但是连接状态是Stream类型，属于异步操作。
  ///因此通过StreamBuilder来自动监听设备连接状态
  ///本方法有一个缺点就是连接错误时不知道设备状态，考虑如何修改
  Widget deviceStateWidget(BluetoothDevice device) {
    return StreamBuilder(
      stream: device.connectionState,
      builder:(context,data){
        String state = 'unKnown';
        if(data.data == BluetoothConnectionState.disconnected) {
          state = 'Disconnected';
        }

        if(data.data == BluetoothConnectionState.connected) {
          state = 'Connected';
        }

        return Text(state, style: const TextStyle(fontSize: 18),
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

  void initLogger() {
    log = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        printEmojis: false,
        printTime: true,
      ),
    );
  }

  void initBLE() {
    subscription = FlutterBluePlus.scanResults.listen(
      (result) {
        scanDeviceList = result;
        filterDeviceList = scanDeviceList?.where((element) => element.device.localName.isNotEmpty).toList();
        filterDeviceList?.forEach((element) {
          _deviceViewModel.setDeviceModel(element.device.localName, "Disconnected");
        });
        // log.i('listener scan list: ${scanDeviceList?.length}');
        // log.i('listener filter list: ${filterDeviceList?.length}');
        ///当前方法是异步方法，在此方法中更新数据虽然向provider发出了数据更新的通知，但是没有效果
        //  _deviceViewModel.setShardData = 'new data';
        Provider.of<DeviceViewModel>(context,listen: false).setShardData = 'new value';
      },

      ///这两个方法都没有回调
      onError: (e) => debugPrint('onError ${e.toString()}'),
      onDone: () => debugPrint('onDone'),
    );
  }

  void startScan() {
    debugPrint('start scan');
    ///直接修改值或者使用Provider中的数据修改也可以,调试数据，正式程序中不使用
    ///当前方法不是异步方法，在此方法中更新数据向provider发出了数据更新的通知，通知有效果
    ///下面两行代码就用来测试数据更新是否有效果
    //  _deviceViewModel.setShardData = 'new data';
    // Provider.of<DeviceViewModel>(context,listen: false).setShardData = 'new value';
    FlutterBluePlus.startScan(
      // withServices: [Guid(PrivateKey.uuid)],
      timeout: Duration(seconds: scanTimeout),
    );
  }

  void stopScan() {
    debugPrint('stop scan');
    FlutterBluePlus.stopScan();
  }

  void connectDevice(BluetoothDevice device) async {
    if (device != null) {
      ///功能：在页面中随时更新设备连接状态，设计思路：
      ///1. 点击设备名开始连接设备，同时注册连接状态监听器
      ///2. 连接完成后监听器中的方法会回调，此时修改Model中的管理设备连接状态的数据
      ///3. 修改完数据后notify Provider，表示状态已经更新，Provider管理状态。
      ///4. 在页面中使用consumer获取状态，也就是设备的连接状态，
      ///结论：consumer中的无法获取到状态，因为2中更新状态数据是在异步操作中完成的
      // device.connectionState.listen((state) {
      //   log.i('device: ${device.localName} ,state: ${state.name}');
      //   _deviceViewModel.setDeviceModel(device.localName, '$state');
      // });
      await device
          .connect()
          .onError((error, stackTrace) =>
              log.e('connect device: ${error.toString()}'))
          .whenComplete(() => log.i('connect finished'));
    }
  }
}



class DeviceViewModel extends ChangeNotifier {
  late Map<String, String> _deviceModel;
  late String _shardData;

  Map<String, String> get deviceModel => _deviceModel;


  DeviceViewModel() {
    _deviceModel = {};
    _shardData = 'default';
  }

  setDeviceModel(String key, String value) {
    _deviceModel[key] = value;
    // print('notify data changed');
    notifyListeners();
  }


  String get getShardData => _shardData;

  set setShardData(String value) {
    _shardData = value;
    notifyListeners();
  }

}

///创建类包含stream对象，为streamProvider做准备
class DeviceConnectStateStream {
  late BluetoothDevice device;
  late Stream<BluetoothConnectionState> connectSate;
}

///用来测试更新设备状态的设计思路是否正确，经过测试发现是更新数据使用了异步操作造成了
///把更新数据放到按钮中就可以正常运行，放到异步方法中无法运行，比如scan结果的listen方法
///和connectedState的listen方法
class DataWidget extends StatelessWidget {
  const DataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceViewModel>(
      builder: (context,data,child){
        return Text(data.getShardData);
      },
    );
  }
}

