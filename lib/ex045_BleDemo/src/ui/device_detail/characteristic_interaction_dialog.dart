import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';

///这个类是demo中封装的类，主要用来提供数据读写操作的界面，实际项目中可以参考,其缺点是读写数据只返回
///成功与失败，没有具体的值，这个有些遗憾。

///原来的demo想通过它和consumer获取provider中的数据，不过无法获取到，我将其放到了参数中
///真正的页面在_CharacteristicInteractionDialog中
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
    ///尝试使用provider读取也不可以，报同样的错误，把context换成从上级传递来的bcontext也不可以，我估计就是dialog获取不到原来的context引起的
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

///这个类才是真正的数据读写操作页面
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

  ///把Text封装成了标题，主要进行了加粗操作
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

  ///这个封装的divider组件自带边距：垂直方向上12个dp
  Widget get divider => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Divider(thickness: 2.0),
      );

  ///dialog页面布局全在这个build方法中，外层是Dialog组件，组件内是垂直列表布局
  ///最上方是characterId,其它行的内容依次如下：读操作行，写操作行，订阅操作行，最后是一个关闭窗口的按钮
  ///我觉得不如使用AlertDialog，然后在Action中添加按钮，不过把每行和分隔线封装成独立的组件，这个
  ///方法非常好，使得代码非常简洁，而且逻辑有序。它的思路如下：
  ///创建一个ListView,然后把其它widget赋值给ListView。这些widget可以是单个widget，也可以是
  ///多个widget组成的widget List.不管是单个还是多个List,默认都是按照List的垂直布局来排列。
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
