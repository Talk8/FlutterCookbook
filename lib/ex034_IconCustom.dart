import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExIconCustom extends StatefulWidget {
  const ExIconCustom({Key? key}) : super(key: key);

  @override
  State<ExIconCustom> createState() => _ExIconCustomState();
}

class _ExIconCustomState extends State<ExIconCustom> {
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
