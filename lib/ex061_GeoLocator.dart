import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


///使用这个包需要在manifest文件中添加位置权限，IOS在info.plist中添加位置说明
///主要功能，获取当前GPS权限，开关状态，获取位置权限还能打开位置形状页面(仅android)
///获取GPS信息，监听GPS状态和GPS开关状态，使用stream来监听非常方便。与155的内容相匹配
class ExGeoLocator extends StatefulWidget {
  const ExGeoLocator({super.key});

  @override
  State<ExGeoLocator> createState() => _ExGeoLocatorState();
}

class _ExGeoLocatorState extends State<ExGeoLocator> {
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Geo Locator'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: determinePosition,
            child: const Text('Get location'),
          ),
          ///主动监听位置信息
          ElevatedButton(
              onPressed: listenLocationService,
              child: const Text('Listen Geo service'),
          ),
          ///使用stream监听位置信息和服务状态
          StreamBuilder(
            stream: getServiceStream(),
            builder: (context,data){
              return Text("Location: ${data.data.toString()}");
          }),
          StreamBuilder(
            stream: getServiceStatusStream(),
            builder: (context,data){
              return Text("Service Status: ${data.data.toString()}");
          }),
          ///手动更新位置信息
          Text('Location: ${position == null ?'unKnown': position.toString()}'),
        ],
      )
    );
  }

  Future<Position> determinePosition() async {
    bool locationServiceEnabled;
    LocationPermission permission;
    Position? positionResult;

    ///获取位置开关状态，如果没有打开开关就跳转到开关设置页面(仅支持android)
    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!locationServiceEnabled) {
      debugPrint('location service is disabled');
      ///打开位置形状只适用于android，IOS不可以
      Geolocator.openLocationSettings();
      return Future.error('Location service is disabled');
    }

    ///检查位置权限，顺序反了，应该先检查位置权限再检查开关状态
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        positionResult = await Geolocator.getCurrentPosition();
      }else {
        debugPrint('Location permission is denied');
        return Future.error('Location permission is denied');
      }
    }else {
      ///获取最近一次的位置信息和当前位置信息
       positionResult = await Geolocator.getLastKnownPosition();
       positionResult ??= await Geolocator.getCurrentPosition();
    }

    debugPrint('geo: ${positionResult.toString()}');

    setState(() {
      position = positionResult!;
    });
    return Future<Position>.value(positionResult);
  }

  ///手动监听位置信息变化
  void listenLocationService() {
    ///通过设置指定服务的精确度和更新时间
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      ///位置距离，单位是m
      distanceFilter: 100,
      ///不要指定时间限制，不然会出超时异常，因为无法知道什么时候更新数据
      // timeLimit: Duration(seconds: 20),
    );

    StreamSubscription<Position> serviceStatus = Geolocator.getPositionStream(
      locationSettings: locationSettings,).listen(
        (event) { debugPrint('geo updated: ${event.toString()}');},
        onDone: () => debugPrint('service updated done'),
        onError: (error) => debugPrint('service updated error: ${error.toString()}'),
    );

    ///调试使用，可以使用它控制stream.
    debugPrint(serviceStatus.toString());
  }

  ///通过stream监听位置信息变化
  Stream<Position> getServiceStream() {
     ///通过设置指定服务的精确度和更新时间
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      ///位置距离，单位是m
      distanceFilter: 1,
      // timeLimit: Duration(seconds: 20),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  ///通过stream监听位置服务状态:位置开关的变化，比如打开或者关闭
  Stream<ServiceStatus> getServiceStatusStream() {
    return Geolocator.getServiceStatusStream();
  }
}
