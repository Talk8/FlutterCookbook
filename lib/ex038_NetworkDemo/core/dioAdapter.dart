import 'package:dio/dio.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/networkAdapter.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/networkException.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/request/base_request.dart';

///dio适配器，其功能和mockAdapter类似，主要用来切换
class DioAdapter extends NetworkAdapter {
  @override
  Future<Response> send<T>(BaseRequest request) async {
    // TODO: implement send
    var options= BaseOptions(
      baseUrl: request.baseUrl(),
      queryParameters: request.queryParams,
      headers: request.headerParams,
      sendTimeout: const Duration(seconds: 20),
    );

    // var mDio = Dio(options);
    var mDio = Dio();
    Response? response;
    DioException? exception;

    ///添加拦截器
    Interceptor _interceptor = InterceptorsWrapper(
      onRequest: (options,handler) {
        // print('request: '+ options.toString());
        print('request: baseUrl: '+ options.baseUrl);
        print('request: path: '+ options.path);
        print('request: url: '+ options.uri.toString());
        print('request: queryParams: '+ options.queryParameters.toString());
        return handler.next(options);
      },
      onResponse: (response,handler){
        print('response at interceptor: ' + response.toString());
        return handler.next(response);
      },
      onError: (error,handler) {
        print('response error: ' + error.toString());
        return handler.next(error);
      },
    );

    ///添加拦截器
    mDio.interceptors.add(_interceptor);

    ///添加转换器
    mDio.transformer = CustomTransform();

    try {
      switch (request.httpMethod()) {
        case HttpMethod.get:
          ///url()方法在uri.http()方法生成url时已经添加queryParams,这里就不需要再添加了,不然生成的url
          ///是错误的，它会包含两个queryParams
          // response = await mDio.get(request.url(),queryParameters: request.queryParams);
          response = await mDio.get(request.url());
          break;
        case HttpMethod.post:
          response = await mDio.post(request.url(), data: request.queryParams,);
          break;
        case HttpMethod.delete:
          response = await mDio.post(request.url(), data: request.queryParams,);
          break;
      }
    }on DioException catch(e) {
      print("dio adapter exception");
      exception = e;
      return Future.error(e);
    }catch (e) {
      print('other exception: ');
      return Future.error(e);
    }


    // print("code: ${response.statusMessage}, statusMessage: ${response.statusMessage}, data: ${response.data.toString()}");

    // return NetworkResponse(baseRequest: request, statusCode:response.statusCode, statusMessage: response.statusMessage, data:response.data);
    print('return data at dio adapter: ${response.data}, all: ${response.toString()}');
    // return response.data;
    return response;
  }
}

///自定义的转换器，可以使用dio的提供的SyncTransformer
class CustomTransform extends Transformer {
  @override
  Future<String> transformRequest(RequestOptions options) {
    // TODO: implement transformRequest
    print('transformRequest running');
    return Future.value('request');
  }

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    // TODO: implement transformResponse
    print('transformResponse running');
    return Future.value('response');
  }
}