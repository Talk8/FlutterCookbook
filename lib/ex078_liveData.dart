import 'dart:async';

import 'package:flutter/material.dart';

class ExCircleAvatar extends StatefulWidget {
  const ExCircleAvatar({super.key});

  @override
  State<ExCircleAvatar> createState() => _ExCircleAvatarState();
}

class _ExCircleAvatarState extends State<ExCircleAvatar> with CallBack {
  final StreamController<String> _dataStreamController = StreamController();

  @override
  void onDataChanged(String data) {
    super.onDataChanged(data);
    _dataStreamController.sink.add(data);
    debugPrint("Callback: $data");
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataStreamController.sink.add("default data");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Example of CircleAvade"),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                changeData("data1");
              },
              child: const Text("Change data"),
            ),
            StreamBuilder(
              stream: _dataStreamController.stream,
              builder: (context, shotData) {
                ///builde中不能显示snackBar
                /*
                if(shotData.data == "data1") {
                  _showSNKBar(context);
                }
                return SizedBox.shrink();

                 */
                return Text("data is: ${shotData.data}");
                // return _showSnackBar(context);
              },
            ),
            ElevatedButton(
              child: const Text("Show SnackBar"),
              onPressed: () {
                _showSNKBar(context);
              },
            ),

            ElevatedButton(
              child: const Text("Show SnackBar later"),
              onPressed: () {
                ///延时显示snackBar
                Future.delayed(const Duration(seconds: 2,),() => _showSnackBar(context,"delay showing"),);
              },
            ),
            ///下面内容与218中的内容匹配
            const SizedBox(height: 8,),
            ///正常的CircleAvatar只在不超过外层容器的大小都可以通过radius来调整它的大小
            Container(
              color: Colors.yellow,
              height: 100,
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 80,
                child: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 8,),
            Container(
              alignment: Alignment.center,
              color: Colors.yellow,
              height: 100,
              ///在ListTile中的CircleAvatar无法通过radius来调整它的大小
              child: ListTile(
                leading: Transform.scale(
                  scale: 2.6,
                  child: const CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 80,
                    child: Icon(Icons.person),
                  ),
                ),
                title: const Text("name"),
                trailing: const Icon(Icons.arrow_right),
              ),
            ),
          ],
        ));
  }

  void _showSNKBar(BuildContext context) {
    //通过showSnackBar方法显示SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("This is SnackBar"),
      backgroundColor: Colors.amberAccent,
      ///behavior设定为floating后才能给width赋值
      behavior: SnackBarBehavior.floating,
      // width: MediaQuery.of(context).size.width-32,
      ///控制snackBar与屏幕之间的距离，相当于外边距，不能与width同时使用
      margin: const EdgeInsets.only(left:16,right:16,bottom:90),
      ///控制snackBar中内容与边框之间的距离，相当于内边距
      // padding: EdgeInsets.only(top: 300),
      ///控制snackBar的宽高比，默认值是0.25
      actionOverflowThreshold: 0.1,
      elevation: 29,
      //修改形状，默认为矩形
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(),
      ),
      //显示时间
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        textColor: Colors.black12,
        label: "SnackBar Action",
        onPressed: () {
          //do nothing
        },
      ),
    ),
    );
  }

  void _showSnackBar(BuildContext context,String content) {
    //通过showSnackBar方法显示SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("This is $content"),
      backgroundColor: Colors.amberAccent,
      ///behavior设定为floating后才能给width赋值
      behavior: SnackBarBehavior.floating,
      // width: MediaQuery.of(context).size.width-32,
      ///控制snackBar与屏幕之间的距离，相当于外边距，不能与width同时使用
      margin: const EdgeInsets.only(left:16,right:16,bottom:90),
      ///控制snackBar中内容与边框之间的距离，相当于内边距
      // padding: EdgeInsets.only(top: 300),
      ///控制snackBar的宽高比，默认值是0.25
      actionOverflowThreshold: 0.1,
      elevation: 29,
      //修改形状，默认为矩形
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(),
      ),
      //显示时间
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        textColor: Colors.black12,
        label: "SnackBar Action",
        onPressed: () {
          //do nothing
        },
      ),
    ),
    );
  }

}

mixin CallBack {
  String _data = "default";

  void changeData(String data) {
    _data = data;
    onDataChanged(_data);
  }

  void onDataChanged(String data) {}
}
