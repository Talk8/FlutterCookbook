import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExIconCustom extends StatefulWidget {
  const ExIconCustom({Key? key}) : super(key: key);

  @override
  State<ExIconCustom> createState() => _ExIconCustomState();
}

class _ExIconCustomState extends State<ExIconCustom> {
  //用来存放stream listen方法返回的结果
  late StreamSubscription<String> _streamSubscription;
  late Stream<String> _eventStream;
  //不同形式的streamController
  late StreamController<String> _streamController;
  late StreamController<Future<String>> _futureStreamController;

  Future<void> _launchUrl()async {
    var url = 'https://pub.dev';
      if(!await launchUrl(Uri.parse(url))) {
      throw Exception('could not launch url');
    }

      //通过scheme指定
    /*
    Uri uri = Uri(scheme: 'https',
        path: 'www.baidu.com');
    if(!await launchUrl(uri)) {
      throw Exception('could not launch url');
    }
     */
  }

  //通过Future实现异步操作
   _syncLaunch() {
    print("func start");
    Future.wait([
      Future.delayed(Duration(seconds: 3),() {
        print("launch url");
        launchUrl(Uri.parse('https://pub.dev'));
      })
    ])
    .then((value) => print("then running"))
    .catchError((e){
      print("error: "+e.toString());
    })
    .whenComplete(() => print("complete running"));
    print("func end");
  }

  //通过Stream实现异步操作，程序运行结果可以参考77，78回的内容
  _syncMultiLauncher() {
    Stream.fromFutures([
      Future.delayed(Duration(seconds: 2),()=>debugPrint('do one'),),
      // Future.delayed(Duration(seconds: 2),()=>debugPrint('do two'),),
      Future.delayed(Duration(seconds: 2),(){throw AssertionError();},),
      Future.delayed(Duration(seconds: 2),()=>debugPrint('do three'),),
    ])
    .listen(
      (event) {print('onData');},
      onDone:() => print('onDone'),
      onError: (v) => print('onError'),
    );
  }

  @override
  void initState() {

   //带有数据的事件流，数据类型为string
    _eventStream = Stream.fromFutures([
      _eventOne(),
      _eventTwo(),
      _eventThree(),
    ]);

    //使用streamController管理stream，先初始化它
    _streamController = StreamController<String>();
    _futureStreamController = StreamController();
  }


  //最后记得关闭stream
  @override
  void dispose() {
    _streamController.close();
    _futureStreamController.close();
  }

  //使用方法抽象出三个事件
  Future<String> _eventOne() async{
    await Future.delayed(Duration(seconds: 2),()=>debugPrint('do one'),);
    return 'Event One';
  }

  Future<String> _eventTwo() async{
    await Future.delayed(Duration(seconds: 2),()=>debugPrint('do two'),);
    throw "Event exception";
  }


  Future<String> _eventThree() async{
    await Future.delayed(Duration(seconds: 2),()=>debugPrint('do three'),);
    return 'Event Three';
  }


  //封装三个方法，它们用在stream的listen方法中
  _onData(data) => debugPrint("onData: $data");
  _onError(error) => debugPrint("onError: $error");
  _onDone() => debugPrint("onDone:");

  //通过stream的返回值来管理stream,对应79回中的内容
  //注意管理的是listen以及listen中三个方法，stream中的Future方法不在管理范围内
  void _startStream() {
    _streamSubscription = _eventStream.listen(_onData,onError:_onError ,onDone:_onDone);
  }
  void _resumeStream() {
    _streamSubscription.resume();
  }

  void _pauseStream() {
    _streamSubscription.pause();
  }

  void _cancelStream() {
    _streamSubscription.cancel();
  }

  //使用方法封装数据然后添加到事件流中
  String _eventFunc() {
    return 'event Func';
  }

  //这种方法添加到事件流中后会中断事件流，不会走到onError方法中
  String _eventFuncError() {
    throw "func error";
    return 'event Func error';
  }

  //使用streamController向stream中添加事件,事件类型是泛型与controller类型相同,对应80回的内容
  void _useingStreamController() {
    //向stream中添加数据，这里的数据是简单的字符串，复杂点的可以做成方法返回string
    _streamController.add("event one1");
    _streamController.add("event one2");
    _streamController.add("event one3");
    //添加封装的方法到事件流中
    _streamController.add(_eventFunc());
    // _streamController.add(_eventFuncError());

    //监听事件流中的事件
    //注意如果在streamBuilder中使用该stream,那么不能再次监听，不然会后重复监听的运行时错误
    //Bad state: Stream has already been listened to.
    // _streamController.stream.listen(
    //   _onData,
    //   onError: _onError,
    //   onDone: _onDone,
    // );

    _futureStreamController.add(_eventOne());
    //产生异常的方法仍然会中断事件流
    // _futureStreamController.add(_eventTwo());
    _futureStreamController.add(_eventThree());
    _futureStreamController.stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Example of Custom Icon'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add),
          IconButton(
              // onPressed: _launchUrl,
            // onPressed: _syncLaunch,
            onPressed: _syncMultiLauncher,
            icon:Icon(Icons.web_rounded),
          ),
          //下面的按钮就用显示stream的管理：启动，暂停，停止
          ElevatedButton(
              onPressed: _startStream,
              child:Text('Start Stream') ),
          ElevatedButton(
              onPressed: _pauseStream,
              child:Text('Pause Stream') ),
          ElevatedButton(
              onPressed: _resumeStream,
              child:Text('Resume Stream') ),
          ElevatedButton(
              onPressed: _cancelStream,
              child:Text('Cancel Stream') ),
          ElevatedButton(
              onPressed: _useingStreamController,
              child:Text('StreamController') ),
          //streamBuilder可以自动监听事件流，并且把事件流中的数据输出到组件上，对应80回的内容
          StreamBuilder(
            initialData: "default",
            stream: _streamController.stream,
            builder: (context,dataSource){
              return Text('${dataSource.data}');
            },
          ),
        ],
      ),
    );
  }
}

class CustomIcon {
  static const IconData book = const IconData(
    0x0001,
    fontFamily: 'IconMoon',
    matchTextDirection: true,
  );
}
