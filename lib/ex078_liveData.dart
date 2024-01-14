import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///viewMode的内容与216匹配。within中的内容与220中的内容匹配
///snackBar的代码与213，214的内容匹配
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
    ///在监听到的回调中给stream添加事件,streamBuilder收到后会更新数据
    _dataStreamController.sink.add(data);
    ///按钮中通过changeData()方法模拟其它模块执行回调，这里相当于当前模拟监听到的回调中数据后
    ///通过vm修改数据,这可以看作是在响应其它模块的cb操作
    LiveDataViewModel().name = data;
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
          title: const Text("Example of Circle Avatar and LiveData",style: TextStyle(fontSize: 18),),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                changeData("data1");
              },
              child: const Text("Change data by CB"),
            ),
            ///使用Stream监听回调方法中的数据变化，点击上面的按钮相当于回调方法修改数据
            StreamBuilder(
              stream: _dataStreamController.stream,
              builder: (context, shotData) {
                ///builder中不能显示snackBar
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

            ///通过vm修改数据，然后通过consumer更新数据，数据传递和管理由provide负责。这个和LiveData的原理相同
            const SizedBox(height: 8,),
            Consumer<LiveDataViewModel>(
              builder: (context,shotData,child) {
                return Builder(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Name: ${shotData.name}",),
                        Text("Age: ${shotData.age.toString()}",),
                      ],
                    );
                  }
                );
              }
            ),
            ElevatedButton(
                onPressed: () {
                  ///通过vm来更新数据，注意vm需要使用单例，确保修改和接收的vm相同
                  LiveDataViewModel().name = "Talk8";
                  LiveDataViewModel().age = 66;
                },
                child: const Text("change data by VM"),
            ),

            ///snackBar的代码与213，214的内容匹配
            ///正常显示SnackBar
            ElevatedButton(
              child: const Text("Show SnackBar"),
              onPressed: () {
                _showSNKBar(context);
              },
            ),

            ///延时显示SnackBar
            ElevatedButton(
              child: const Text("Show SnackBar later"),
              onPressed: () {
                ///延时显示snackBar
                Future.delayed(const Duration(seconds: 2,),() => _showSnackBar(context,"delay showing"),);
              },
            ),

            ///延时并且数据有更新时才显示SnackBar,点下按钮修改数据，或者等待cb修改数据。
            ///因为cb是其它模块运行完成后的回调方法，这里只能被动监听回调方法
            ElevatedButton(
              child: const Text("Show SnackBar after data is updated"),
              onPressed: () {

                ///模拟cb修改数据，因为cb是其它模块主动执行的，当前模块只能被动监听cb,监听到后再通过vm修改数据
                changeData("talk8");
                ///主动通过vm修改数据
                // LiveDataViewModel().name = "talk8";
                ///延时显示snackBar
                Future.delayed(const Duration(seconds:2),()=>{})
                    .then((value) {
                  if(LiveDataViewModel().name == "talk8") {
                    _showSnackBar(context, "data is updated");
                  }else {
                    _showSnackBar(context, "data is not updated");
                  }
                }).onError((error, stackTrace) {
                  _showSnackBar(context, "updating data failed");
                });
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

///接口类，用来模拟回调方法
mixin CallBack {
  String _data = "default";

  ///用来模拟其它模块调用回调方法
  void changeData(String data) {
    _data = data;
    onDataChanged(_data);
  }

  void onDataChanged(String data) {}
}



///与LiveData配合使用的viewMode,需要在runApp中的MultiProvide中添加Provide后才可以使用
class LiveDataViewModel extends ChangeNotifier {
  static final liveDataViewModel = LiveDataViewModel._internal();
  String _name = "Unknown";
  int _age = 0;


  // LiveDataViewModel() {
  //   _connected = false;
  //   _connectedDeviceId = "";
  // }



  ///创建单例对象,使用了工厂方法
  LiveDataViewModel._internal();
  factory LiveDataViewModel() => liveDataViewModel;

  int get age => _age;
  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set age(int value) {
    _age = value;
    notifyListeners();
  }
}