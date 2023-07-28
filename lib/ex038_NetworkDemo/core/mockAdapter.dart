import 'package:dio/dio.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/networkAdapter.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/request/base_request.dart';

class MockAdapter extends NetworkAdapter{
  @override
  Future<Response> send<T>(BaseRequest request) {
    // TODO: implement send
    ///自定义修改数据内容，用来调试网络操作流程
    return Future<Response>.delayed(Duration(seconds: 1),
            () {
          return Response(requestOptions: RequestOptions(), statusCode: 200, statusMessage: "success-200", data:{"statusCode":200,"data":{"code":"jsondata"}});
        });
  }
}