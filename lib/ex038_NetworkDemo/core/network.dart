import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/mockAdapter.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/networkException.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/request/base_request.dart';

///封装请求，错误，返回数据处理
class NetworkWrapper {
  NetworkWrapper ._();
  static NetworkWrapper? _instance;

  static NetworkWrapper? getInstance() {
    _instance ??= NetworkWrapper._();

    return _instance;
  }

  ///封装网络操作方法，它调用适配器中的网络操作方法
  Future<T> fire<T> (BaseRequest baseRequest) async {
    var response;
    NetworkException exception;
    int? statusCode;

    try {
      response = await send(baseRequest);
    } on NetworkException catch(e) {
      exception = e;
      response = e.data;
      debugPrint('errorCode: ${e.code}, message: ${e.message}');
    }catch(e) { //捕获自定义异常以外的其它异常
      debugPrint("fire func: ${e.toString()}");
      throw e;
    }

    if(response == null) {
      print("response is null");
    }

    return response;
  }

    Future<Response> send<T> (BaseRequest baseRequest) async {
    /*
    ///测试用的数据
    debugPrint("url: ${baseRequest.url()}");
    debugPrint("method: ${baseRequest.httpMethod()}");
    baseRequest.addHeader("token", "token_value");
    debugPrint("Header: ${baseRequest.headerParams}");

    return Future.value({"statusCode":200,"data":{"code":""}});
     */

    ///通过不同的适配器切换不同的网络请求库
    MockAdapter mockAdapter = MockAdapter();
    var result = await mockAdapter.send(baseRequest);
    return result;

    ///使用dio适配器进行网络操作
    // DioAdapter dioAdapter = DioAdapter();
    // // var response;
    // Response response;
    // try {
    //   response = await dioAdapter.send(baseRequest);
    // } on DioException catch(e) {
    //   print("adapter throw exception");
    //   rethrow;
    // }
    // return response;
    // Future<Map>.delayed(Duration(seconds: 1),
    //         () { return response?.data; });
   }
}