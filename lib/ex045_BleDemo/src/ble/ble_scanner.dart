import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:flutter_reactive_ble_example/src/ble/reactive_state.dart';
import 'package:fluttercookbook/ex045_BleDemo/src/ble/reactive_state.dart';
import 'package:meta/meta.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <DiscoveredDevice>[];

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  ///测试方法，用来测试consumer中是否获取到了scanner对象
  void debugFunc() {
    print('debugFunc');
  }

  void startScan(List<Uuid> serviceIds) {
    _logMessage('Start ble discovery');
    _devices.clear();
    _subscription?.cancel();
    _subscription =
        _ble.scanForDevices(withServices: serviceIds).listen((device) {
      final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
      ///避免添加重复的设备
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = device;
      } else {
        _devices.add(device);
      }
      _pushState();
    // }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
  }, onError: (Object e)  {
         print('scan error: ${e.toString()}');
        });
  _pushState();
  }

  ///向stream中添加数据
  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}
