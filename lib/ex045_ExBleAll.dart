import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_logger.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';

import '_private_data.dart';

///这个demo是使用reactive_blue中的api实现的ble，包含扫描，连接，发送数据，读取数据功能
class ExBleAll extends StatefulWidget {
  const ExBleAll({Key? key}) : super(key: key);

  @override
  State<ExBleAll> createState() => _ExBleAllState();
}

class _ExBleAllState extends State<ExBleAll> {
  ///从consumer中拿到共享数据，然后通过构造函数传递给组件
  @override
  Widget build(BuildContext context) => Consumer5<BleStatus, TestConsumer, BleScanner, BleScannerState?, BleLogger>(
        builder: (_, bleStatus, testConsumer, bleScanner, bleScannerState,
            bleLogger, child) {
          ///测试功能使用的方法
          // bleScanner.debugFunc();
          // testConsumer.func();
          ///原示例程序有对ready状态进行判断，这个值是一个stream，通过streamProvider来监听
          ///它是从包中直接返回的内容，状态值表示蓝牙的运行状态，比如没有打开蓝牙开关
          if (bleStatus != BleStatus.ready) {
            debugPrint('error states');
            return const Text('error statue');
          } else {
            debugPrint('ready states');
            return DeviceList(
              scannerState: bleScannerState ??
                  const BleScannerState(
                    discoveredDevices: [],
                    scanIsInProgress: false,
                  ),
              startScan: bleScanner.startScan,
              stopScan: bleScanner.stopScan,
              toggleVerboseLogging: bleLogger.toggleVerboseLogging,
              verboseLogging: bleLogger.verboseLogging,
              testConsumer: testConsumer,
            );
          }
        },
      );
}

///从示例代码中复制而来，不过在Provider中无法使用，会报重复定义的错误，因此直接import原来的类
/// import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_scanner.dart';
/*
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}
 */

///这个组件才是屏幕中主要的内容，通过参数传递BLE相关数据给它，这些数据来源于Consumer,consumer
///是从根目录中的provider获取到的蓝牙信息.这便是数据共享
class DeviceList extends StatefulWidget {
  const DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.toggleVerboseLogging,
    required this.verboseLogging,
    required this.testConsumer,
    Key? key,
  }) : super(key: key);

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  final VoidCallback toggleVerboseLogging;
  final bool verboseLogging;
  final TestConsumer testConsumer;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  bool showProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    debugPrint('init start scan');
    super.initState();
  }

  Widget linearProgress(){
    if(widget.scannerState.discoveredDevices.isEmpty) {
      return const LinearProgressIndicator(color:Colors.green,backgroundColor: Colors.grey,);
    }else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    ///通过屏幕宽度的比例来设置界面高度
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of All BLE'),
        backgroundColor: Colors.purpleAccent,
      ),

      ///页面使用列布局：外层嵌套Padding(方便调整边距）上方是一个文本，中间是设备列表，下方是搜索按钮
      body: ScreenUtilInit(
        designSize: const Size(375.0, 667.0),
        builder: (context, child) {
          return Padding(
            ///边距不需要适配，直接使用固定尺寸就可以
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: 64.w,
                        child: const Text( 'device list', ),
                    ),
                ),

                ///我使用了百分比的思路设计ListView的高度，也可以使用Flexible组件
                ///在设备列表外层嵌套一层下拉列表组件实现下拉刷新功能
                SizedBox(
                  height: screenHeight.w * 0.7,
                  child: RefreshIndicator(
                    onRefresh: () {
                      widget.startScan([Uuid.parse(PrivateKey.searchServiceUuid)]);
                      ///扫描10s后自动停止扫描
                      return Future.delayed( const Duration( seconds: 10, ), () => widget.stopScan(),);
                    },
                    child: ListView(
                      children: [
                        ///两种显示进度条的方法，第二种更加高效一些，因为使用了conusmer，不会更新整个页面
                        // linearProgress(),
                        Consumer<BleScannerState>(
                            builder: (context,data,_){
                              // debugPrint('size: ${data.discoveredDevices.length}');
                              if(data.discoveredDevices.isEmpty) {
                                return const LinearProgressIndicator();
                              }else{
                                return const SizedBox.shrink();
                              }
                            },),
                        ///使用三个点给List赋值，并且将其转换成ListTile,这样做性能会不会不好？
                        ...widget.scannerState.discoveredDevices
                            .map((device) => ListTile(
                                  leading: const BluetoothIcon(),
                                  title: Text(device.name.isNotEmpty ? device.name : 'unKnown'),
                                  ///在字符串中加入换行
                                  subtitle: Text( "mac: ${device.id}\nrssi: ${device.rssi} "),
                                  onTap: () {},
                                ),)
                            .toList(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.w,
                  child: ElevatedButton(
                    onPressed: () {
                      // widget.testConsumer.func();
                      widget.startScan([Uuid.parse(PrivateKey.searchServiceUuid)]);
                      ///扫描10s后停止扫描
                      Future.delayed( const Duration( seconds: 10, ), () {
                          widget.stopScan();
                          ///更新界面，主要是停止滚动条，配合linearProgress()方法使用
                          // setState(() {});
                       },);
                    },
                    child: const Text('Start Scan'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

///从示例代码中复制面来，把icon封装成了独立的组件
class BluetoothIcon extends StatelessWidget {
  const BluetoothIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 48,
        height: 48,
        child: Align(alignment: Alignment.center, child: Icon(Icons.bluetooth,color: Colors.blue,)),
      );
}

///定义的测试类，参考bleScanner类实现，主要高度在consumer对象是否可以调用方法
class TestConsumer {
  String sValue = 'data value';
  void func() {
    debugPrint('testConsumer func running');
  }
}
