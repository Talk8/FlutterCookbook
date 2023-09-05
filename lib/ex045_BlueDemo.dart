// Copyright 2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
///这个包来自包中example目录下的main.dart文件，还有一个widgets.dart文件中的内容也在该包中
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttercookbook/_private_data.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'widgets.dart';

///本文件中的代码全部是从flutter_blue_plus包的example中复制而来，包含main.dart，widgets.dart两个文件
///它实现了常用的蓝牙功能：扫描、连接、发现service,读写characteristics，读写descriptors,发送通知，修改MTU
///读写功能都是在character下面显示的，因此都是基于当前的service和character进行的。这与它的api有关
///因数读写操作的api都在character类下而不是ble下。
final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();
///这个变量主要用来配合ValueListenableBuilder局部刷新组件使用
final Map<DeviceIdentifier, ValueNotifier<bool>> isConnectingOrDisconnecting = {};

///我从main文件中直接跳转到了FlutterBlueApp中的,因此没有处理main中权限相关的内容
///这个是针对不同平台来审评蓝牙权限的代码
void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const FlutterBlueApp());
    });
  } else {
    runApp(const FlutterBlueApp());
  }
}

///路由监听器，用来对路由做处理
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _btStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/deviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _btStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _btStateSubscription?.cancel();
    _btStateSubscription = null;
  }
}

///这是主程序：依据蓝牙是否连接包含两个界面：蓝牙设备列表页面和无设备界面
class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      ///监听蓝牙状态，判断蓝牙是否可用
      home: StreamBuilder<BluetoothAdapterState>(
          stream: FlutterBluePlus.adapterState,
          initialData: BluetoothAdapterState.unknown,
          builder: (c, snapshot) {
            final adapterState = snapshot.data;
            if (adapterState == BluetoothAdapterState.on) {
              return const FindDevicesScreen();
            } else {
              FlutterBluePlus.stopScan();
              return BluetoothOffScreen(adapterState: adapterState);
            }
          }),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

///这个蓝牙关闭时的界面，或者叫无设备界面。界面比较简单，只一个打开蓝牙的按钮
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyA,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${adapterState != null ? adapterState.toString().split(".").last : 'not available'}.',
                style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
              ),
              ///蓝牙没有打开就打开蓝牙，不过这个功能只适用android
              if (Platform.isAndroid)
                ElevatedButton(
                  child: const Text('TURN ON'),
                  onPressed: () async {
                    try {
                      if (Platform.isAndroid) {
                        await FlutterBluePlus.turnOn();
                      }
                    } catch (e) {
                      final snackBar = snackBarFail(prettyException("Error Turning On:", e));
                      snackBarKeyA.currentState?.removeCurrentSnackBar();
                      snackBarKeyA.currentState?.showSnackBar(snackBar);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

///这个有设备的界面，也是程序的主界面
class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

///这个是程序的主界面，主要是一个刷新列表和floatingButton。列表用来显示设备，button用来扫描和停止扫描
///列表分两部分，上部分是已经连接的设备列表，下部分是扫描出的设备列表
class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
        ),
        ///支持下拉刷新功能
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {}); // force refresh of connectedSystemDevices
            if (FlutterBluePlus.isScanningNow == false) {
              FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
            }
            return Future.delayed(Duration(milliseconds: 500)); // show refresh icon breifly
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ///已经连接的设备列表,点击CONNECT/OPEN按钮跳转到设备详细页面中
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.fromFuture(FlutterBluePlus.connectedSystemDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: (snapshot.data ?? [])
                        .map((d) => ListTile(
                      title: Text(d.localName),
                      subtitle: Text(d.remoteId.toString()),
                      trailing: StreamBuilder<BluetoothConnectionState>(
                        stream: d.connectionState,
                        initialData: BluetoothConnectionState.disconnected,
                        builder: (c, snapshot) {
                          if (snapshot.data == BluetoothConnectionState.connected) {
                            return ElevatedButton(
                              child: const Text('OPEN'),
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DeviceScreen(device: d),
                                  settings: RouteSettings(name: '/deviceScreen'))),
                            );
                          }
                          if (snapshot.data == BluetoothConnectionState.disconnected) {
                            return ElevatedButton(
                                child: const Text('CONNECT'),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) {
                                        isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(true);
                                        isConnectingOrDisconnecting[d.remoteId]!.value = true;
                                        d.connect(timeout: Duration(seconds: 35)).catchError((e) {
                                          final snackBar = snackBarFail(prettyException("Connect Error:", e));
                                          snackBarKeyC.currentState?.removeCurrentSnackBar();
                                          snackBarKeyC.currentState?.showSnackBar(snackBar);
                                        }).then((v) {
                                          isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(false);
                                          isConnectingOrDisconnecting[d.remoteId]!.value = false;
                                        });
                                        return DeviceScreen(device: d);
                                      },
                                      settings: RouteSettings(name: '/deviceScreen')));
                                });
                          }
                          return Text(snapshot.data.toString().toUpperCase().split('.')[1]);
                        },
                      ),
                    ))
                        .toList(),
                  ),
                ),
                ///扫描出的设备列表,列表是一个可扩展列表，封装成了ScanResultTile.
                ///ScanResultTile是一个自己封装的组件，里面的内容几乎都是自己封装的，不过都属性页面布局
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: (snapshot.data ?? [])
                        .map(
                          (r) => ScanResultTile(
                        result: r,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(true);
                              isConnectingOrDisconnecting[r.device.remoteId]!.value = true;
                              r.device.connect(timeout: Duration(seconds: 35)).catchError((e) {
                                final snackBar = snackBarFail(prettyException("Connect Error:", e));
                                snackBarKeyC.currentState?.removeCurrentSnackBar();
                                snackBarKeyC.currentState?.showSnackBar(snackBar);
                              }).then((v) {
                                isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(false);
                                isConnectingOrDisconnecting[r.device.remoteId]!.value = false;
                              });
                              return DeviceScreen(device: r.device);
                            },
                            settings: RouteSettings(name: '/deviceScreen'))),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBluePlus.isScanning,
          initialData: false,
          ///两个FloatingActionButton用来控制扫描和停止扫描
          builder: (c, snapshot) {
            ///这个条件设置的有意思：如果正在扫描就运行，或者获取不到扫描值（前面的data为空）则不运行
            if (snapshot.data ?? false) {
              return FloatingActionButton(
                child: const Icon(Icons.stop),
                onPressed: () async {
                  try {
                    FlutterBluePlus.stopScan();
                  } catch (e) {
                    final snackBar = snackBarFail(prettyException("Stop Scan Error:", e));
                    snackBarKeyB.currentState?.removeCurrentSnackBar();
                    snackBarKeyB.currentState?.showSnackBar(snackBar);
                  }
                },
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: const Text("SCAN"),
                  onPressed: () async {
                    try {
                      if (FlutterBluePlus.isScanningNow == false) {
                        // FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
                        ///通过uuid来调过蓝牙设备
                        FlutterBluePlus.startScan(withServices:[Guid(PrivateKey.searchServiceUuid)], timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
                      }
                      snackBarKeyB.currentState?.removeCurrentMaterialBanner();
                      snackBarKeyB.currentState?.showMaterialBanner(materialBanner());
                    } catch (e) {
                      final snackBar = snackBarFail(prettyException("Start Scan Error:", e));
                      snackBarKeyB.currentState?.removeCurrentSnackBar();
                      snackBarKeyB.currentState?.showSnackBar(snackBar);
                    }
                    setState(() {}); // force refresh of connectedSystemDevices
                  });
            }
          },
        ),
      ),
    );
  }
}

///这个是设备详细页面
class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  List<int> _getRandomBytes() {
    final math = Random();
    return [math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)];
  }

  ///这个是第四行详细的实现，是设备详细界面中最复杂的内容，主要内容在ServiceTile和CharacteristicTile中
  ///ServiceTile是一个扩展列表，用来显示服务，因为蓝牙设备有多个服务
  ///CharacteristicTile是具体实现它也是一个扩展列表，用来显示特征值，因为一个服务可以包含多个特征值
  List<Widget> _buildServiceTiles(BuildContext context, List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => CharacteristicTile(
            characteristic: c,
            onReadPressed: () async {
              try {
                await c.read();
                final snackBar = snackBarGood("Read: Success");
                snackBarKeyC.currentState?.removeCurrentSnackBar();
                snackBarKeyC.currentState?.showSnackBar(snackBar);
              } catch (e) {
                final snackBar = snackBarFail(prettyException("Read Error:", e));
                snackBarKeyC.currentState?.removeCurrentSnackBar();
                snackBarKeyC.currentState?.showSnackBar(snackBar);
              }
            },
            onWritePressed: () async {
              try {
                // await c.write(_getRandomBytes(), withoutResponse: c.properties.writeWithoutResponse);
                ///原来使用随机数来发数据 ，我修改成固定数据，用来测试是否有数据回复，仍然没有回复。
                List<int> value = [0xaa,0xbb,0xcc,0x00,0x01,0x02];
                await c.write(value, withoutResponse: c.properties.writeWithoutResponse);
                final snackBar = snackBarGood("Write: Success");
                snackBarKeyC.currentState?.removeCurrentSnackBar();
                snackBarKeyC.currentState?.showSnackBar(snackBar);
                if (c.properties.read) {
                  await c.read();
                }
              } catch (e) {
                final snackBar = snackBarFail(prettyException("Write Error:", e));
                snackBarKeyC.currentState?.removeCurrentSnackBar();
                snackBarKeyC.currentState?.showSnackBar(snackBar);
              }
            },
            onNotificationPressed: () async {
              try {
                String op = c.isNotifying == false ? "Subscribe" : "Unubscribe";
                await c.setNotifyValue(c.isNotifying == false);
                final snackBar = snackBarGood("$op : Success");
                snackBarKeyC.currentState?.removeCurrentSnackBar();
                snackBarKeyC.currentState?.showSnackBar(snackBar);
                if (c.properties.read) {
                  await c.read();
                }
              } catch (e) {
                final snackBar = snackBarFail(prettyException("Subscribe Error:", e));
                snackBarKeyC.currentState?.removeCurrentSnackBar();
                snackBarKeyC.currentState?.showSnackBar(snackBar);
              }
            },
            descriptorTiles: c.descriptors
                .map(
                  (d) => DescriptorTile(
                descriptor: d,
                onReadPressed: () async {
                  try {
                    await d.read();
                    final snackBar = snackBarGood("Read: Success");
                    snackBarKeyC.currentState?.removeCurrentSnackBar();
                    snackBarKeyC.currentState?.showSnackBar(snackBar);
                  } catch (e) {
                    final snackBar = snackBarFail(prettyException("Read Error:", e));
                    snackBarKeyC.currentState?.removeCurrentSnackBar();
                    snackBarKeyC.currentState?.showSnackBar(snackBar);
                  }
                },
                onWritePressed: () async {
                  try {
                    await d.write(_getRandomBytes());
                    final snackBar = snackBarGood("Write: Success");
                    snackBarKeyC.currentState?.removeCurrentSnackBar();
                    snackBarKeyC.currentState?.showSnackBar(snackBar);
                  } catch (e) {
                    final snackBar = snackBarFail(prettyException("Write Error:", e));
                    snackBarKeyC.currentState?.removeCurrentSnackBar();
                    snackBarKeyC.currentState?.showSnackBar(snackBar);
                  }
                },
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

  ///设备详情页面的build方法，该页面包含以下内容
  ///1. 标题，appBar,复杂的是appBar中的Action
  ///2. body中一个是列布局的scrollView,主要包含4列
  /// 第1列是一个设备id,或者叫MAC也可以
  /// 第2列是 是一个ListTile组合：leading为蓝牙图标，title为设备名是否连接，tail是按钮用来获取service
  /// 第3列显示MTU值，它也是一个ListTile，trailing是点击按钮可以修改该值
  /// 第4列用来显示服务，服务比较多，分多行显示，
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          ///页面标题左侧是设备名称
          title: Text(device.localName),
          ///页面标题右侧是按钮：比较复杂：
          ///如果正在连接中就显示圆形进度条,否则用文字显示连接状态
          ///这里依据值来切换不同的widget，因此使用了ValueListenableBuilder这个局部刷新组件
          actions: <Widget>[
            StreamBuilder<BluetoothConnectionState>(
              stream: device.connectionState,
              initialData: BluetoothConnectionState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothConnectionState.connected:
                    onPressed = () async {
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(true);
                      isConnectingOrDisconnecting[device.remoteId]!.value = true;
                      try {
                        await device.disconnect();
                        final snackBar = snackBarGood("Disconnect: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = snackBarFail(prettyException("Disconnect Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(false);
                      isConnectingOrDisconnecting[device.remoteId]!.value = false;
                    };
                    text = 'DISCONNECT';
                    break;
                  case BluetoothConnectionState.disconnected:
                    onPressed = () async {
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(true);
                      isConnectingOrDisconnecting[device.remoteId]!.value = true;
                      try {
                        await device.connect(timeout: Duration(seconds: 35));
                        final snackBar = snackBarGood("Connect: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = snackBarFail(prettyException("Connect Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(false);
                      isConnectingOrDisconnecting[device.remoteId]!.value = false;
                    };
                    text = 'CONNECT';
                    break;
                  default:
                    onPressed = null;
                    text = snapshot.data.toString().split(".").last.toUpperCase();
                    break;
                }
                return ValueListenableBuilder<bool>(
                    valueListenable: isConnectingOrDisconnecting[device.remoteId]!,
                    builder: (context, value, child) {
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(false);
                      if (isConnectingOrDisconnecting[device.remoteId]!.value == true) {
                        // Show spinner when connecting or disconnecting
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black12,
                              color: Colors.black26,
                            ),
                          ),
                        );
                      } else {
                        return TextButton(
                            onPressed: onPressed,
                            child: Text(
                              text,
                              style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
                            ));
                      }
                    });
              },
            ),
          ],
        ),
        ///主页面的滚动组件
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<BluetoothConnectionState>(
                stream: device.connectionState,
                initialData: BluetoothConnectionState.connecting,
                builder: (c, snapshot) => Column(
                  children: [
                    /// 第1列是一个设备id,或者叫MAC也可以
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${device.remoteId}'),
                    ),
                    /// 第2列是 是一个ListTile组合：leading为蓝牙图标和RSSI值，title为设备名+是否连接，tail是按钮用来获取service
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data == BluetoothConnectionState.connected
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth_disabled),
                          snapshot.data == BluetoothConnectionState.connected
                              ? StreamBuilder<int>(
                              stream: rssiStream(maxItems: 1),
                              builder: (context, snapshot) {
                                return Text(snapshot.hasData ? '${snapshot.data}dBm' : '',
                                    style: Theme.of(context).textTheme.bodySmall);
                              })
                              : Text('', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      title: Text('Device is ${snapshot.data.toString().split('.')[1]}.'),
                      trailing: StreamBuilder<bool>(
                        stream: device.isDiscoveringServices,
                        initialData: false,
                        builder: (c, snapshot) => IndexedStack(
                          index: (snapshot.data ?? false) ? 1 : 0,
                          children: <Widget>[
                            TextButton(
                              child: const Text("Get Services"),
                              onPressed: () async {
                                try {
                                  await device.discoverServices();
                                  final snackBar = snackBarGood("Discover Services: Success");
                                  snackBarKeyC.currentState?.removeCurrentSnackBar();
                                  snackBarKeyC.currentState?.showSnackBar(snackBar);
                                } catch (e) {
                                  final snackBar = snackBarFail(prettyException("Discover Services Error:", e));
                                  snackBarKeyC.currentState?.removeCurrentSnackBar();
                                  snackBarKeyC.currentState?.showSnackBar(snackBar);
                                }
                              },
                            ),
                            const IconButton(
                              icon: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                                ),
                                width: 18.0,
                                height: 18.0,
                              ),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ///第3列显示MTU值，它也是一个ListTile，trailing是点击按钮可以修改该值
              StreamBuilder<int>(
                stream: device.mtu,
                initialData: 0,
                builder: (c, snapshot) => ListTile(
                  title: const Text('MTU Size'),
                  subtitle: Text('${snapshot.data} bytes'),
                  trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        try {
                          await device.requestMtu(223);
                          final snackBar = snackBarGood("Request Mtu: Success");
                          snackBarKeyC.currentState?.removeCurrentSnackBar();
                          snackBarKeyC.currentState?.showSnackBar(snackBar);
                        } catch (e) {
                          final snackBar = snackBarFail(prettyException("Change Mtu Error:", e));
                          snackBarKeyC.currentState?.removeCurrentSnackBar();
                          snackBarKeyC.currentState?.showSnackBar(snackBar);
                        }
                      }),
                ),
              ),
              ///第4列用来显示服务，服务比较多，分多行显示，
              StreamBuilder<List<BluetoothService>>(
                stream: device.servicesStream,
                initialData: const [],
                builder: (c, snapshot) {
                  return Column(
                    children: _buildServiceTiles(context, snapshot.data ?? []),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<int> rssiStream({Duration frequency = const Duration(seconds: 5), int? maxItems = null}) async* {
    var isConnected = true;
    final subscription = device.connectionState.listen((v) {
      isConnected = v == BluetoothConnectionState.connected;
    });
    int i = 0;
    while (isConnected && (maxItems == null || i < maxItems)) {
      try {
        yield await device.readRssi();
      } catch (e) {
        print("Error reading RSSI: $e");
        break;
      }
      await Future.delayed(frequency);
      i++;
    }
    // Device disconnected, stopping RSSI stream
    subscription.cancel();
  }
}

String prettyException(String prefix, dynamic e) {
  if (e is FlutterBluePlusException) {
    return "$prefix ${e.description}";
  } else if (e is PlatformException) {
    return "$prefix ${e.message}";
  }
  return prefix + e.toString();
}

///下面的内容是来自widgets.dart文件中
// Copyright 2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  ///扩展列表的标题，点击此标题可以打开扩展列表
  ///如果扫描到的设备有设备名，就显示设备名和MAC(也就是代码中的ID）
  ///如果扫描到的设备没有设备名，就只显示MAC(也就是代码中的ID）
  Widget _buildTitle(BuildContext context) {
    if (result.device.localName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.localName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.remoteId.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
    } else {
      return Text(result.device.remoteId.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'.toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString()),
      trailing: ElevatedButton(
        ///这个style可以自动button中文字和背景的配色
        child: const Text('CONNECT'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          // backgroundColor: Colors.blue,
          // foregroundColor: Colors.green,
        ),
        ///把onPressed属性设置为null后按钮处于disable状态：变灰色，而且没有任何点击效果
        ///如果设备不可连接那么将按钮设置为灰色
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      children: <Widget>[
        _buildAdvRow(context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level', '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(context, 'Manufacturer Data', getNiceManufacturerData(result.advertisementData.manufacturerData)),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data', getNiceServiceData(result.advertisementData.serviceData)),
      ],
    );
  }
}

///自定义的组件主要封装了可折叠列表，ExpansionTile。
class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key? key, required this.service, required this.characteristicTiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.isNotEmpty) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Service'),
            Text('0x${service.serviceUuid.toString().toUpperCase()}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle: Text('0x${service.serviceUuid.toString().toUpperCase()}'),
      );
    }
  }
}

///这个是嵌套在扩展列表中列表，它本身也是一个扩展列表。列表中依据character的读写特性来决定是否可读写。
///该列表还见嵌套一个列表DescriptorTile,用来读写Descriptor。
class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final Future<void> Function()? onReadPressed;
  final Future<void> Function()? onWritePressed;
  final Future<void> Function()? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
        required this.characteristic,
        required this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.onValueReceived,
      initialData: widget.characteristic.lastValue,
      builder: (context, snapshot) {
        final List<int>? value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Characteristic'),
                Text(
                  '0x${widget.characteristic.characteristicUuid.toString().toUpperCase()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                Row(
                  children: [
                    if (widget.characteristic.properties.read)
                      TextButton(
                          child: Text("Read"),
                          onPressed: () async {
                            await widget.onReadPressed!();
                            setState(() {});
                          }),
                    if (widget.characteristic.properties.write)
                      TextButton(
                          child: Text(widget.characteristic.properties.writeWithoutResponse ? "WriteNoResp" : "Write"),
                          onPressed: () async {
                            await widget.onWritePressed!();
                            setState(() {});
                          }),
                    if (widget.characteristic.properties.notify || widget.characteristic.properties.indicate)
                      TextButton(
                          child: Text(widget.characteristic.isNotifying ? "Unsubscribe" : "Subscribe"),
                          onPressed: () async {
                            await widget.onNotificationPressed!();
                            setState(() {});
                          })
                  ],
                )
              ],
            ),
            ///这个value就是读写操作以及notify操作返回的结果，它是通过streamBuilder监听stream后得到的数据
            subtitle: Text(value.toString()),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: widget.descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;

  const DescriptorTile({Key? key, required this.descriptor, this.onReadPressed, this.onWritePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          Text('0x${descriptor.descriptorUuid.toString().toUpperCase()}',
              style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.onValueReceived,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key? key, required this.adapterState}) : super(key: key);

  final BluetoothAdapterState adapterState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${adapterState.toString().split(".").last}',
          style: Theme.of(context).primaryTextTheme.titleSmall,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.titleSmall?.color,
        ),
      ),
    );
  }
}

SnackBar snackBarGood(String message) {
  return SnackBar(content: Text(message), backgroundColor: Colors.blue);
}

SnackBar snackBarFail(String message) {
  return SnackBar(content: Text(message), backgroundColor: Colors.red);
}

///添加一个banner:在ActionBar下面和程序主页面之间显示，有点类似类似通知
///它和snackbar相呼应，不过它不像snackBar可以自动消失，只有主动关闭时它才会消失
///content可以理解为标题，leading在content前面
///action是list,官方建议使用TextButton。类似Dialog下面的两个button.
MaterialBanner materialBanner() {
  return MaterialBanner(
    leading: Icon(Icons.notifications_active),
    content:Text('MaterialBanner'),
    actions:[
      TextButton(
        onPressed:(){ snackBarKeyB.currentState?.removeCurrentMaterialBanner();},
        child:Text('Yes'),),
      TextButton(onPressed:(){} , child: Text('No'),),
    ],
  );
}