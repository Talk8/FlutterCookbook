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
      ///在testRequest中已经包含，不需要在这里设置，不然就会报重复设置的错误
      // baseUrl: request.baseUrl(),
      // queryParameters: request.queryParams,
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
        ///调试时再打开，主要有来显示请求相关的数据
        // print('request: '+ options.toString());
        // print('request: baseUrl: '+ options.baseUrl);
        // print('request: path: '+ options.path);
        // print('request: url: '+ options.uri.toString());
        // print('request: queryParams: '+ options.queryParameters.toString());
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

///自定义的转换器，可以使用dio的提供的SyncTransformer,在PUT,POST和PATCH请求中才有效果
class CustomTransform extends BackgroundTransformer{
  ///在PUT,POST和PATCH请求中才会回调
  @override
  Future<String> transformRequest(RequestOptions options) {
    // TODO: implement transformRequest
    print('transformRequest running');
    return super.transformRequest(options);
  }

  ///除了PUT,POST和PATCH请求外，GET请求中也会回调
  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    // TODO: implement transformResponse
    print('transformResponse running');
    ///转换返回的数据 为string: response
    // return Future.value('response');
    ///不转换数据
    return super.transformResponse(options, response);
  }
}