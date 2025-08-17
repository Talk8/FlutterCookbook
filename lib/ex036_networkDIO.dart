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

  ///生活指数
  // https://api.seniverse.com/v3/life/suggestion.json?key=your_api_key&location=shanghai&language=zh-Hans&days=5
  static const PATH_LIFE_SUGGESTOIN = "/v3/life/suggestion.json?";
//  返回结果 如下：
/*
{
  "results": [
    {
      "location": {
        "id": "WTW3SJ5ZBJUY",
        "name": "上海",
        "country": "CN",
        "path": "上海,上海,中国",
        "timezone": "Asia/Shanghai",
        "timezone_offset": "+08:00"
      },
      "suggestion": {
        "ac": {
          //空调开启
          "brief": "较少开启", //简要建议
          "details": "您将感到很舒适，一般不需要开启空调。" //详细建议
        },
        "air_pollution": {
          //空气污染扩散条件
          "brief": "较差",
          "details": "气象条件较不利于空气污染物稀释、扩散和清除，请适当减少室外活动时间。"
        },
        "airing": {
          //晾晒
          "brief": "不太适宜",
          "details": "天气阴沉，不利于水分的迅速蒸发，不太适宜晾晒。若需要晾晒，请尽量选择通风的地点。"
        },
        "allergy": {
          //过敏
          "brief": "极不易发",
          "details": "天气条件极不易诱发过敏，可放心外出，享受生活。"
        },
        "beer": {
          //啤酒
          "brief": "较不适宜",
          "details": "您将会感到有些凉意，建议饮用常温啤酒，并少量饮用为好。"
        },
        "boating": {
          //划船
          "brief": "较适宜",
          "details": "白天较适宜划船，但天气阴沉，气温稍低，请注意加衣，小心着凉。"
        },
        "car_washing": {
          //洗车
          "brief": "不宜",
          "details": "不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。"
        },
        "chill": {
          //风寒
          "brief": "凉",
          "details": "感觉有点凉，室外活动注意适当增减衣物。"
        },
        "comfort": {
          //舒适度
          "brief": "较舒适",
          "details": "白天天气阴沉，会感到有点儿凉，但大部分人完全可以接受。"
        },
        "dating": {
          //约会
          "brief": "较适宜",
          "details": "虽然天空有些阴沉，但情侣们可以放心外出，不用担心天气来调皮捣乱而影响了兴致。"
        },
        "dressing": {
          //穿衣
          "brief": "较冷",
          "details": "建议着厚外套加毛衣等服装。年老体弱者宜着大衣、呢外套加羊毛衫。"
        },
        "fishing": {
          //钓鱼
          "brief": "较适宜",
          "details": "较适合垂钓，但天气稍凉，会对垂钓产生一定的影响。"
        },
        "flu": {
          //感冒
          "brief": "较易发",
          "details": "天气较凉，较易发生感冒，请适当增加衣服。体质较弱的朋友尤其应该注意防护。"
        },
        "hair_dressing": {
          //美发
          "brief": "一般",
          "details": "注意防晒，洗发不宜太勤，建议选用保湿防晒型洗发护发品。出门请戴上遮阳帽或打遮阳伞。"
        },
        "kiteflying": {
          //放风筝
          "brief": "不宜",
          "details": "天气不好，不适宜放风筝。"
        },
        "makeup": {
          //化妆
          "brief": "保湿",
          "details": "皮肤易缺水，用润唇膏后再抹口红，用保湿型霜类化妆品。"
        },
        "mood": {
          //心情
          "brief": "较差",
          "details": "天气阴沉，会感觉莫名的压抑，情绪低落，此时将所有的悲喜都静静地沉到心底，在喧嚣的尘世里，感受片刻恬淡的宁静。"
        },
        "morning_sport": {
          //晨练
          "brief": "不宜",
          "details": "阴天，早晨天气寒冷，请尽量避免户外晨练，若坚持室外晨练请注意保暖防冻，建议年老体弱人群适当减少晨练时间。"
        },
        "night_life": {
          //夜生活
          "brief": "较不适宜",
          "details": "有降水，会给您的出行带来很大的不便，建议就近或最好在室内进行夜生活。"
        },
        "road_condition": {
          //路况
          "brief": "干燥",
          "details": "阴天，路面比较干燥，路况较好。"
        },
        "shopping": {
          //购物
          "brief": "适宜",
          "details": "阴天，在这种天气里去逛街，省去了涂防晒霜，打遮阳伞的麻烦，既可放松身心，又会有很多意外收获。"
        },
        "sport": {
          //运动
          "brief": "较适宜",
          "details": "阴天，较适宜进行各种户内外运动。"
        },
        "sunscreen": {
          //防晒
          "brief": "弱",
          "details": "属弱紫外辐射天气，长期在户外，建议涂擦SPF在8-12之间的防晒护肤品。"
        },
        "traffic": {
          //交通
          "brief": "良好",
          "details": "阴天，路面干燥，交通气象条件良好，车辆可以正常行驶。"
        },
        "travel": {
          //旅游
          "brief": "适宜",
          "details": "天气较好，温度适宜，总体来说还是好天气哦，这样的天气适宜旅游，您可以尽情地享受大自然的风光。"
        },
        "umbrella": {
          //雨伞
          "brief": "不带伞",
          "details": "阴天，但降水概率很低，因此您在出门的时候无须带雨伞。"
        },
        "uv": {
          //紫外线
          "brief": "最弱",
          "details": "属弱紫外线辐射天气，无需特别防护。若长期在户外，建议涂擦SPF在8-12之间的防晒护肤品。"
        }
      },
      "last_update": "2015-11-28T14:10:48+08:00"
    }
  ]
}
 */
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
        print('request: '+ options.toString());
        print('request: baseUrl: '+ options.baseUrl);
        print('request: path: '+ options.path);
        print('request: url: '+ options.uri.toString());
        print('request: queryParams: '+ options.queryParameters.toString());
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
