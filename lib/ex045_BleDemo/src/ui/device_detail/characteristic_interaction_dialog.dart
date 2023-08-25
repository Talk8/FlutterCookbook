import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';
import 'package:fluttercookbook/ex045_BleDemo//src/ble/ble_device_interactor.dart';
import 'package:provider/provider.dart';

class CharacteristicInteractionDialog extends StatelessWidget {
  const CharacteristicInteractionDialog({
    required this.characteristic,
    ///增加这四个参数是为了通过上一级把参数传递到dialog中，因为当前无法通过provider获取到这四个值
    ///但是在上一级可以通过consumer获取到这四个值
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.writeWithoutResponse,
    required this.subscribeToCharacteristic,

    required this.bcontext,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
  readCharacteristic;
  final Future<void> Function(
      QualifiedCharacteristic characteristic, List<int> value)
  writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
  subscribeToCharacteristic;

  final Future<void> Function(
      QualifiedCharacteristic characteristic, List<int> value)
  writeWithoutResponse;
  final BuildContext bcontext;

  @override
  // Widget build(BuildContext bcontext) => Consumer<BleDeviceInteractor>(
  // builder: (BuildContext bcontext,interactor,_) => _CharacteristicInteractionDialog(
  Widget build(BuildContext context) => _CharacteristicInteractionDialog(
  characteristic: characteristic,
            ///默认代码：通过consumer获取参数值
            // readCharacteristic: interactor.readCharacteristic,
            // writeWithResponse: interactor.writeCharacteristicWithResponse,
            // writeWithoutResponse: interactor.writeCharacteristicWithoutResponse,
            // subscribeToCharacteristic: interactor.subScribeToCharacteristic,
    ///尝试使用provoder读取也不可以，报同样的错误，把context换成从上级传递来的bcontext也不可以，我估计就是dialog获取不到原来的context引起的
        // readCharacteristic: Provider.of<BleDeviceInteractor>(bcontext,listen: false).readCharacteristic,
        // writeWithResponse: Provider.of<BleDeviceInteractor>(bcontext,listen: false).writeCharacteristicWithResponse,
        // writeWithoutResponse: Provider.of<BleDeviceInteractor>(bcontext,listen: false).writeCharacteristicWithoutResponse,
        // subscribeToCharacteristic: Provider.of<BleDeviceInteractor>(bcontext,listen: false).subScribeToCharacteristic,

    readCharacteristic: readCharacteristic,
    writeWithResponse:writeWithResponse,
    writeWithoutResponse: writeWithoutResponse,
    subscribeToCharacteristic: subscribeToCharacteristic,
  );
  // ));
}

class _CharacteristicInteractionDialog extends StatefulWidget {
  const _CharacteristicInteractionDialog({
    required this.characteristic,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.writeWithoutResponse,
    required this.subscribeToCharacteristic,
    Key? key,
  }) : super(key: key);

  final QualifiedCharacteristic characteristic;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;
  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
      subscribeToCharacteristic;

  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithoutResponse;

  @override
  _CharacteristicInteractionDialogState createState() =>
      _CharacteristicInteractionDialogState();
}

class _CharacteristicInteractionDialogState
    extends State<_CharacteristicInteractionDialog> {
  late String readOutput;
  late String writeOutput;
  late String subscribeOutput;
  late TextEditingController textEditingController;
  late StreamSubscription<List<int>>? subscribeStream;

  @override
  void initState() {
    readOutput = '';
    writeOutput = '';
    subscribeOutput = '';
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    subscribeStream?.cancel();
    super.dispose();
  }

  Future<void> subscribeCharacteristic() async {
    subscribeStream =
        widget.subscribeToCharacteristic(widget.characteristic).listen((event) {
      setState(() {
        subscribeOutput = event.toString();
      });
    });
    setState(() {
      subscribeOutput = 'Notification set';
    });
  }

  Future<void> readCharacteristic() async {
    final result = await widget.readCharacteristic(widget.characteristic);
    setState(() {
      readOutput = result.toString();
    });
  }

  List<int> _parseInput() => textEditingController.text
      .split(',')
      .map(
        int.parse,
      )
      .toList();

  Future<void> writeCharacteristicWithResponse() async {
    await widget.writeWithResponse(widget.characteristic, _parseInput());
    setState(() {
      writeOutput = 'Ok';
    });
  }

  Future<void> writeCharacteristicWithoutResponse() async {
    await widget.writeWithoutResponse(widget.characteristic, _parseInput());
    setState(() {
      writeOutput = 'Done';
    });
  }

  Widget sectionHeader(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );

  List<Widget> get writeSection => [
        sectionHeader('Write characteristic'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Value',
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
          ),
        ),
    ///这两个button宽度超出屏幕宽度，有报错现象：A RenderFlex overflowed by 8.3 pixels on the right.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: writeCharacteristicWithResponse,
              child: const Text('With response'),
            ),
            ElevatedButton(
              onPressed: writeCharacteristicWithoutResponse,
              child: const Text('Without response'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8.0),
          child: Text('Output: $writeOutput'),
        ),
      ];

  List<Widget> get readSection => [
        sectionHeader('Read characteristic'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: readCharacteristic,
              child: const Text('Read'),
            ),
            Text('Output: $readOutput'),
          ],
        ),
      ];

  List<Widget> get subscribeSection => [
        sectionHeader('Subscribe / notify'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: subscribeCharacteristic,
              child: const Text('Subscribe'),
            ),
            Text('Output: $subscribeOutput'),
          ],
        ),
      ];

  Widget get divider => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Divider(thickness: 2.0),
      );

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Select an operation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  widget.characteristic.characteristicId.toString(),
                ),
              ),
              divider,
              ...readSection,
              divider,
              ...writeSection,
              divider,
              ...subscribeSection,
              divider,
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('close')),
                ),
              )
            ],
          ),
        ),
      );
}
