import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttercookbook/ex045_ExBleAll.dart';
import 'package:provider/provider.dart';

///与133内容相匹配
class ExStreamProvider extends StatefulWidget {
  const ExStreamProvider({Key? key}) : super(key: key);

  @override
  State<ExStreamProvider> createState() => _ExStreamProviderState();
}

class _ExStreamProviderState extends State<ExStreamProvider> {
  ///多种创建stream的方法
  Stream<String> _stream1 = Stream.value('init data');
  ///每隔3s运行一次，一共运行3次,periodic方法只能递增，可以看源代码。247回内容做了分析
  final Stream<int> _stream2 = Stream.periodic(const Duration(seconds: 3,),(count) => (count+1)).take(3);

  ///通过streamController自动创建stream，给Controller添加事件就可以自动生成stream.
  final _streamController = StreamController();

  ///通过async/yield创建stream
  Stream<String> _createSteam() async* {
    var index = 5;
    while(index-- >0 ) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateTime.now().toString();
    }
  }

  Stream<String> createSteam() async* {
    var index = 5;
    while(index-- >0 ) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateTime.now().toString();
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    Future.value();
    ///对stream中的事件进行转换和过滤操作
    _stream1.map((event) => (event+'map func')).where((event) => (event == 'a'));
    ///去掉stream中重复的事件流
    _stream1.distinct();

    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of StreamProvider'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///给controller中添加stream或者添加事件源，然后监听stream中创建的日期
          ElevatedButton(
            onPressed: () { _streamController.sink.addStream(_createSteam()); },
            // onPressed: () { _streamController.sink.add('add event'); },
            child: const Text("Create Stream"),
          ),
          ///监听上一步中产生的stream:没有点击时显示no data,点击后会显示add event
          StreamBuilder(
            stream: _streamController.stream,
            builder: (context,data){
              var str = data.data == null? 'no data' : data.data.toString();
              return Text("date of Stream: $str");
            },),
          ///监听stream2:每隔3s显示一次stream中的数字
          StreamBuilder<int>(
            stream: _stream2,
            builder: (context,data){
              var str = data.data == null? 'no value' : data.data.toString();
              return Text("value of Stream: $str");
            },),
          ///监听StreamProvider中的数据，这个数据源在main文件中
          Consumer<int>(
              builder: (context,data,_){
                return Text("value: $data");
          }),
          ///监听Provider.value产生的数据，这个数据源在main文件中
          Consumer<TestConsumer>(
              builder: (context,data,_){
                data.func();
                return const Text('Test Consumer');
          }),
        ],
      ),
    );
  }
}
