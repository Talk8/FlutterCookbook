import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ExNetworkDio extends StatefulWidget {
  const ExNetworkDio({Key? key}) : super(key: key);

  @override
  State<ExNetworkDio> createState() => _ExNetworkDioState();
}

class _ExNetworkDioState extends State<ExNetworkDio> {
  var _mDio = Dio();
  var _getType = "https://httpbin.org/get";
  var _getTypeUUID = "https://httpbin.org/uuid";
  var _postType = "https://httpbin.org/post";

  @override
  Widget build(BuildContext context) {
    _getRequest() {
      _mDio.get(_getType).then((value) {
        debugPrint(value.toString());
      });
    }

    _postRequest() {
      _mDio.post(_postType).then((value) => debugPrint(value.toString()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Example of Network'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              debugPrint('get button clicked');
              ///使用自定义的方法或者封装类中的静态方法发起GET请求
              // _getRequest();
              HttpRequest.request(_getTypeUUID,method: 'get', params: {"uuid":"a19da"})
              .then((value) => print('receive data ${value.toString()}'));
            },
            child: Text('GET request'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('post button clicked');
              ///使用自定义的方法或者封装类中的静态方法发起POST请求
              /// _postRequest();
              HttpRequest.request(_postType,method: 'post', params: {"user":"jam"})
              .then((value) => debugPrint('receive data ${value.toString()}'));
            },
            child: Text('POST request'),
          ),
        ],
      ),
    );
  }
}


///封装DIO网络库
///封装常用的网络参数
class HttpConfig {
  static final String BASE_URL = 'https://httpbin.org';
  static final int TIME_OUT = 15;
}

class HttpRequest {
  static final baseOptions = BaseOptions(
    baseUrl: HttpConfig.BASE_URL,
    connectTimeout: Duration(seconds: HttpConfig.TIME_OUT),
    sendTimeout: Duration(seconds: HttpConfig.TIME_OUT),
    receiveTimeout: Duration(seconds: HttpConfig.TIME_OUT),
  );

  static final mdio = Dio(baseOptions);
///把网络操作相关的功能封装成独立的方法，网络操作相关的数据通过url和params参数传递
  static Future<T> request<T>(String url,{
        String method='get',
        required Map<String,dynamic> params,
        Interceptor? interceptor,
      }) async {

    final option = Options(method: method);

    ///添加拦截器
    Interceptor _interceptor = InterceptorsWrapper(
      onRequest: (options,handler) {
        // print('request: '+ options.toString());
        print('request: '+ options.toString());
        return handler.next(options);
        },
      onResponse: (response,handler){
        print('response: ' + response.toString());
        return handler.next(response);
        },
      onError: (error,handler) {
        print('response: ' + error.toString());
        return handler.next(error);
        },
    );
    mdio.interceptors.add(_interceptor);

    ///默认也会抛出异常，这里只用来捕获特定的异常
    try {
      Response response = await mdio.request(
          url, queryParameters: params, options: option);
      return response.data;
    }on DioException catch (e) {
      print(e.toString());
      return Future.error(e);
    }
  }
  ///可以依据HTTP请求类型封装不同的方法，也可以直接使用request方法，通过指定参数来使用不同的请求类型
  static void get(String url) {
    // request(url,method:get);
  }
}
