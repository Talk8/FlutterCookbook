import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/network.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/request/test_request.dart';
import 'package:fluttercookbook/x_z_weather_bean_entity.dart';
import 'package:fluttercookbook/ex038_NetworkDemo/core/networkException.dart';
import '_private_data.dart';

///与90到96章回的内容匹配，包含网络请求参数配置，dio封装，JSON数据解析等内容
///ex038目录下的代码是另外一种封装dio的思路，最大的区别是包含了适配器，可以mock数据
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

    ///获取天气信息，网络框架使用httpRequest,请求参数使用map添加
    _getWeatherInfo() async {
      var url = HttpConfig.BASE_URL+HttpConfig.PATH_TIAN_QI_SHI_KUANG;
      Map<String,String> queryParams = {};
      queryParams['key'] = PrivateKey.key;
      queryParams['location'] = 'beijing';
      queryParams['language'] = 'zh-Hans';
      queryParams['unit'] = 'c';

      TestRequest _testRequest = TestRequest();
      _testRequest.addRequestParams('key',PrivateKey.key)
          .addRequestParams('location', 'beijing')
          .addRequestParams('language', 'zh-Hans')
          .addRequestParams('unit', 'c');
      HttpRequest.request(url, params: queryParams)
      .then((value){
        debugPrint(XZWeatherBeanEntity.fromJson(value).toString());
        XZWeatherBeanEntity.fromJson(value).results?.forEach((element) {
          print("now: ${element.now}");
        });
      });
    }

    ///获取天气信息，网络框架使用httpRequest,但是请求参数使用testRequest.
    _getWeatherInfoByTestRequest() async {
      TestRequest _testRequest = TestRequest();
      _testRequest.addRequestParams('key',PrivateKey.key)
          .addRequestParams('location', 'beijing')
          .addRequestParams('language', 'zh-Hans')
          .addRequestParams('unit', 'c');
      ///params为空，因为testrequest中已经包含
      HttpRequest.request(_testRequest.url(), params:{})
          .then((value){
        debugPrint(XZWeatherBeanEntity.fromJson(value).toString());
        XZWeatherBeanEntity.fromJson(value).results?.forEach((element) {
          print("now: ${element.now}");
        });
      });
    }

    ///使用封装的网络框架发起Http请求,一定要封装成异步方法，不然无法捕获到异常
    _mockRequest() async {
      TestRequest testRequest = TestRequest();
      testRequest.addHeader("token","token-value");
      testRequest.addRequestParams("key1", "value1").addRequestParams("key2", "value2");
      var result;
      try {
        result = await NetworkWrapper.getInstance()?.fire(testRequest);
      }on NeedAuth catch(e) {
        print('NeedAuth error');
        debugPrint(e.toString());
      }on NeedLogin catch(e) {
        print('NeedLogin error');
        debugPrint(e.toString());
      }on DioException catch(e) {
        print('dio error');
        debugPrint(e.toString());
      } catch (e) {
        print('other error');
        debugPrint(e.toString());
      }

      debugPrint("result: ${result.toString()}");
    }


    ///使用封装的network网络框架发起Http请求,
    _dioRequest() async {
      ///base url在baseReqeust中设置，path在testRequest的path方法中设定。这里只添加body中的内容
      ///也就是baseRequest中queryParams中的数据
      TestRequest testRequest = TestRequest();
      testRequest.addRequestParams('key',PrivateKey.key)
      .addRequestParams('location', 'beijing')
      .addRequestParams('language', 'zh-Hans')
      .addRequestParams('unit', 'c');

      // debugPrint(' before fire: ${testRequest.toString()}');

      var result;
      try {
        result = await NetworkWrapper.getInstance()?.fire(testRequest);
      }on NeedAuth catch(e) {
        print('NeedAuth error');
        debugPrint(e.toString());
      }on NeedLogin catch(e) {
        print('NeedLogin error');
        debugPrint(e.toString());
      }catch (e) {
        print('other error');
        debugPrint(e.toString());
      }

      debugPrint("result: ${result.toString()}");
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
          ElevatedButton(
            onPressed: () {
              debugPrint('get weather button clicked');
              _getWeatherInfo();
            },
            child: Text('get weather by HttpRequest'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('get weather button clicked');
              _getWeatherInfoByTestRequest();
            },
            child: Text('get weather by TestRequest'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('network button clicked');
              _mockRequest();
            },
            child: Text('mock Network Framework request'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('weather button clicked');
              _dioRequest();
            },
            child: Text('weather data request by network'),
          ),
        ],
      ),
    );
  }
}


///封装DIO网络库
///封装常用的网络参数
class HttpConfig {
  // static final String BASE_URL = 'https://httpbin.org';
  static const String BASE_URL = "https://api.seniverse.com";
  static const int TIME_OUT = 15;
  var _getTypeUUID = "https://httpbin.org/uuid";

  ///对应天气实况
  // var TIAN_QI_SHI_KUANG = "https://api.seniverse.com/v3/weather/now.json?key=your_api_key&location=beijing&language=zh-Hans&unit=c";
  static const PATH_TIAN_QI_SHI_KUANG = "/v3/weather/now.json";

  ///对应24小时逐小时天气预报
  // var HOUR24 = "https://api.seniverse.com/v3/weather/hourly.json?key=your_api_key&location=beijing&language=zh-Hans&unit=c&start=0&hours=24";
  static const PATH_HOUR24 = "/v3/weather/hourly.json";
  ///对应未来15天逐日天气预报和和昨日天气，不过免费的key只能获取3天的天气预报
  // var FORECAST_DAYS = "https://api.seniverse.com/v3/weather/daily.json?key=your_api_key&location=beijing&language=zh-Hans&unit=c&start=0&days=3";
  static const PATH_FORECAST_DAYS = "/v3/weather/daily.json";
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
        ///调试时再打开，主要有来显示请求相关的数据
        // print('request: '+ options.toString());
        // print('request: baseUrl: '+ options.baseUrl);
        // print('request: path: '+ options.path);
        // print('request: url: '+ options.uri.toString());
        // print('request: queryParams: '+ options.queryParameters.toString());
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
