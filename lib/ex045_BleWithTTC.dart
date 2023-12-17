import 'package:flutter/material.dart';
import 'package:flutter_ttc_ble/flutter_ttc_ble.dart';
import 'package:provider/provider.dart';

///这个示例使用flutter_ttc_ble包中的内容实现
class ExBleWithTTC extends StatefulWidget {
  const ExBleWithTTC({super.key});

  @override
  State<ExBleWithTTC> createState() => _ExBleWithTTCState();
}

class _ExBleWithTTCState extends State<ExBleWithTTC> with BleCallback2{
  List<BLEDevice> deviceList = [];
  final _ScanViewModel viewModel = _ScanViewModel();

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
    // TODO: implement onLeScan
    debugPrint("--> add device");
    viewModel.addDevice(device);
    // super.onLeScan(device);
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
              child: ElevatedButton(
                onPressed:  (){
                  bleProxy.startScan();
                },
                child: const Text("Scan Device"),),
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
                          return Text("item : $index ${vm._devices[index].name}");
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

  void _sortDevices() {
    _devices.sort((device1, device2) => device2.rssi - device1.rssi);
    notifyListeners();
  }
}
