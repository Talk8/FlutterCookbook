import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_device_connector.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_device_interactor.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_logger.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';

import '_private_data.dart';
import 'ex045_BleDemo/src/ui/device_detail/device_interaction_tab.dart';

///这个demo是使用reactive_blue中的api实现的ble，包含扫描，连接，
///该demo没有实现发送数据，读取数据功能，因为发送数据后只回复成功与失败没有具体的结果
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
///这个页面主要实现了ble scan功能,该功能使用了官方demo中的BleScanner类，该类封装reactive_ble包中的扫描接口
/// _ble.scanForDevices()这个接口返回的是stream对象，因此BleScanner对它进行了封装
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

  void routerToDeviceDetailsPage (BuildContext ctx,DiscoveredDevice device) {
    Navigator.push(ctx,
      MaterialPageRoute( builder:(_) => DeviceDetails(device: device,),),
    );
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
                                  ///点击设备后跳转到设备详情页面
                                  onTap: () => routerToDeviceDetailsPage(context,device),
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
                      ///不使用uuid也可以搜索设备
                      // widget.startScan();
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

///-----------------------------new file ------------------------------------
///点击设备后跳转的页面，正常项目中应该放到不同的文件中，这里是为了方便查看代码，因此放到了一个文件中
///这个类有一个必选参数device通过正常的参数传递，其它数据通过consumer传递
///这个类主要用来包含consumer,页面真正的类在DeviceDetailsPage页面中
class DeviceDetails extends StatelessWidget {
  const DeviceDetails({required this.device,Key? key}) : super(key: key);

  final DiscoveredDevice device;
  @override
  Widget build(BuildContext context) =>
      Consumer3<BleDeviceConnector,ConnectionStateUpdate,BleDeviceInteractor>(
          builder:(_,deviceConnector,connectedState,deviceInteract,__) {
            return DeviceDetailsPage(
              viewModel: DeviceInteractionViewModel(
                deviceId: device.id,
                connectableStatus: device.connectable,
                connectionStatus: connectedState.connectionState,
                deviceConnector: deviceConnector,
                discoverServices: () => deviceInteract.discoverServices(device.id),
              ),
              device: device,
            );
          },
      );
}

///这个页面才是真正的设备详情页面，这个页面主要实现了connect,disconnect功能
///这两个功能封装在了DeviceInteractionViewModel类中，该是demo自己封装的，该类封装了reactive_ble
///包中的接口类：BleDeviceConnector，如果想看连接过程需要到这个类中，该类封装了connect和disconnected功能
///在项目中我们可以直接使用BleDeviceConnector类提供的connect和disconnect接口
class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({Key? key, required this.viewModel, required this.device}) : super(key: key);

  ///使用这个变量主要用来获取设备名称
  final DiscoveredDevice device;
  ///这个变量参考示例代码编写，DeviceInteractionViewModel类封装了connect,disconnect功能
  final DeviceInteractionViewModel viewModel;

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  List<DiscoveredService> serviceList = [];
  bool _isExpand = false;

  @override
  void initState() {
    // TODO: implement initState
    widget.viewModel.connect();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? 'unKnown'),
        backgroundColor: Colors.purpleAccent,
      ),
      ///设备连接状态从ConnectionStateUpdate类中读取，它是在connect过程中添加到stream中
      ///然后通过StreamProvider中共享数据，这里通过consumer中的ConnectionStateUpdate获取连接状态
      ///因此这个值是动态变化的：connecting,disconnected,connected.
      ///在整个列外面嵌套一层滚动列表，这样可以避免list太长导致运行时错误:纵向长度不够
      body:SingleChildScrollView(
        child: Column(
          children: [
            ///标题行：显示设备连接状态
            Text('connect state: ${widget.viewModel.connectionStatus}'),
            ///按钮行：显示connect,disconnect,discover操作
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///在Button外层，嵌套一个Flexible更加安全，它会自动调整Button大小，否则如果button中的字太大了就会有宽度上的溢出
                Flexible(
                  flex: 1,
                  child: ElevatedButton(onPressed: () => widget.viewModel.connect(),
                    child:const Text('Connect device'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(onPressed: () => widget.viewModel.disconnect(),
                    child:const Text('Disconnected device'),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(onPressed: () async{
                    final result = await widget.viewModel.discoverServices();
                    setState(() {
                      serviceList = result;
                    });},
                    child:const Text('Discover Service'),
                  ),
                ),
              ],
            ),
            ///服务行：显示服务可折叠服务列表，服务列表中双包含character列表
            ExpansionPanelList(
             expansionCallback: (index,isExpand){
               setState(() {
                 _isExpand = !isExpand;
               });
             },
             children: [
               ///这个列表是设备的服务列表,服务列表使用扩展列表封装
               ...serviceList.map((services) => ExpansionPanel(
                 headerBuilder:(context,isExpand) =>
                     ListTile(
                       leading:const Text('Service:'),
                       title: Text('${services.serviceId}'),
                     ),
                 body: ListView(
                   shrinkWrap: true,
                   children: [
                     ///这个列表是服务的character列表，列表使用ListView封装
                     ...services.characteristics.map((characters) =>
                         ListTile(title:Text('${characters.characteristicId}'),),
                     ).toList(),
                   ],
                 ),
                 isExpanded: _isExpand,
               ),
               ).toList(),
             ],
            ),
          ],
        ),
      ),
    );
  }
}
