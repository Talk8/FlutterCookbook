import 'package:flutter/material.dart';

class ExWillPopScope extends StatefulWidget {
  const ExWillPopScope({Key? key}) : super(key: key);

  @override
  State<ExWillPopScope> createState() => _ExWillPopScopeState();
}

class _ExWillPopScopeState extends State<ExWillPopScope> {
  ///用来记录上次点击时间
  DateTime? _lastPressedTime;

  Future<bool> _backIconOnPress() async {
    ///两次点击间隔小于3s时才退出当前页面:return true;
    if(_lastPressedTime == null
        || DateTime.now().difference(_lastPressedTime!) > const Duration(seconds: 3)) {
      _lastPressedTime = DateTime.now();
      debugPrint('false');
      return Future.value(false);
    }else {
      debugPrint('true');
      return Future.value(true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backIconOnPress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example of WillPopScope Widget'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: const Center(
            child: Text('连续两次点击小于3s时才能退出页面'),
        ),
      ),
    );
  }
}
