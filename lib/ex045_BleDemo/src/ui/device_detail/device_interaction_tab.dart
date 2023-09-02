import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:flutter_reactive_ble_example/src/ble/ble_device_connector.dart';
// import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_device_connector.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/ble_device_interactor.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';

import 'characteristic_interaction_dialog.dart';

part 'device_interaction_tab.g.dart';
//ignore_for_file: annotate_overrides

///设备Tab页面主要用业显示设备的id和连接状态，代码分析如下：
///DeviceInteractionTab就是一个壳子，主要用来使用Consumer获取花共享数据
///真正的页面是_DeviceInteractionTab组件，它通过参数接收数据，参数中的
///内容比较多，使用DeviceInteractionViewModel类封装，该类封装了设备connect和disconnect功能
class DeviceInteractionTab extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceInteractionTab({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
        builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
                __) =>
            _DeviceInteractionTab(
          viewModel: DeviceInteractionViewModel(
              deviceId: device.id,
              connectableStatus: device.connectable,
              connectionStatus: connectionStateUpdate.connectionState,
              deviceConnector: deviceConnector,
              discoverServices: () =>
                  serviceDiscoverer.discoverServices(device.id)),
        ),
      );
}

@immutable
@FunctionalData()
class DeviceInteractionViewModel extends $DeviceInteractionViewModel {
  const DeviceInteractionViewModel({
    required this.deviceId,
    required this.connectableStatus,
    required this.connectionStatus,
    required this.deviceConnector,
    required this.discoverServices,
  });

  final String deviceId;
  final Connectable connectableStatus;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;
  @CustomEquality(Ignore())
  final Future<List<DiscoveredService>> Function() discoverServices;

  bool get deviceConnected =>
      connectionStatus == DeviceConnectionState.connected;

  void connect() {
    deviceConnector.connect(deviceId);
  }

  void disconnect() {
    deviceConnector.disconnect(deviceId);
  }
}
///界面使用List布局，前面4行的内容是固定的，详细如下：
///第1行：设备ID
///第2行：设备是否可以连接
///第3行：设备的连接状态
///第4行：设备操作的button，包含：connect,disconnect,discoverServices
///重点看看如何连接、断开设备，以及发现设备中的服务
class _DeviceInteractionTab extends StatefulWidget {
  const _DeviceInteractionTab({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final DeviceInteractionViewModel viewModel;

  @override
  _DeviceInteractionTabState createState() => _DeviceInteractionTabState();
}

class _DeviceInteractionTabState extends State<_DeviceInteractionTab> {
  late List<DiscoveredService> discoveredServices;

  @override
  void initState() {
    discoveredServices = [];
    super.initState();
  }

  Future<void> discoverServices() async {
    final result = await widget.viewModel.discoverServices();
    ///通过setState来刷新页面
    setState(() {
      discoveredServices = result;
    });
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      top: 8.0, bottom: 16.0, start: 16.0),
                  child: Text(
                    "ID: ${widget.viewModel.deviceId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0),
                  child: Text(
                    "Connectable: ${widget.viewModel.connectableStatus}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0),
                  child: Text(
                    "Connection: ${widget.viewModel.connectionStatus}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ///connect,disconnect,discoverService都使用了device_interaction类中的接口
                ///这些接口本质上是对reactive_ble包中接口的封装
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: !widget.viewModel.deviceConnected
                            ? widget.viewModel.connect
                            : null,
                        child: const Text("Connect"),
                      ),
                      ElevatedButton(
                        onPressed: widget.viewModel.deviceConnected
                            ? widget.viewModel.disconnect
                            : null,
                        child: const Text("Disconnect"),
                      ),
                      ElevatedButton(
                        onPressed: widget.viewModel.deviceConnected
                            ? discoverServices
                            : null,
                        child: const Text("Discover Services"),
                      ),
                    ],
                  ),
                ),

                ///上面是整个页面前三行的内容，第四行内容依据是否有服务来显示
                ///如果蓝牙设备没有连接就不显示service列表，这个是SliverChildListDelegate特有的，ListView就没有此功能
                if (widget.viewModel.deviceConnected)
                  _ServiceDiscoveryList(
                    deviceId: widget.viewModel.deviceId,
                    discoveredServices: discoveredServices,
                  ),
              ],
            ),
          ),
        ],
      );
}

///这个是显示服务列表的组件，主要通过expansionPanel实现
class _ServiceDiscoveryList extends StatefulWidget {
  const _ServiceDiscoveryList({
    required this.deviceId,
    required this.discoveredServices,
    Key? key,
  }) : super(key: key);

  final String deviceId;
  final List<DiscoveredService> discoveredServices;

  @override
  _ServiceDiscoveryListState createState() => _ServiceDiscoveryListState();
}

class _ServiceDiscoveryListState extends State<_ServiceDiscoveryList> {
  /// 这个列表对页面中的expandPanel进行管理,主要用来判断扩展列表是否需要展开，
  /// 它的原理:点击时添加或者删除列表项，使用时判断该列表项是否存在uu
  late final List<int> _expandedItems;

  @override
  void initState() {
    _expandedItems = [];
    super.initState();
  }

  ///把character的各种属性封装成方法
  String _characteristicsSummary(DiscoveredCharacteristic c) {
    final props = <String>[];
    if (c.isReadable) {
      props.add("read");
    }
    if (c.isWritableWithoutResponse) {
      props.add("write without response");
    }
    if (c.isWritableWithResponse) {
      props.add("write with response");
    }
    if (c.isNotifiable) {
      props.add("notify");
    }
    if (c.isIndicatable) {
      props.add("indicate");
    }

    return props.join("\n");
  }

  ///这个是位于service列表下的character列表，数据来源于方法中的参数，该列表内容通过listTile构建
  ///标题是characterId+各种属性：read,write,点击后会弹出对话框，在对话框中进行数据读写操作
  Widget _characteristicTile(
          DiscoveredCharacteristic characteristic, String deviceId) =>
  ///这个代码是为了从当前页面把context传递下一级页面时添加的，传递context也不起使用
      // Widget _characteristicTile(BuildContext context,
      // DiscoveredCharacteristic characteristic, String deviceId) =>
      ListTile(
        onTap: () => showDialog<void>(
          context: context,
          ///原来是在下一级通过consumer获取provider中的共享数据，修改成在当前页面中获取共享数据
          // builder: (context) => CharacteristicInteractionDialog(
          //   bcontext: context,
          //       characteristic: QualifiedCharacteristic(
          //           characteristicId: characteristic.characteristicId,
          //           serviceId: characteristic.serviceId,
          //           deviceId: deviceId),
          //     )),
          builder: (context) {
            return Consumer<BleDeviceInteractor>(
              builder: (context, data, _) {
                return CharacteristicInteractionDialog(
                  readCharacteristic: data.readCharacteristic,
                  writeWithoutResponse: data.writeCharacteristicWithoutResponse,
                  writeWithResponse: data.writeCharacteristicWithResponse,
                  subscribeToCharacteristic: data.subScribeToCharacteristic,
                  bcontext: context,
                  characteristic: QualifiedCharacteristic(
                      characteristicId: characteristic.characteristicId,
                      serviceId: characteristic.serviceId,
                      deviceId: deviceId),
                );
              },
            );
          },
        ),
        title: Text(
          '${characteristic.characteristicId}\n(${_characteristicsSummary(characteristic)})',
          ///这个是为了调试时添加的：确认是否可以通过当前页面的context获取到provider中的值
          // 'check: ${Provider.of<BleDeviceInteractor>(context, listen: false).toString()}',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      );

  ///Service的主要内容就在这个方法中，它返回的是一个列表，列表中的每一项为service列表，该列表是扩展列表
  ///扩展列表标题是serviceId,内容是普通列表，列表中的内容是characters
  ///这种设计和ble的结构有关：一个设备包含多个service,因此需要列表来显示
  ///一个service包含多个character，因此需要列表来显示
  List<ExpansionPanel> buildPanels() {
    final panels = <ExpansionPanel>[];
    ///这个是为了调试时添加的：确认是否可以通过当前页面的context获取到provider中的值
    // BleDeviceInteractor bleDeviceInteractor =
    //     Provider.of<BleDeviceInteractor>(context, listen: false);
    // print('result: ${bleDeviceInteractor.toString()}');

    ///这个给List赋值的方法：一边遍历service列表，一边把列表中的service添加到新列表中
    widget.discoveredServices.asMap().forEach(
          (index, service) => panels.add(
            ExpansionPanel(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.0),
                    child: Text(
                      'Characteristics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => _characteristicTile(
                      service.characteristics[index],
                      widget.deviceId,
                    ),
                    itemCount: service.characteristicIds.length,
                  ),
                ],
              ),
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text(
                  '${service.serviceId}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              isExpanded: _expandedItems.contains(index),
            ),
          ),
        );

    return panels;
  }

  @override
  Widget build(BuildContext context) => widget.discoveredServices.isEmpty
      ? const SizedBox()
      : Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 20.0,
            start: 20.0,
            end: 20.0,
          ),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                setState(() {
                  if (isExpanded) {
                    _expandedItems.remove(index);
                  } else {
                    _expandedItems.add(index);
                  }
                });
              });
            },
            children: [
              ...buildPanels(),
            ],
          ),
        );
}
