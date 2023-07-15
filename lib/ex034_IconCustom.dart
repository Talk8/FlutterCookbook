import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//这个文件中包含了自定义字体图标83，以及异步中的Future和Stream相关的内容
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
    super.dispose();
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
          //通过IconData使用ttf文件中的图标
          Icon(IconData(0x2211,fontFamily:'IconMoon' )),
          //使用自定义类中的图标，可以修改图标和大小和颜色
          Icon(CustomIcon.char_count,size: 40,color: Colors.purpleAccent,),
          //使用自定义类中的图标，图标和大小和颜色使用默认值，图标从网络下载遵守SIL开源协议
          Icon(CustomAppIcon.gplus_circled),
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

//自定义图标类，方便在代码中直接使用
class CustomIcon {
  static const IconData char_e = const IconData(0x13ec, fontFamily: 'IconMoon', matchTextDirection: true,);
  static const IconData char_count = const IconData(0x2211, fontFamily: 'IconMoon', matchTextDirection: true,);
  static const IconData num_16 = const IconData(0x024f0, fontFamily: 'IconMoon', matchTextDirection: true,);
  static const IconData shap_3 = const IconData(0x2206, fontFamily: 'IconMoon', matchTextDirection: true,);
}

//从fluttericon.com下载的图标，类型是Entypo,下面的代码来自下载包中的示例MyFlutterApp.dart,我修改了名字
class CustomAppIcon {
  // MyFlutterApp._();

  // static const _kFontFam = 'MyFlutterApp';
  static const _kFontFam = 'FlutterIconCom';
  static const String? _kFontPkg = null;

  static const IconData note_1 = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData block = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData note_beamed = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData music = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData search_1 = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flashlight = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mail_1 = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData signal = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flight = IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData check_1 = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData menu = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData layout = IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData linkedin_circled = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData water = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData droplet = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData leaf = IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rocket_1 = IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData picasa = IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData play_1 = IconData(0xe812, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stop_1 = IconData(0xe813, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pause = IconData(0xe814, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData to_end = IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData to_start = IconData(0xe816, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData fast_forward = IconData(0xe817, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData fast_backward = IconData(0xe818, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shuffle = IconData(0xe819, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData arrows_ccw = IconData(0xe81a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart_1 = IconData(0xe81b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart_empty = IconData(0xe81c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star_1 = IconData(0xe81d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star_empty = IconData(0xe81e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user = IconData(0xe81f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData users = IconData(0xe820, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData user_add = IconData(0xe821, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData video = IconData(0xe822, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData picture = IconData(0xe823, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData camera = IconData(0xe824, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancel = IconData(0xe825, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancel_circled = IconData(0xe826, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancel_squared = IconData(0xe827, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus_1 = IconData(0xe828, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus_circled = IconData(0xe829, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus_squared = IconData(0xe82a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus = IconData(0xe82b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus_circled = IconData(0xe82c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData minus_squared = IconData(0xe82d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help = IconData(0xe82e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help_circled = IconData(0xe82f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info_1 = IconData(0xe830, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info_circled = IconData(0xe831, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData back = IconData(0xe832, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData home_1 = IconData(0xe833, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData link_1 = IconData(0xe834, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData attach = IconData(0xe835, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lock_1 = IconData(0xe836, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lock_open = IconData(0xe837, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData eye_1 = IconData(0xe838, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tag_1 = IconData(0xe839, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmark_1 = IconData(0xe83a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmarks = IconData(0xe83b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flag = IconData(0xe83c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData thumbs_up = IconData(0xe83d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData thumbs_down = IconData(0xe83e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData download = IconData(0xe83f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData upload = IconData(0xe840, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData upload_cloud = IconData(0xe841, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData reply_1 = IconData(0xe842, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData reply_all = IconData(0xe843, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData forward = IconData(0xe844, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData quote_1 = IconData(0xe845, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData code_1 = IconData(0xe846, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData export_icon = IconData(0xe847, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pencil_1 = IconData(0xe848, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData feather = IconData(0xe849, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData print = IconData(0xe84a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData retweet = IconData(0xe84b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData keyboard_1 = IconData(0xe84c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData comment_1 = IconData(0xe84d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chat = IconData(0xe84e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bell_1 = IconData(0xe84f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData attention = IconData(0xe850, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData alert_1 = IconData(0xe851, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData vcard = IconData(0xe852, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData address = IconData(0xe853, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData location_1 = IconData(0xe854, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData map = IconData(0xe855, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData direction = IconData(0xe856, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData compass = IconData(0xe857, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cup = IconData(0xe858, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData trash = IconData(0xe859, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData doc = IconData(0xe85a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData docs = IconData(0xe85b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData doc_landscape = IconData(0xe85c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData doc_text = IconData(0xe85d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData doc_text_inv = IconData(0xe85e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData newspaper = IconData(0xe85f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData book_open = IconData(0xe860, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData book_1 = IconData(0xe861, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData folder = IconData(0xe862, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData archive_1 = IconData(0xe863, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData box = IconData(0xe864, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rss_1 = IconData(0xe865, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData phone = IconData(0xe866, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cog = IconData(0xe867, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tools_1 = IconData(0xe868, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData share = IconData(0xe869, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shareable = IconData(0xe86a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData basket = IconData(0xe86b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bag = IconData(0xe86c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar_1 = IconData(0xe86d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData login = IconData(0xe86e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logout = IconData(0xe86f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mic = IconData(0xe870, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mute_1 = IconData(0xe871, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sound = IconData(0xe872, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData volume = IconData(0xe873, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clock_1 = IconData(0xe874, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData hourglass = IconData(0xe875, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lamp = IconData(0xe876, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData light_down = IconData(0xe877, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData light_up = IconData(0xe878, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData adjust = IconData(0xe879, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData resize_full = IconData(0xe87a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData resize_small = IconData(0xe87b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData popup = IconData(0xe87c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData publish = IconData(0xe87d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData window = IconData(0xe87e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData arrow_combo = IconData(0xe87f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_circled = IconData(0xe880, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_circled = IconData(0xe881, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_circled = IconData(0xe882, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_circled = IconData(0xe883, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_open = IconData(0xe884, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_open = IconData(0xe885, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_open = IconData(0xe886, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_open = IconData(0xe887, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_open_mini = IconData(0xe888, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_open_mini = IconData(0xe889, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_open_mini = IconData(0xe88a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_open_mini = IconData(0xe88b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_open_big = IconData(0xe88c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_open_big = IconData(0xe88d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_open_big = IconData(0xe88e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_open_big = IconData(0xe88f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down = IconData(0xe890, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left = IconData(0xe891, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right = IconData(0xe892, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up = IconData(0xe893, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_dir = IconData(0xe894, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_dir = IconData(0xe895, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_dir = IconData(0xe896, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_dir = IconData(0xe897, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_bold = IconData(0xe898, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_bold = IconData(0xe899, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_bold = IconData(0xe89a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_bold = IconData(0xe89b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData down_thin = IconData(0xe89c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData left_thin = IconData(0xe89d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData right_thin = IconData(0xe89e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData up_thin = IconData(0xe89f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ccw = IconData(0xe8a0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cw = IconData(0xe8a1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData level_down = IconData(0xe8a2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData level_up = IconData(0xe8a3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData loop = IconData(0xe8a4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData switch_icon = IconData(0xe8a5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData record = IconData(0xe8a6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData progress_0 = IconData(0xe8a7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData progress_1 = IconData(0xe8a8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData progress_2 = IconData(0xe8a9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData progress_3 = IconData(0xe8aa, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData target = IconData(0xe8ab, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData palette = IconData(0xe8ac, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData list = IconData(0xe8ad, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData list_add = IconData(0xe8ae, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData trophy = IconData(0xe8af, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData battery = IconData(0xe8b0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData back_in_time = IconData(0xe8b1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData monitor = IconData(0xe8b2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mobile = IconData(0xe8b3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData network = IconData(0xe8b4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cd = IconData(0xe8b5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData inbox_1 = IconData(0xe8b6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData install = IconData(0xe8b7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData globe_1 = IconData(0xe8b8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cloud = IconData(0xe8b9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cloud_thunder = IconData(0xe8ba, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flash = IconData(0xe8bb, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData moon = IconData(0xe8bc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData paper_plane = IconData(0xe8bd, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lifebuoy = IconData(0xe8be, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mouse = IconData(0xe8bf, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData briefcase_1 = IconData(0xe8c0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData suitcase = IconData(0xe8c1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dot = IconData(0xe8c2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dot_2 = IconData(0xe8c3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dot_3 = IconData(0xe8c4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData brush = IconData(0xe8c5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData magnet = IconData(0xe8c6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData infinity_1 = IconData(0xe8c7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData erase = IconData(0xe8c8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_pie = IconData(0xe8c9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_line = IconData(0xe8ca, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_bar = IconData(0xe8cb, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_area = IconData(0xe8cc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tape = IconData(0xe8cd, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData graduation_cap = IconData(0xe8ce, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData language = IconData(0xe8cf, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ticket = IconData(0xe8d0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData air = IconData(0xe8d1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData credit_card_1 = IconData(0xe8d2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData floppy = IconData(0xe8d3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clipboard = IconData(0xe8d4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData megaphone_1 = IconData(0xe8d5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData database_1 = IconData(0xe8d6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData drive = IconData(0xe8d7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bucket = IconData(0xe8d8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData thermometer = IconData(0xe8d9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData key_1 = IconData(0xe8da, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flow_cascade = IconData(0xe8db, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flow_branch = IconData(0xe8dc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flow_tree = IconData(0xe8dd, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flow_line = IconData(0xe8de, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flow_parallel = IconData(0xe8df, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData gauge = IconData(0xe8e0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData traffic_cone = IconData(0xe8e1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc = IconData(0xe8e2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_by = IconData(0xe8e3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_nc = IconData(0xe8e4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_nc_eu = IconData(0xe8e5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_nc_jp = IconData(0xe8e6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_sa = IconData(0xe8e7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_nd = IconData(0xe8e8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_pd = IconData(0xe8e9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_zero = IconData(0xe8ea, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_share = IconData(0xe8eb, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cc_remix = IconData(0xe8ec, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData github = IconData(0xe8ed, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData github_circled = IconData(0xe8ee, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flickr = IconData(0xe8ef, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flickr_circled = IconData(0xe8f0, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData vimeo = IconData(0xe8f1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData vimeo_circled = IconData(0xe8f2, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData twitter = IconData(0xe8f3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData twitter_circled = IconData(0xe8f4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook = IconData(0xe8f5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook_circled = IconData(0xe8f6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook_squared = IconData(0xe8f7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData gplus = IconData(0xe8f8, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData gplus_circled = IconData(0xe8f9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pinterest = IconData(0xe8fa, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pinterest_circled = IconData(0xe8fb, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tumblr = IconData(0xe8fc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tumblr_circled = IconData(0xe8fd, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData linkedin = IconData(0xe8fe, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dribbble = IconData(0xe8ff, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dribbble_circled = IconData(0xe900, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stumbleupon = IconData(0xe901, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stumbleupon_circled = IconData(0xe902, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lastfm = IconData(0xe903, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lastfm_circled = IconData(0xe904, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rdio = IconData(0xe905, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rdio_circled = IconData(0xe906, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData spotify = IconData(0xe907, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData spotify_circled = IconData(0xe908, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData qq = IconData(0xe909, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData instagram = IconData(0xe90a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dropbox = IconData(0xe90b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData evernote = IconData(0xe90c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData flattr = IconData(0xe90d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData skype = IconData(0xe90e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData skype_circled = IconData(0xe90f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData renren = IconData(0xe910, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sina_weibo = IconData(0xe911, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData paypal = IconData(0xe912, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData soundcloud = IconData(0xe913, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mixi = IconData(0xe914, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData behance = IconData(0xe915, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData google_circles = IconData(0xe916, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData vkontakte = IconData(0xe917, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData smashing = IconData(0xe918, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData db_shape = IconData(0xf600, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sweden = IconData(0xf601, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logo_db = IconData(0xf603, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
