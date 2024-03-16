import 'package:dio/dio.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/request/base_request.dart';
import 'dart:convert';

///封装网络操作返回的结果类型
class NetworkResponse<T> {
 BaseRequest baseRequest;
 int? statusCode;
 String?  statusMessage;
 T data;
 dynamic extras;

 NetworkResponse(
     {required this.baseRequest, required this.statusCode,
       required this.statusMessage,required this.data, this.extras});

  @override
  String toString() {
    String result;
    // TODO: implement toString
    if(data is Map) {
      result = const JsonEncoder().convert(data);
    }else {
      result = data.toString();
    }
    return result;
  }
}

///封装网络适配器，可以适配不同的网络库
abstract class NetworkAdapter {
  Future<Response> send<T>(BaseRequest request);
}